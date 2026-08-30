#!/usr/bin/env python3
"""Select the docker-bake.hcl targets that a change requires rebuilding.

Two kinds of change are understood:

  paths        files changed in this repository (a push or a pull request):
               a target is affected when a file under its build context changed, or when
               docker-bake.hcl changed (everything); dependents follow through the
               `contexts = { "...": "target:<name>" }` edges of the bake file.

  constraints  a new revision of OpenVoiceOS/ovos-releases constraints-<channel>.txt:
               a target is affected when a package whose constraint line changed between the
               revision its image was last built from (build-state record) and the new revision
               is installed in that image (SBOM), or when no record exists for it yet.

Output: a JSON list of target names on stdout. The bake graph always comes from
`docker buildx bake --print`, so this never drifts from the HCL.
"""
import argparse
import json
import re
import subprocess
import sys


def bake_print(roots):
    out = subprocess.run(["docker", "buildx", "bake", "--print", *roots],
                         capture_output=True, text=True, check=True).stdout
    return json.loads(out)


def parents_of(bake):
    """target -> set of targets it is built from (bake `contexts` pointing at target:<name>)."""
    parents = {}
    for name, t in bake["target"].items():
        parents[name] = {v[len("target:"):] for v in (t.get("contexts") or {}).values()
                         if isinstance(v, str) and v.startswith("target:")}
    return parents


def with_dependents(parents, seeds):
    affected = set(seeds)
    grown = True
    while grown:
        grown = False
        for name, ps in parents.items():
            if name not in affected and ps & affected:
                affected.add(name)
                grown = True
    return affected


GLOBAL_FILES = ("docker-bake.hcl",)


def by_paths(bake, files):
    targets = set(bake["target"])
    if any(f in GLOBAL_FILES for f in files):
        return sorted(targets)
    seeds = set()
    for name, t in bake["target"].items():
        ctx = (t.get("context") or ".").rstrip("/") + "/"
        if any(f.startswith(ctx) for f in files):
            seeds.add(name)
    return sorted(with_dependents(parents_of(bake), seeds))


NAME_RE = re.compile(r"^\s*([A-Za-z0-9][A-Za-z0-9._-]*)")


def normalize(name):
    # PEP 503 normalisation, so ovos_utils / ovos-utils / Ovos.Utils compare equal
    return re.sub(r"[-_.]+", "-", name).lower()


def parse_constraints(text):
    lines = {}
    for line in text.splitlines():
        line = line.split("#", 1)[0].strip()
        m = NAME_RE.match(line)
        if line and m:
            lines[normalize(m.group(1))] = line
    return lines


def changed_between(before, after):
    b, a = parse_constraints(before), parse_constraints(after)
    return {n for n in set(b) | set(a) if b.get(n) != a.get(n)}


def by_constraints(bake, state, befores, after):
    """befores: {constraints_ref: file text} for every ref recorded in state; after: file text."""
    records = (state or {}).get("images", {})
    targets, reasons = [], {}
    for name in bake["target"]:
        rec = records.get(name)
        if rec is None:                       # never recorded for this channel -> build it
            targets.append(name)
            reasons[name] = "no build record"
            continue
        before = befores.get(rec.get("constraints_ref"))
        if before is None:                    # recorded ref unknown/unfetchable -> build it
            targets.append(name)
            reasons[name] = "constraints of last build unavailable"
            continue
        installed = {normalize(p) for p in rec.get("packages", [])}
        hit = changed_between(before, after) & installed
        if hit:
            targets.append(name)
            reasons[name] = ", ".join(sorted(hit))
    return sorted(targets), reasons


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--roots", default="default", help="bake targets/groups that define the universe (default: default)")
    sub = ap.add_subparsers(dest="mode", required=True)
    p = sub.add_parser("paths", help="targets affected by changed files")
    p.add_argument("--files", help="newline-separated file list (default: read from stdin)")
    c = sub.add_parser("constraints", help="targets affected by a constraints file change")
    c.add_argument("--state", required=True, help="build-state JSON for the channel ({} if none)")
    c.add_argument("--before-dir", required=True,
                   help="directory with <constraints_ref>.txt for every ref recorded in the state")
    c.add_argument("--after", required=True, help="constraints file to build against now")
    args = ap.parse_args()

    bake = bake_print(args.roots.split())
    if args.mode == "paths":
        text = open(args.files).read() if args.files else sys.stdin.read()
        files = [f.strip() for f in text.splitlines() if f.strip()]
        targets = by_paths(bake, files)
        print(f"changed files: {len(files)} -> targets: {len(targets)}", file=sys.stderr)
    else:
        import os
        state = json.load(open(args.state))
        befores = {f[:-4]: open(os.path.join(args.before_dir, f)).read()
                   for f in os.listdir(args.before_dir) if f.endswith(".txt")}
        targets, reasons = by_constraints(bake, state, befores, open(args.after).read())
        for t in targets:
            print(f"{t}: {reasons[t]}", file=sys.stderr)
        print(f"targets: {len(targets)}", file=sys.stderr)
    print(json.dumps(targets))


if __name__ == "__main__":
    main()
