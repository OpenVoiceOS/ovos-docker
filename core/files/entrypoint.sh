#!/bin/bash

# Install skills via pip command when a setup.py exists
skills_list=~/.config/mycroft/skills.list
skills_list_state=~/.local/state/skills.state
if test -f "$skills_list"; then
    if ! diff -q -B <(grep -vE '^\s*(#|$)' "$skills_list") <(grep -vE '^\s*(#|$)' "$skills_list_state" 2>/dev/null) &>/dev/null; then
        pip3 install --no-cache-dir -r "$skills_list"
        cp "$skills_list" "$skills_list_state"
    fi
fi

# Create skills directory if doesn't exist
skills_directory=~/.local/share/mycroft/skills
if ! test -d "$skills_directory"; then
    mkdir -p "$skills_directory"
fi
cd "$skills_directory" || exit

# Loop over each skills into the skills directory and install
# Python requirements if a requirements.txt file exists.
# shellcheck disable=SC2045
for skill in $(ls -d -- */ 2>/dev/null); do
    cd "$skill" || exit
    if test -f requirements.txt; then
        pip3 install --no-cache-dir -r requirements.txt
    fi
    pip3 install .
    cd ..
done

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

# Run ovos-core
ovos-core
