#!/usr/bin/env bash
set -euo pipefail

# Install PHAL admin plugins via pip command when a setup.py exists
phal_admin_list="${HOME}/.config/mycroft/phal_admin.list"
phal_admin_list_state="${HOME}/.local/state/mycroft/phal_admin.state"
if [[ -f "$phal_admin_list" ]]; then
    if ! diff -q -B <(grep -vE '^\s*(#|$)' "$phal_admin_list") <(grep -vE '^\s*(#|$)' "$phal_admin_list_state" 2>/dev/null) &>/dev/null; then
        echo "Installing PHAL admin plugins from $phal_admin_list"
        pip3 install -r "$phal_admin_list" -c "https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${OVOS_CHANNEL}.txt"
        cp "$phal_admin_list" "$phal_admin_list_state"
    fi
fi

# Run ovos-PHAL-admin
echo "Starting ovos-PHAL-admin"
exec ovos-PHAL-admin
