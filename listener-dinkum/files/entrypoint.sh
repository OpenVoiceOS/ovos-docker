#!/bin/bash

# Install STT via pip command when a setup.py exists
stt_list=~/.config/mycroft/stt.list
if test -f "$stt_list"; then
    pip3 install -r "$stt_list"
fi

# Clear Python cache
rm -rf "${HOME}"/.cache

# Run ovos-dinkum-listener
ovos-dinkum-listener
