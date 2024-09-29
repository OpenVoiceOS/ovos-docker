#!/bin/bash

# Install PHAL admin plugins via pip command when a setup.py exists
phal_admin_list=~/.config/mycroft/phal_admin.list
phal_admin_list_state=~/.local/state/phal_admin.state
if test -f "$phal_admin_list"; then
    if ! diff -q -B <(grep -vE '^\s*(#|$)' "$phal_admin_list") <(grep -vE '^\s*(#|$)' "$phal_admin_list_state" 2>/dev/null) &>/dev/null; then
        pip3 install --no-cache-dir -r "$phal_admin_list"
        cp "$phal_admin_list" "$phal_admin_list_state"
    fi
fi

# Clear Python cache
rm -rf "${HOME}"/.cache

# Run ovos_PHAL_admin
ovos_PHAL_admin
