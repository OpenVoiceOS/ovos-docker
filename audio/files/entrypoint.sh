#!/bin/bash

# tts.list file is deprecated and will be removed
tts_list=~/.config/mycroft/tts.list
audio_list=~/.config/mycroft/audio.list

# Only here until tts.list full removal
file=""
if test -f "$tts_list"; then
    file=$tts_list
    echo "tts.list file is deprecated, please use audio.list instead"
elif test -f "$audio_list"; then
    file=$audio_list
fi

# Install TTS plugins, OCP plugins or others Python libraries via pip command when a setup.py exists
if [ -n "$file" ]; then
    pip3 install -r "$file"
fi

# Clear Python cache
rm -rf ~/.cache/pip


# Run ovos-audio
ovos-audio
