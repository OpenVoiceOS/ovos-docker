#!/usr/bin/env python3
"""Derive, write and check contract.yml - what a consumer may rely on from this repository.

ovos-installer clones this repository at a pinned ref and runs the compose files out of it. That
makes several things a public interface even though nothing declares them: the compose file names,
the container names it execs into, the environment variables the compose reads, and the image
repositories it pulls. All four have broken an install before, always silently and always far from
the change that caused it - a compose file that started reading HIVEMIND_SITEID kept working, it
just quietly used the literal string "default" instead of the site id the installer had collected.

contract.yml states those four, and this script keeps it honest: --check fails when the file and
the compose files disagree, so the declaration cannot rot in place.

Two fields are not derivable and are preserved when rewriting:

  owner: installer   the consumer is expected to supply this value even though the compose has a
                     default for it. That is exactly the HIVEMIND_SITEID case - "has a fallback"
                     and "nobody needs to set it" are different claims, and only the second one is
                     safe to skip.
  description        free text for a reader.

Usage:
  scripts/contract.py            check contract.yml against compose/ (exit 1 on drift)
  scripts/contract.py --write    rewrite contract.yml, preserving the fields above
"""
import argparse
import re
import sys
from pathlib import Path

import yaml

class IndentedDumper(yaml.SafeDumper):
    """Indent sequences under their key.

    PyYAML writes a list flush with its parent key, which yamllint - and so ansible-lint in the
    consumer repository, which reads this file - rejects. Emitting it correctly here keeps the
    generated file lintable wherever it is vendored.
    """

    def increase_indent(self, flow=False, indentless=False):
        return super().increase_indent(flow, False)


COMPOSE_DIR = Path("compose")
CONTRACT = Path("contract.yml")

NAME = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")
# Compose operators that let a value stand on its own when the variable is unset. `-` and `:-`
# substitute the default; `+` and `:+` substitute nothing, which is still a usable empty string.
# `?` and `:?` are the opposite: they state no default and fail, so they leave the name required.
OPTIONAL_OPERATORS = ("-", ":-", "+", ":+")


def compose_variables(value: str):
    """Yield (name, optional) for every variable compose interpolates in this scalar.

    A regex cannot do this. `${PRIMARY:-${FALLBACK}}` nests, and any pattern that ends the
    expression at the first `}` stops inside the default and never sees FALLBACK, which compose
    both interpolates and warns about when it is unset. So braces are matched by depth and the
    text after the operator is scanned in turn, because it is a value like any other.

    `$$` is compose's escape for a literal dollar and yields nothing. Compose does not restrict
    names to upper case, so neither does this.
    """
    index, end = 0, len(value)
    while index < end:
        char = value[index]
        if char != "$":
            index += 1
            continue
        if value.startswith("$$", index):
            index += 2
            continue
        if value.startswith("${", index):
            depth, cursor = 1, index + 2
            while cursor < end and depth:
                if value[cursor] == "{":
                    depth += 1
                elif value[cursor] == "}":
                    depth -= 1
                cursor += 1
            if depth:
                # An unterminated `${`: compose would reject the file, so there is no
                # interpolation here to report.
                return
            body = value[index + 2:cursor - 1]
            match = NAME.match(body)
            if match:
                operator = body[match.end():]
                yield match.group(0), operator.startswith(OPTIONAL_OPERATORS)
                # The default or replacement is itself interpolated.
                yield from compose_variables(operator)
            index = cursor
            continue
        match = NAME.match(value, index + 1)
        if match:
            # A bare $VAR cannot carry a default.
            yield match.group(0), False
            index = match.end()
        else:
            index += 1


def canonical_image(image: str) -> str:
    """Drop the tag and give every image an explicit registry.

    The compose files spell the same registry both ways - "smartgic/x" and "docker.io/smartgic/x" -
    so without this the contract would report a change whenever one of them was edited.
    """
    repository = re.sub(r":\$\{?[A-Za-z_][A-Za-z0-9_]*\}?$", "", image)
    host = repository.split("/", 1)[0]
    if "." not in host and ":" not in host and host != "localhost":
        repository = f"docker.io/{repository}"
    return repository


def interpolated_values(node):
    """Yield the scalars compose interpolates.

    Compose substitutes into values, never into keys, so walking the parsed document instead of
    the raw text keeps a key - or a comment - that happens to contain a dollar sign out of the
    contract.
    """
    if isinstance(node, dict):
        for value in node.values():
            yield from interpolated_values(value)
    elif isinstance(node, list):
        for value in node:
            yield from interpolated_values(value)
    elif isinstance(node, str):
        yield node


def passthrough_env(body: dict):
    """Yield the variables a service passes through from the host environment.

    `environment: [- NAME]` and `environment: {NAME: }` name a variable and give it no value, so
    compose takes it from the host. That is a value the consumer has to supply, and no `$NAME`
    appears anywhere for the scan above to find, so the contract would otherwise miss it. A
    pass-through cannot carry a default, so it is always required.
    """
    env = body.get("environment")
    if isinstance(env, list):
        for entry in env:
            if isinstance(entry, str) and "=" not in entry:
                yield entry.strip()
    elif isinstance(env, dict):
        for name, value in env.items():
            if value is None:
                yield str(name)


def derive() -> dict:
    compose_files, services, images = [], {}, set()
    required, used_in = set(), {}

    for path in sorted(COMPOSE_DIR.glob("docker-compose*.yml")):
        compose_files.append(path.name)
        # an empty or comment-only compose file parses to None, and the glob accepts any
        # docker-compose*.yml, so this has to read as "no services" rather than crash the gate
        document = yaml.safe_load(path.read_text()) or {}

        for value in interpolated_values(document):
            for name, optional in compose_variables(value):
                used_in.setdefault(name, set()).add(path.name)
                if not optional:
                    required.add(name)

        for service, body in (document.get("services") or {}).items():
            if not isinstance(body, dict):
                continue
            for name in passthrough_env(body):
                used_in.setdefault(name, set()).add(path.name)
                required.add(name)
            if body.get("container_name"):
                # Keyed by compose file, not by service: the same service name appears in more
                # than one file (hivemind_cli is in both the stack and the satellite compose), and
                # collapsing them hides a rename in every file but the last one read.
                services.setdefault(path.name, {})[service] = body["container_name"]
            if body.get("image"):
                images.add(canonical_image(body["image"]))

    # Which compose files use a variable is part of the contract: a consumer selects a subset of
    # them by profile, and must not be asked for MATRIX_TOKEN because some other file reads it.
    # `required` stays global and conservative - required where it is used without a default.
    env = {
        name: {"required": name in required, "compose_files": sorted(files)}
        for name, files in sorted(used_in.items())
    }

    return {
        "version": 1,
        "compose_files": compose_files,
        "services": {f: dict(sorted(v.items())) for f, v in sorted(services.items())},
        "env": env,
        "images": sorted(images),
    }


def merge_annotations(derived: dict, existing: dict) -> dict:
    """Carry over the hand-written fields; everything else comes from the compose files."""
    for name, spec in (existing.get("env") or {}).items():
        if name in derived["env"]:
            for field in ("owner", "description"):
                if field in spec:
                    derived["env"][name][field] = spec[field]
    return derived


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true",
                        help="rewrite contract.yml instead of checking it")
    args = parser.parse_args()

    existing = yaml.safe_load(CONTRACT.read_text()) if CONTRACT.exists() else {}
    derived = merge_annotations(derive(), existing)

    if args.write:
        CONTRACT.write_text(
            "---\n"
            "# Generated by scripts/contract.py - run it after changing compose/.\n"
            "# What ovos-installer may rely on from this repository. `owner` and `description`\n"
            "# are hand-written and preserved; everything else is derived from the compose files.\n"
            + yaml.dump(derived, Dumper=IndentedDumper, sort_keys=False,
                        default_flow_style=False)
        )
        print(f"wrote {CONTRACT}")
        return 0

    if not existing:
        print(f"{CONTRACT} is missing; run scripts/contract.py --write", file=sys.stderr)
        return 1

    drift = []

    for field in ("compose_files", "images"):
        declared, actual = set(existing.get(field) or []), set(derived[field])
        for gone in sorted(declared - actual):
            drift.append(f"  {field}: {gone} is declared but no longer present")
        for added in sorted(actual - declared):
            drift.append(f"  {field}: {added} is present but not declared")

    declared_services = existing.get("services") or {}
    for compose_file in sorted(set(declared_services) | set(derived["services"])):
        was = declared_services.get(compose_file) or {}
        now = derived["services"].get(compose_file) or {}
        for service in sorted(set(was) | set(now)):
            if was.get(service) != now.get(service):
                drift.append(f"  services {compose_file} {service}: "
                             f"declared container_name={was.get(service)}, "
                             f"actual container_name={now.get(service)}")

    declared_env = {k: (v.get("required"), v.get("compose_files"))
                    for k, v in (existing.get("env") or {}).items()}
    actual_env = {k: (v["required"], v["compose_files"]) for k, v in derived["env"].items()}
    if declared_env != actual_env:
        for name in sorted(set(declared_env) | set(actual_env)):
            if declared_env.get(name) != actual_env.get(name):
                drift.append(f"  env {name}: declared {declared_env.get(name)}, "
                             f"actual {actual_env.get(name)}")

    if drift:
        print("contract.yml does not match compose/:", file=sys.stderr)
        print("\n".join(drift), file=sys.stderr)
        print("\nrun scripts/contract.py --write", file=sys.stderr)
        return 1

    service_count = sum(len(v) for v in derived["services"].values())
    print(f"contract.yml matches compose/ ({len(derived['compose_files'])} files, "
          f"{service_count} services, {len(derived['env'])} variables)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
