#!/bin/bash

# Install PHAL plugins via pip command when a setup.py exists
phal_list=~/.config/mycroft/phal.list
if test -f "$phal_list"; then
    pip3 install -r "$phal_list"
fi

# Clear Python cache
rm -rf ~/.cache/pip

# Auto-detect which sound server is running (PipeWire or PulseAudio)
if pactl info &> /dev/null; then
    echo -e 'pcm.!default pulse\nctl.!default pulse' > ~/.asoundrc
elif pw-link --links &> /dev/null; then
    echo -e 'pcm.!default pipewire\nctl.!default pipewire' > ~/.asoundrc
fi

# Run ovos-PHAL
ovos_PHAL
