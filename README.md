# Open Voice OS container images

[![Open Voice OS](https://img.shields.io/badge/OpenVoiceOS-containers-blue)](https://openvoiceos.com/)
[![Documentation](https://img.shields.io/badge/Documentation-latest-purple)](https://openvoiceos.github.io/ovos-docker/)
[![Registry](https://img.shields.io/badge/Registry-docker.io%2Fsmartgic-2e7d32)](https://hub.docker.com/u/smartgic)
[![Debian version](https://img.shields.io/badge/Debian-Trixie-yellow)](https://www.debian.org)
[![Python version](https://img.shields.io/badge/Python-3.13-orange)](https://python.org)
[![Chat](https://img.shields.io/matrix/openvoiceos:matrix.org)](https://matrix.to/#/#OpenVoiceOS:matrix.org)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/ebeee74fb69f43b0b255416208f884de)](https://app.codacy.com/gh/OpenVoiceOS/ovos-docker/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

[![Open Voice OS logo](https://openvoiceos.github.io/ovos-docker/assets/logo.png)](https://openvoiceos.org/)

This repository holds the Dockerfiles, the Docker Buildx Bake configuration, and the
compose files for the container images of [Open Voice OS](https://openvoiceos.org/), an
open-source voice assistant platform. The images cover the core runtime, its services, and
the default skills. GitHub Actions builds the images for `amd64` and `arm64` and publishes
them to Docker Hub and to a GHCR mirror.

## Documentation

Read the [documentation](https://openvoiceos.github.io/ovos-docker/) for the compose files,
the audio setup, and the device mapping.

## What this repository builds

- Base layers: `ovos-base`, `ovos-sound-base`, `ovos-skill-base`
- Core runtime: `ovos-core`
- Services: `ovos-audio`, `ovos-cli` (also a terminal client, see below), `ovos-listener`,
  `ovos-messagebus`, `ovos-phal`, `ovos-phal-admin`, `ovos-gui-websocket`
- Skills: one image per entry of the `SKILLS` list in `docker-bake.hcl`

All Python images share `ovos-base` (Debian slim, Python 3.13, a virtual environment, and a
pinned [uv](https://github.com/astral-sh/uv)). Each image has a `HEALTHCHECK`, an SBOM, a
provenance attestation, and a cosign signature.

## Talking to OVOS from a terminal

The `ovos-cli` image ships [ovos-tui-client](https://github.com/andlo/ovos-tui-client),
a split-pane terminal for talking to OVOS without a microphone: type what you would have
said, read the reply, and watch which skill answered.

```shell
docker exec -it ovos_cli ovos-tui
```

No flags needed. The container runs with `network_mode: host`, so it reaches the
messagebus on `127.0.0.1:8181`, and the config and state volumes are already mounted
where the client looks for them.

`-it` is required: unlike the other services this is an interactive program and needs a
terminal attached.

## Run images

The images run on Docker or on Podman.

- Docker: `docker pull docker.io/smartgic/ovos-core:alpha`
- Podman: `podman pull docker.io/smartgic/ovos-core:alpha`

The same images, with the same tags and digests, are available from the mirror
`ghcr.io/openvoiceos/ovos-docker`. Use the mirror if Docker Hub limits your pulls.

### Tags

| Tag | Content |
|---|---|
| `alpha` | Built from `constraints-alpha.txt` of [ovos-releases](https://github.com/OpenVoiceOS/ovos-releases): alpha releases from PyPI |
| `testing` | Built from `constraints-testing.txt`: stable versions selected for testing |
| `stable` | Built from `constraints-stable.txt` |
| `latest` | The same image as `stable` |
| `<channel>-YYYYMMDD` | An immutable copy of a channel tag, for rollbacks |

## Build requirements

- Docker with Buildx (BuildKit). Podman runs the images, but the builds use Docker Buildx Bake.
- Network access, to pull the base images and the dependencies.
- For multi-arch builds, binfmt/qemu. `scripts/bake.sh` can install it with
  `tonistiigi/binfmt` (set `ENSURE_BINFMT=true`, or use `--ensure-binfmt`).

## Build images

Docker Buildx Bake builds the images (`docker-bake.hcl` and `scripts/bake.sh`). Do not use
`docker build` directly: the base image wiring relies on Bake contexts.

### Quick examples

- Local build (amd64 only, loaded into Docker): `./scripts/bake.sh --load --no-push`
- Multi-arch publish (default registry and tag): `./scripts/bake.sh`
- Multi-arch alpha publish: `TAG=alpha CHANNEL=alpha VERSION=alpha PLATFORMS=linux/amd64,linux/arm64 ./scripts/bake.sh`
- Build a subset: `./scripts/bake.sh -T stack`, or `./scripts/bake.sh -T skills`
- Disable the registry cache: `./scripts/bake.sh --no-cache-from --load --no-push`

Note: `--load` forces `linux/amd64`, because Docker cannot load multi-arch manifests locally.

### Targets

- Groups: `default`, `stack`, `services`, `skills`
- The individual targets are defined in `docker-bake.hcl`

### Configuration

`docker-bake.hcl` and `scripts/bake.sh` define the defaults:

- `REGISTRY` (default `docker.io/smartgic`)
- `MIRROR_REGISTRY` (default empty; CI uses `ghcr.io/openvoiceos/ovos-docker`): a second registry each image is also pushed to
- `TAG` and `VERSION` (default `alpha`)
- `LATEST_TAG` (default `latest`; applied only when `TAG=stable`)
- `CHANNEL` (default `alpha`): selects the constraints file
- `OVOS_RELEASES_REF` (default `main`): the git ref of [ovos-releases](https://github.com/OpenVoiceOS/ovos-releases) that supplies `constraints-${CHANNEL}.txt`. Give a commit SHA for a reproducible build.
- `CACHE_REPO` (default `ghcr.io/openvoiceos/ovos-docker-cache`): the registry build cache, readable without login
- `CACHE_TO` (default off): set `max` to also export the build cache. CI does this.
- `SKILLS`: the list of skill names. Each name builds `skill-<name>` from `skills/skill-<name>`. Add a skill here.
- `PLATFORMS` (default `linux/amd64,linux/arm64`)
- `UV_PRERELEASE` (default `allow`): the `uv pip` pre-release policy. Use `if-necessary-or-explicit` for `testing` and `stable`.
- `ENSURE_BINFMT` (default `auto`): set `true` to force the binfmt installation, or `false` to skip it
- `BUILDER` (default `ovos-bake`): the Buildx builder name

Examples:

- `REGISTRY=docker.io/smartgic TAG=alpha CHANNEL=alpha ./scripts/bake.sh`
- `TAG=stable CHANNEL=stable UV_PRERELEASE=if-necessary-or-explicit ./scripts/bake.sh -T services`
- `OVOS_RELEASES_REF=<commit sha> ./scripts/bake.sh -T listener`

## Automation

GitHub Actions builds the images on native `amd64` and `arm64` runners and publishes them as
multi-arch manifest lists. The workflows are in `.github/workflows/`:

| Workflow | Trigger | What it builds |
|---|---|---|
| `on-push.yml` | A commit on `dev` | The targets whose build context changed, plus the targets built on top of them, for `alpha`, `testing`, and `stable` |
| `on-constraints.yml` | A `repository_dispatch` from ovos-releases, an hourly poll, or a manual run | For each channel, the images that contain a package whose `constraints-<channel>.txt` line changed since the last build |
| `pull-request.yml` | A pull request | The affected targets, for both architectures, without a push |
| `scheduled-rebuild.yml` | Once a week | Every image of a channel |
| `build-images.yml` | The workflows above, or a manual run | The reusable build: resolve, build per architecture, verify (labels, platform, a runtime smoke test on each architecture), scan for vulnerabilities, then merge (with a cosign signature and a `<channel>-YYYYMMDD` tag) |
| `record-state.yml` | The end of a publishing run | The `build-state` branch: what each channel was built from |

`scripts/affected.py` selects the targets. The `build-state` branch records, for each
channel, the digest, the ovos-releases commit, and the installed packages of each image. Each
image carries the label `io.openvoiceos.constraints.ref` with the ovos-releases commit that
supplied its constraints.

## Related projects

- [OpenVoiceOS/ovos-core](https://github.com/OpenVoiceOS/ovos-core): the core runtime that these images package
- [OpenVoiceOS/ovos-installer](https://github.com/OpenVoiceOS/ovos-installer): installs Open Voice OS with these images, or in a virtual environment
- [OpenVoiceOS/ovos-releases](https://github.com/OpenVoiceOS/ovos-releases): the constraints files that pin the packages of each channel
- [OpenVoiceOS/ovos-docker-stt](https://github.com/OpenVoiceOS/ovos-docker-stt): speech-to-text container images
- [OpenVoiceOS/ovos-docker-tts](https://github.com/OpenVoiceOS/ovos-docker-tts): text-to-speech container images
- [JarbasHiveMind/hivemind-docker](https://github.com/JarbasHiveMind/hivemind-docker): HiveMind container images

## Support

- [Matrix channel](https://matrix.to/#/#openvoiceos:matrix.org)
- [Contribute to Open Voice OS](https://www.openvoiceos.org/contribution)
- [Report bugs related to these container images](https://github.com/OpenVoiceOS/ovos-docker/issues)

## License

This repository is under the [Apache License 2.0](LICENSE).
