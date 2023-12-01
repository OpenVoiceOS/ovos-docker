#!/bin/bash

# tts.list file is deprecated and will be removed
tts_list=~/.config/mycroft/tts.list
audio_list=~/.config/mycroft/audio.list
audio_list_state=/tmp/audio.state

# Only here until tts.list full removal
file=""
if test -f "$tts_list"; then
    file="$tts_list"
    echo "tts.list file is deprecated, please use audio.list instead"
elif test -f "$audio_list"; then
    file="$audio_list"
fi

# Install TTS plugins, OCP plugins or others Python libraries via pip command when a setup.py exists
if [ -n "$file" ]; then
    if ! diff -q -B <(grep -vE '^\s*(#|$)' "$file") <(grep -vE '^\s*(#|$)' "$audio_list_state" 2>/dev/null) &>/dev/null; then
        pip3 install -r "$file"
        cp "$file" "$audio_list_state"
    fi
fi

# Clear Python cache
rm -rf ~/.cache/pip

# Auto-detect which sound server is running (PipeWire or PulseAudio)
asoundrc_file=~/.asoundrc
if test -f ~/.config/mycroft/asoundrc; then
    cp -rfp ~/.config/mycroft/asoundrc "$asoundrc_file"
else
    if pactl info &>/dev/null; then
        echo -e 'pcm.!default pulse\nctl.!default pulse' >"$asoundrc_file"
    elif pw-link --links &>/dev/null; then
        echo -e 'pcm.!default pipewire\nctl.!default pipewire' >"$asoundrc_file"
    fi
fi

# Run ovos-audio
ovos-audio
