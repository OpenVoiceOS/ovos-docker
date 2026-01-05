# Build images

OVOS images are built with Docker Buildx Bake. The wrapper script
`scripts/bake.sh` sets sane defaults, handles multi-arch builds, and wires the
base image dependencies defined in `docker-bake.hcl`.

!!! note "Run from the repo root"

    `scripts/bake.sh` expects to be run from the repository root where
    `docker-bake.hcl` lives.

!!! warning "Docker Buildx required"

    Builds require Docker with Buildx (BuildKit). Podman works for running
    images, but builds use Docker Buildx Bake.

!!! note "Registry defaults"

    Buildx Bake defaults to `docker.io/smartgic`, matching the compose bundles.
    If you publish to a different registry, make sure your compose files point
    to it.

## Quick examples

```shell
./scripts/bake.sh --load --no-push
TAG=alpha CHANNEL=alpha VERSION=alpha PLATFORMS=linux/amd64,linux/arm64 ./scripts/bake.sh
TAG=stable CHANNEL=stable ./scripts/bake.sh
./scripts/bake.sh -T services
REGISTRY=docker.io/smartgic TAG=alpha CHANNEL=alpha ./scripts/bake.sh
```

## Targets and groups

| Target/group | Includes                                                                                  |
| ------------ | ----------------------------------------------------------------------------------------- |
| `default`    | All images defined in `docker-bake.hcl`                                                    |
| `stack`      | `base`, `sound-base`, `core`                                                              |
| `services`   | `audio`, `cli`, `core`, `gui-websocket`, `listener`, `messagebus`, `phal`, `phal-admin`, `plugin-ggwave` |
| `guis`       | `gui-original`, `gui-shell`                                                               |
| `skills`     | `skill-base` plus the skill images listed in `docker-bake.hcl`                             |

Build a single target with `-T`, for example:

```shell
./scripts/bake.sh -T core
./scripts/bake.sh -T skill-wikipedia
```

## Variables

Defaults come from `scripts/bake.sh` and `docker-bake.hcl`:

| Variable          | Default                       | Description                                                   |
| ----------------- | ----------------------------- | ------------------------------------------------------------- |
| `REGISTRY`        | `docker.io/smartgic`           | Registry prefix for tags                                      |
| `TAG`             | `alpha`                       | Image tag to publish                                          |
| `LATEST_TAG`      | `latest`                      | Additional tag applied only when `TAG=stable`                 |
| `VERSION`         | `alpha`                       | Version label passed into images                              |
| `CHANNEL`         | `alpha`                       | Constraints channel (e.g., `alpha`, `stable`)                 |
| `UV_PRERELEASE`   | `allow`                       | `uv pip` prerelease policy                                    |
| `PLATFORMS`       | `linux/amd64,linux/arm64`      | Platforms to build                                            |
| `TARGETS`         | `default`                     | Bake targets/groups                                           |
| `PUSH`            | `true`                        | Push images to the registry                                   |
| `LOAD`            | `false`                       | Load images locally (forces `linux/amd64`)                    |
| `CACHE_FROM`      | `true`                        | Enable registry cache-from                                    |
| `ENSURE_BINFMT`   | `auto`                        | `auto`, `true`, or `false` binfmt/qemu installation           |
| `BUILDER`         | `ovos-bake`                   | Buildx builder name for multi-arch builds                     |

`BUILD_DATE` and `GIT_SHA` are set automatically by `scripts/bake.sh`.

## Build args and constraints

The Dockerfiles use a few build args that are set via Bake:

- `VERSION` sets image labels and is exposed in runtime metadata.
- `CHANNEL`/`OVOS_CHANNEL` selects the constraints file from
  `ovos-releases` (for example, `constraints-alpha.txt`).
- `UV_PRERELEASE` controls pre-release resolution for images that install
  packages via `uv pip`.

## Notes

- `--load` and `--push` are mutually exclusive.
- `--load` forces `linux/amd64` because Docker cannot load multi-arch manifests locally.
- When `TAG=stable`, Bake also tags `LATEST_TAG` (default `latest`).
- For multi-arch builds, `scripts/bake.sh` installs binfmt/qemu automatically
  when needed (set `ENSURE_BINFMT=true` or pass `--ensure-binfmt` to force, or
  `ENSURE_BINFMT=false`/`--no-binfmt` to skip).
- The script switches to a `docker-container` buildx builder for multi-arch
  builds (override with `BUILDER` or `--builder`).
- Use `--no-cache-from` if registry cache is unavailable or not desired.
