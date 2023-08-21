#!/bin/bash

# stt.list file is deprecated and will be removed
stt_list=~/.config/mycroft/stt.list
listener_list=~/.config/mycroft/listener.list

# Only here until stt.list full removal
file=""
if test -f "$stt_list"; then
    file=$stt_list
    echo "stt.list file is deprecated, please use listener.list instead"
elif test -f "$listener_list"; then
    file=$listener_list
fi

# Install STT plugins, plugins or others Python libraries via pip command when a setup.py exists
if [ -n "$file" ]; then
    pip3 install -r "$file"
fi

# Clear Python cache
rm -rf "${HOME}"/.cache

# Run ovos-dinkum-listener
ovos-dinkum-listener
