#!/usr/bin/env bash
set -euo pipefail

# Install skills via pip command when a setup.py exists
skills_list="${HOME}/.config/mycroft/skills.list"
skills_list_state="${HOME}/.local/state/mycroft/skills.state"

if [[ -f "$skills_list" ]]; then
    if ! diff -q -B <(grep -vE '^\s*(#|$)' "$skills_list") <(grep -vE '^\s*(#|$)' "$skills_list_state" 2>/dev/null) &>/dev/null; then
        echo "Installing skills from $skills_list"
        pip3 install -r "$skills_list" -c "https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${OVOS_CHANNEL}.txt"
        cp "$skills_list" "$skills_list_state"
    fi
fi

# Create skills directory if it doesn't exist
skills_directory="${HOME}/.local/share/mycroft/skills"
if [[ ! -d "$skills_directory" ]]; then
    mkdir -p "$skills_directory"
fi
cd "$skills_directory" || exit 1

# Loop over each skill in the skills directory and install
# Python requirements if a requirements.txt file exists.
for skill_dir in */; do
    [[ -d "$skill_dir" ]] || continue

    echo "Processing skill: $skill_dir"
    cd "$skill_dir" || {
        echo "Error: Cannot enter directory $skill_dir" >&2
        continue
    }

    if [[ -f "requirements.txt" ]]; then
        echo "Installing requirements for $skill_dir"
        pip3 install -r requirements.txt -c "https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${OVOS_CHANNEL}.txt"
    fi

    echo "Installing skill $skill_dir"
    pip3 install . -c "https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${OVOS_CHANNEL}.txt"

    cd "$skills_directory" || exit 1
done

# Auto-detect which sound server is running (PipeWire or PulseAudio)
asoundrc_file="${HOME}/.asoundrc"
mycroft_asoundrc="${HOME}/.config/mycroft/asoundrc"

if [[ -f "$mycroft_asoundrc" ]]; then
    cp "$mycroft_asoundrc" "$asoundrc_file"
else
    if pw-link --links &>/dev/null; then
        echo "Configuring for PipeWire"
        printf 'pcm.!default pipewire\nctl.!default pipewire\n' >"$asoundrc_file"
    elif pactl info &>/dev/null; then
        echo "Configuring for PulseAudio"
        printf 'pcm.!default pulse\nctl.!default pulse\n' >"$asoundrc_file"
    fi
fi

# Run ovos-core
echo "Starting ovos-core"
exec ovos-core
