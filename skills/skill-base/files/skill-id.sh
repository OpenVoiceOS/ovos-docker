#!/bin/sh
# The skill id this image's package registers, which is what ovos-skill-launcher must be
# given. A skill's id can change between its releases, and so between channels: stable's
# weather registers skill-ovos-weather.openvoiceos, alpha's ovos-skill-weather.openvoiceos.
# So no Dockerfile writes the id. Each skill image saves the one its package registers at
# build time (--save), which fails the build unless there is exactly one, and the launcher
# and the health check read it back without starting Python.
set -eu

saved="${VIRTUAL_ENV:-/home/ovos/.venv}/ovos-skill-id"

if [ "${1:-}" = "--save" ]; then
  python - "$saved" << 'RESOLVE'
import sys
from importlib.metadata import entry_points

ids = sorted({ep.name for group in ("opm.skill", "ovos.plugin.skill") for ep in entry_points(group=group)})
if len(ids) != 1:
    sys.exit(f"ovos-skill-id: an image runs one skill, and its packages register {len(ids)}: "
             f"{', '.join(ids) or 'none'}")
with open(sys.argv[1], "w") as out:
    out.write(ids[0] + "\n")
print(ids[0])
RESOLVE
  exit 0
fi

cat "$saved"
