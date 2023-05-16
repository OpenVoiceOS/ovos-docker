#!/bin/bash

# Install PHAL admin plugins via pip command when a setup.py exists
phal_admin_list=~/.config/mycroft/phal_admin.list
if test -f "$phal_admin_list"; then
    pip3 install -r "$phal_admin_list"
fi

# Clear Python cache
rm -rf "${HOME}"/.cache

# Run ovos_PHAL_admin
ovos_PHAL_admin

