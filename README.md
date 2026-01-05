# Open Voice OS container images

[![Open Voice OS](https://img.shields.io/badge/OpenVoiceOS-containers-blue)](https://openvoiceos.com/)
[![Documentation](https://img.shields.io/badge/Documentation-latest-purple)](https://openvoiceos.github.io/ovos-docker/)
[![Registry](https://img.shields.io/badge/Registry-docker.io%2Fsmartgic-2e7d32)](https://hub.docker.com/u/smartgic)
[![Debian version](https://img.shields.io/badge/Debian-Trixie-yellow)](https://www.debian.org)
[![Python version](https://img.shields.io/badge/Python-3.13-orange)](https://python.org)
[![Chat](https://img.shields.io/matrix/openvoiceos:matrix.org)](https://matrix.to/#/#OpenVoiceOS:matrix.org)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/ebeee74fb69f43b0b255416208f884de)](https://app.codacy.com/gh/OpenVoiceOS/ovos-docker/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

[![Open Voice OS logo](https://raw.githubusercontent.com/OpenVoiceOS/ovos-docker/dev/docs/assets/logo.png)](https://openvoiceos.org/)

## Documentation

Please follow the dedicated [documentation](https://openvoiceos.github.io/ovos-docker/).

## What this repo builds

- Base layers: `ovos-base`, `ovos-sound-base`
- Core runtime: `ovos-core`
- Services: `ovos-audio`, `ovos-cli`, `ovos-listener`, `ovos-messagebus`, `ovos-phal`, `ovos-phal-admin`, `ovos-plugin-ggwave`, `ovos-gui-websocket`
- GUIs: `ovos-gui-original`, `ovos-gui-shell`
- Skills: `ovos-skill-base` plus the default skill images in `docker-bake.hcl`

## Run images

These images run on Docker or Podman. For compose files, audio/GUI setup, and device
mapping examples, follow the documentation.

- Docker: `docker pull docker.io/smartgic/ovos-core:alpha`
- Podman: `podman pull docker.io/smartgic/ovos-core:alpha`

## Build requirements

- Docker with Buildx (BuildKit) available for builds
- Podman works for running images, but builds use Docker Buildx Bake
- Network access to pull base images and dependencies
- Multi-arch builds may require binfmt/qemu; `scripts/bake.sh` can install it via
  `tonistiigi/binfmt` (set `ENSURE_BINFMT=true` or use `--ensure-binfmt`)

## Build images

Builds are handled via Docker Buildx Bake (`docker-bake.hcl` and `scripts/bake.sh`).
Direct `docker build` usage is not supported because base image wiring relies on
Bake contexts.

### Quick examples

- Local build (amd64 only, loads to local Docker): `./scripts/bake.sh --load --no-push`
- Multi-arch publish (default registry/tag): `./scripts/bake.sh`
- Multi-arch alpha publish: `TAG=alpha CHANNEL=alpha VERSION=alpha PLATFORMS=linux/amd64,linux/arm64 ./scripts/bake.sh`
- Build a subset: `./scripts/bake.sh -T stack` or `./scripts/bake.sh -T skills`
- Disable registry cache: `./scripts/bake.sh --no-cache-from --load --no-push`
- Note: `--load` forces `linux/amd64` because Docker cannot load multi-arch manifests locally.

### Targets

- Groups: `default`, `stack`, `services`, `skills`, `guis`
- Individual targets are defined in `docker-bake.hcl`

### Configuration

Defaults are defined in `docker-bake.hcl` and `scripts/bake.sh`:

- `REGISTRY` (default `docker.io/smartgic`)
- `TAG` and `VERSION` (default `alpha`)
- `LATEST_TAG` (default matches `TAG`, `stable` builds also tag `latest`)
- `CHANNEL` (default `alpha`, used for constraints files)
- `PLATFORMS` (default `linux/amd64,linux/arm64`)
- `UV_PRERELEASE` (default `allow`)
- `ENSURE_BINFMT` (default `auto`, set `true` to force or `false` to skip)
- `BUILDER` (default `ovos-bake`)

Examples:

- `REGISTRY=docker.io/smartgic TAG=alpha CHANNEL=alpha ./scripts/bake.sh`
- `TAG=stable CHANNEL=stable ./scripts/bake.sh -T services`

## Support

- [Matrix channel](https://matrix.to/#/#openvoiceos:matrix.org)
- [Contribute to Open Voice OS](https://openvoiceos.github.io/community-docs/contributing/)
- [Report bugs related to these Docker images](https://github.com/OpenVoiceOS/ovos-docker/issues)
