#!/usr/bin/env python3
"""Record what a channel's images were just built from (used by build-images.yml `merge`).

Writes/updates state/<channel>.json with, per target: repository, manifest-list digest, the
ovos-releases commit the constraints came from, the set of Python packages installed (from the
SBOM attestation of the amd64 image), and the build time. scripts/affected.py reads this to
decide what a constraints change requires rebuilding, without touching the registry.
"""
import json
import subprocess
import sys
from datetime import datetime, timezone


def sbom_python_packages(ref):
    out = subprocess.run(["docker", "buildx", "imagetools", "inspect", ref, "--format", "{{json .SBOM}}"],
                         capture_output=True, text=True, check=True).stdout
    doc = json.loads(out or "null")
    names = set()

    def walk(node):
        if isinstance(node, dict):
            for pkg in node.get("packages", []) if isinstance(node.get("packages"), list) else []:
                for ref_ in pkg.get("externalRefs", []) or []:
                    loc = ref_.get("referenceLocator", "")
                    if loc.startswith("pkg:pypi/"):
                        names.add(loc[len("pkg:pypi/"):].split("@", 1)[0])
            for v in node.values():
                walk(v)
        elif isinstance(node, list):
            for v in node:
                walk(v)

    walk(doc)
    return sorted(names)


def main():
    state_file, channel, constraints_ref, entries_file = sys.argv[1:5]
    try:
        state = json.load(open(state_file))
    except FileNotFoundError:
        state = {}
    state.setdefault("channel", channel)
    state.setdefault("images", {})
    entries = json.load(open(entries_file))   # [{target, repo, digest, amd64_digest}]
    now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    for e in entries:
        # digests are identical on every registry the image was pushed to; read the SBOM from the
        # mirror when there is one (no pull-rate limit)
        pkgs = sbom_python_packages(f"{e.get('mirror') or e['repo']}@{e['amd64_digest']}")
        state["images"][e["target"]] = {
            "repo": e["repo"], "mirror": e.get("mirror", ""), "digest": e["digest"],
            "constraints_ref": constraints_ref, "packages": pkgs, "built": now,
        }
        print(f"{e['target']}: {len(pkgs)} python packages", file=sys.stderr)
    state["ovos_releases_ref"] = constraints_ref
    state["updated"] = now
    json.dump(state, open(state_file, "w"), indent=1, sort_keys=True)
    open(state_file, "a").write("\n")


if __name__ == "__main__":
    main()
