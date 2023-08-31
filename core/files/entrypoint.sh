#!/bin/bash

# Install skills via pip command when a setup.py exists
skills_list=~/.config/mycroft/skills.list
if test -f $skills_list; then
    pip3 install -r $skills_list
fi

# Create skills directory if doesn't exist
skills_directory=~/.local/share/mycroft/skills
if ! test -d $skills_directory; then
    mkdir -p $skills_directory
fi
cd $skills_directory || exit

# Loop over each skills into the skills directory and install
# Python requirements if a requirements.txt file exists.
# shellcheck disable=SC2045
for skill in $(ls -d -- */ 2> /dev/null); do
    cd "$skill" || exit
    if test -f requirements.txt; then
        pip3 install -r requirements.txt
    fi
    pip3 install .
    cd ..
done

# Clear Python cache
rm -rf ~/.cache/pip

# Auto-detect which sound server is running (PipeWire or PulseAudio)
if pactl info &> /dev/null; then
    echo -e 'pcm.!default pulse\nctl.!default pulse' > ~/.asoundrc
elif pw-link --links &> /dev/null; then
    echo -e 'pcm.!default pipewire\nctl.!default pipewire' > ~/.asoundrc
fi

# Run ovos-core
ovos-core
