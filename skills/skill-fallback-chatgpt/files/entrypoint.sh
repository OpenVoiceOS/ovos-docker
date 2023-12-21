#!/bin/sh

# Path to the skill's configuration directory
config_skill_directory=~/.config/mycroft/skills/skill-ovos-fallback-chatgpt.openvoiceos

# Create the skill's configuration directory if it does not exists
# and a sample of settings.json file
if ! test -d "$config_skill_directory"; then
    mkdir -p "$config_skill_directory"
    cat <<EOF >"$config_skill_directory/settings.json"
{
    "key": "sk-XXXXXXXX",
    "model": "gpt-3.5-turbo",
    "persona": "You are a helpful voice assistant with a friendly tone and fun sense of humor",
    "__mycroft_skill_firstrun": false
}
EOF
fi

# Run skill-ovos-fallback-chatgpt skill
ovos-skill-launcher skill-ovos-fallback-chatgpt.openvoiceos
