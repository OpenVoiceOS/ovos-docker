#!/usr/bin/env bash
set -euo pipefail

# stt.list file is deprecated and will be removed
stt_list="${HOME}/.config/mycroft/stt.list"
listener_list="${HOME}/.config/mycroft/listener.list"
listener_list_state="${HOME}/.local/state/mycroft/listener.state"

# Only here until stt.list full removal
file=""
if [[ -f "$stt_list" ]]; then
    file="$stt_list"
    echo "stt.list file is deprecated, please use listener.list instead"
elif [[ -f "$listener_list" ]]; then
    file="$listener_list"
fi

# Install STT plugins, plugins or others Python libraries via pip command when a setup.py exists
if [[ -n "$file" ]]; then
    if ! diff -q -B <(grep -vE '^\s*(#|$)' "$file") <(grep -vE '^\s*(#|$)' "$listener_list_state" 2>/dev/null) &>/dev/null; then
        echo "Installing listener plugins from $file"
        uv pip install -r "$listener_list" -c "https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/${OVOS_RELEASES_REF:-main}/constraints-${OVOS_CHANNEL}.txt"
        cp "$file" "$listener_list_state"
    fi
fi

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

# Run ovos-dinkum-listener
echo "Starting ovos-dinkum-listener"
exec ovos-dinkum-listener
