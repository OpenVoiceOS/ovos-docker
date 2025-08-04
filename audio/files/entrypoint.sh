#!/usr/bin/env bash
set -euo pipefail

# tts.list file is deprecated and will be removed
tts_list="${HOME}/.config/mycroft/tts.list"
audio_list="${HOME}/.config/mycroft/audio.list"
audio_list_state="${HOME}/.local/state/mycroft/audio.state"

# Only here until tts.list full removal
file=""
if [[ -f "$tts_list" ]]; then
    file="$tts_list"
    echo "tts.list file is deprecated, please use audio.list instead"
elif [[ -f "$audio_list" ]]; then
    file="$audio_list"
fi

# Install TTS plugins, OCP plugins or others Python libraries via pip command when a setup.py exists
if [[ -n "$file" ]]; then
    if ! diff -q -B <(grep -vE '^\s*(#|$)' "$file") <(grep -vE '^\s*(#|$)' "$audio_list_state" 2>/dev/null) &>/dev/null; then
        echo "Installing audio plugins from $file"
        uv pip install -r "$audio_list" -c "https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${OVOS_CHANNEL}.txt"
        cp "$file" "$audio_list_state"
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

# Run ovos-audio
echo "Starting ovos-audio"
exec ovos-audio
