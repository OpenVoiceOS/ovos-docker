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
| `skills`     | `skill-base` plus one `skill-<name>` image per entry of the `SKILLS` list in `docker-bake.hcl` |

Adding a skill is one entry in `SKILLS` plus a `skills/skill-<name>/Dockerfile`;
the bake target, tags and cache settings are generated from the list.

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
| `CHANNEL`         | `alpha`                       | Constraints channel (`alpha`, `testing`, `stable`)            |
| `OVOS_RELEASES_REF` | `main`                      | Git ref of [ovos-releases](https://github.com/OpenVoiceOS/ovos-releases) the `constraints-${CHANNEL}.txt` file is taken from; a commit SHA makes the build reproducible |
| `UV_PRERELEASE`   | `allow`                       | `uv pip` prerelease policy; use `if-necessary-or-explicit` for `testing`/`stable` (CI does) |
| `CACHE_REPO`      | `ghcr.io/openvoiceos/ovos-docker-cache` | Registry build cache, read anonymously                |
| `CACHE_TO`        | _(empty)_                     | `max` also exports the build cache (needs GHCR write access; CI does this) |
| `MIRROR_REGISTRY` | _(empty)_                     | Second registry every image is also pushed to (CI: `ghcr.io/openvoiceos`); the pipeline reads manifests, labels and SBOMs from it |
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
  packages via `uv pip`. `constraints-alpha.txt` pins pre-releases;
  `constraints-testing.txt` and `constraints-stable.txt` are ranges of stable
  versions, so they must be built with `if-necessary-or-explicit`.
- `OVOS_RELEASES_REF` pins the constraints file to a commit of
  `ovos-releases`. The file is fetched with `ADD`, so BuildKit rebuilds the
  install layer exactly when the constraints change, and every image records
  the commit in the `io.openvoiceos.constraints.ref` label.

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

## Continuous integration

Published images are built by GitHub Actions, not by hand:

| Workflow                 | Trigger                                              | Builds                                                                                       |
| ------------------------ | ---------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `on-push.yml`            | commit on `dev`                                      | the targets whose build context changed, plus everything built on top of them, for every channel |
| `on-constraints.yml`     | `ovos-releases` constraints change (dispatch or hourly poll) | per channel, only the images that contain a package whose constraint line changed          |
| `pull-request.yml`       | pull request                                         | the affected targets on both architectures, without pushing                                  |
| `scheduled-rebuild.yml`  | weekly                                               | every image of a channel, so base-OS fixes reach the images                                  |
| `build-images.yml`       | called by the above, or manually                     | the reusable build: resolve → build per architecture on native runners → verify → merge      |

Each architecture is built natively (`ubuntu-24.04`, `ubuntu-24.04-arm`) and
pushed as `<image>:<channel>-<arch>`. The channel tag (`<image>:<channel>`,
plus `latest` for `stable`, plus an immutable `<channel>-YYYYMMDD` tag) is a
manifest list created only after both architectures were verified, and it is
signed with [cosign](https://github.com/sigstore/cosign) (keyless). A failed
architecture therefore never moves the tag the installer pulls.

The `build-state` branch records what each channel was built from (digest,
`ovos-releases` commit, installed packages) so the poll can decide what to
rebuild without touching the registry.
