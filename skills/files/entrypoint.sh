#!/bin/bash

skills_directory=~/.local/share/mycroft/skills
cd $skills_directory || exit

# shellcheck disable=SC2045
for skill in $(ls -d -- */); do
    cd "$skill" || exit
    if test -f requirements.txt; then
        pip3 install -r requirements.txt
    fi
    pip3 install .
    cd ..
done

rm -rf "${HOME}"/.cache

ovos-core