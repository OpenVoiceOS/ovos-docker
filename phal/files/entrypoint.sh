#!/bin/bash

# Install PHAL plugins via pip command when a setup.py exists
phal_list=~/.config/mycroft/phal.list
if test -f "$phal_list"; then
    pip3 install -r "$phal_list"
fi

# Clear Python cache
rm -rf "${HOME}"/.cache

# Run ovos-PHAL
ovos_PHAL
