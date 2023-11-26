#!/bin/bash

# Install PHAL plugins via pip command when a setup.py exists
phal_list=~/.config/mycroft/phal.list
if test -f "$phal_list"; then
    pip3 install -r "$phal_list"
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

# Run ovos-PHAL
ovos_PHAL
