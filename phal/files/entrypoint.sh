#!/usr/bin/env bash
set -euo pipefail

# Install PHAL plugins via pip command when a setup.py exists
phal_list="${HOME}/.config/mycroft/phal.list"
phal_list_state="${HOME}/.local/state/mycroft/phal.state"
if [[ -f "$phal_list" ]]; then
    if ! diff -q -B <(grep -vE '^\s*(#|$)' "$phal_list") <(grep -vE '^\s*(#|$)' "$phal_list_state" 2>/dev/null) &>/dev/null; then
        echo "Installing PHAL plugins from $phal_list"
        pip3 install -r "$phal_list" -c "https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${OVOS_CHANNEL}.txt"
        cp "$phal_list" "$phal_list_state"
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

# Run ovos-PHAL
echo "Starting ovos_PHAL"
exec ovos_PHAL
