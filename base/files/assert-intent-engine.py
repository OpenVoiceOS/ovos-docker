#!/usr/bin/env python3
"""Assert that this image ended up with a padatious intent engine.

padatious reaches an image only through an ovos-core extra, and which extra
carries it changed between the 1.x and 2.x lines: 1.x exposes it through
``lgpl`` and pulls ``fann2`` with it, 2.x moved it into ``plugins`` and dropped
fann2 entirely. That makes it quietly droppable - an upstream extra rename, or
a well-meant "the lgpl extra is obsolete" edit, leaves the build green and the
image useless, with no task failing anywhere.

Run as the last step of any image that installs ovos-core, so the build fails
instead of publishing. Lives in the base image so core and skill-base share one
copy: a guard that exists twice is a guard that can drift.

The fann2 expectation is derived from the padatious that actually landed rather
than from the channel, so it keeps holding once stable and testing move to a
2.x core.
"""

from importlib.metadata import PackageNotFoundError, version


def installed(name: str) -> str | None:
    """Return the installed version of *name*, or None when it is absent."""
    try:
        return version(name)
    except PackageNotFoundError:
        return None


def main() -> None:
    padatious = installed("ovos-padatious")
    if padatious is None:
        raise SystemExit(
            "no intent engine: ovos-padatious is not installed. It reaches this "
            "image only through an ovos-core extra, so an extra changed without "
            "an explicit replacement requirement."
        )

    fann2 = installed("fann2")

    # A release train, not a precise version compare: only the major matters,
    # and anything unparseable should fail loudly rather than be guessed at.
    try:
        needs_fann2 = int(padatious.split(".")[0]) < 2
    except ValueError:
        raise SystemExit(
            f"cannot tell which padatious line {padatious!r} belongs to, so "
            "whether fann2 is required is unknown"
        )

    if needs_fann2 and fann2 is None:
        raise SystemExit(
            f"ovos-padatious {padatious} is a 1.x release and needs fann2, but "
            "fann2 is not installed - the build chain was skipped where it was "
            "still required."
        )

    if not needs_fann2 and fann2 is not None:
        # Not fatal: a rebuilt layer can legitimately still carry it.
        print(
            f"note: ovos-padatious {padatious} does not need fann2, yet "
            f"fann2 {fann2} is present"
        )

    print(f"intent engine ok: ovos-padatious {padatious}, fann2 {fann2 or 'not needed'}")


if __name__ == "__main__":
    main()
