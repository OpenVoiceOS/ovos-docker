#!/bin/bash

# Install TTS via pip command when a setup.py exists
tts_list=~/.config/mycroft/tts.list
if test -f "$tts_list"; then
    pip3 install -r "$tts_list"
fi

# Clear Python cache
rm -rf "${HOME}"/.cache

# Run ovos-audio
ovos-audio
