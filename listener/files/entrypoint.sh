#!/bin/bash

# stt.list file is deprecated and will be removed
stt_list=~/.config/mycroft/stt.list
listener_list=~/.config/mycroft/listener.list
listener_list_state=/.local/state/mycroft/listener.state

# Only here until stt.list full removal
file=""
if test -f "$stt_list"; then
    file="$stt_list"
    echo "stt.list file is deprecated, please use listener.list instead"
elif test -f "$listener_list"; then
    file="$listener_list"
fi

# Install STT plugins, plugins or others Python libraries via pip command when a setup.py exists
if [ -n "$file" ]; then
    if ! diff -q -B <(grep -vE '^\s*(#|$)' "$file") <(grep -vE '^\s*(#|$)' "$listener_list_state" 2>/dev/null) &>/dev/null; then
        pip3 install --no-cache-dir -r "$file"
        cp "$file" "$listener_list_state"
    fi
fi

# Clear Python cache
rm -rf ~/.cache/pip

# Auto-detect which sound server is running (PipeWire or PulseAudio)
asoundrc_file=~/.asoundrc
if test -f ~/.config/mycroft/asoundrc; then
    cp -rfp ~/.config/mycroft/asoundrc "$asoundrc_file"
else
    if pw-link --links &>/dev/null; then
        echo -e 'pcm.!default pipewire\nctl.!default pipewire' >"$asoundrc_file"
    elif pactl info &>/dev/null; then
        echo -e 'pcm.!default pulse\nctl.!default pulse' >"$asoundrc_file"
    fi
fi

# Run ovos-dinkum-listener
ovos-dinkum-listener
