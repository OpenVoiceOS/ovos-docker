#!/bin/bash

# Install PHAL plugins via pip command when a setup.py exists
phal_list=~/.config/mycroft/phal.list
phal_list_state=~/.local/state/phal.state
if test -f "$phal_list"; then
    if ! diff -q -B <(grep -vE '^\s*(#|$)' "$phal_list") <(grep -vE '^\s*(#|$)' "$phal_list_state" 2>/dev/null) &>/dev/null; then
        pip3 install --no-cache-dir -r "$phal_list"
        cp "$phal_list" "$phal_list_state"
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

# Run ovos-PHAL
ovos_PHAL
