# Open Voice OS container images

[![Open Voice OS](https://img.shields.io/badge/OpenVoiceOS-containers-blue)](https://openvoiceos.com/)
[![Documentation](https://img.shields.io/badge/Documentation-latest-purple)](https://openvoiceos.github.io/ovos-docker/)
[![Registry](https://img.shields.io/badge/Registry-docker.io%2Fsmartgic-2e7d32)](https://hub.docker.com/u/smartgic)
[![Debian version](https://img.shields.io/badge/Debian-Trixie-yellow)](https://www.debian.org)
[![Python version](https://img.shields.io/badge/Python-3.13-orange)](https://python.org)
[![Chat](https://img.shields.io/matrix/openvoiceos:matrix.org)](https://matrix.to/#/#OpenVoiceOS:matrix.org)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/ebeee74fb69f43b0b255416208f884de)](https://app.codacy.com/gh/OpenVoiceOS/ovos-docker/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

[![Open Voice OS logo](https://raw.githubusercontent.com/OpenVoiceOS/ovos-docker/dev/docs/assets/logo.png)](https://openvoiceos.org/)

This repo holds the Dockerfiles and Buildx Bake configuration for the container images of [Open Voice OS](https://openvoiceos.org/), an open-source voice assistant platform. The images cover the core runtime, its services, GUIs, and default skills. Docker Buildx Bake builds and publishes the images.

## Documentation

Follow the dedicated [documentation](https://openvoiceos.github.io/ovos-docker/) for compose files, audio setup, GUI setup, and device mapping.

## What this repo builds

- Base layers: `ovos-base`, `ovos-sound-base`
- Core runtime: `ovos-core`
- Services: `ovos-audio`, `ovos-cli`, `ovos-listener`, `ovos-messagebus`, `ovos-phal`, `ovos-phal-admin`, `ovos-plugin-ggwave`, `ovos-gui-websocket`
- Skills: `ovos-skill-base` plus the default skill images in `docker-bake.hcl`

## Run images

These images run on Docker or Podman.

- Docker: `docker pull docker.io/smartgic/ovos-core:alpha`
- Podman: `podman pull docker.io/smartgic/ovos-core:alpha`

For compose files, audio/GUI setup, and device mapping examples, follow the
documentation.

## Build requirements

- Docker with Buildx (BuildKit) available for builds
- Podman works for running images, but builds use Docker Buildx Bake
- Network access to pull base images and dependencies
- Multi-arch builds may need binfmt/qemu. `scripts/bake.sh` can install it with
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

- Groups: `default`, `stack`, `services`, `skills`
- Individual targets are defined in `docker-bake.hcl`

### Configuration

Defaults are defined in `docker-bake.hcl` and `scripts/bake.sh`:

- `REGISTRY` (default `docker.io/smartgic`)
- `TAG` and `VERSION` (default `alpha`)
- `LATEST_TAG` (default `latest`, only applied when `TAG=stable`)
- `CHANNEL` (default `alpha`, used for constraints files)
- `OVOS_RELEASES_REF` (default `main`, git ref of [ovos-releases](https://github.com/OpenVoiceOS/ovos-releases) the `constraints-${CHANNEL}.txt` file is taken from; pass a commit SHA for a reproducible build)
- `CACHE_REPO` (default `ghcr.io/openvoiceos/ovos-docker-cache`, registry build cache, read anonymously) and `CACHE_TO` (default off; `max` exports the cache, CI does this)
- `SKILLS` (list of skill names built as `skill-<name>` from `skills/skill-<name>`; edit it in `docker-bake.hcl` to add a skill)
- `PLATFORMS` (default `linux/amd64,linux/arm64`)
- `UV_PRERELEASE` (default `allow`)
- `ENSURE_BINFMT` (default `auto`, set `true` to force or `false` to skip)
- `BUILDER` (default `ovos-bake`)

Examples:

- `REGISTRY=docker.io/smartgic TAG=alpha CHANNEL=alpha ./scripts/bake.sh`
- `TAG=stable CHANNEL=stable ./scripts/bake.sh -T services`
- `OVOS_RELEASES_REF=<commit sha> ./scripts/bake.sh -T listener` (pin the constraints to one ovos-releases commit)

## Automation

Images are built by GitHub Actions on native amd64 and arm64 runners and published as multi-arch
manifest lists (see `.github/workflows/`):

| Workflow | Trigger | What it builds |
|---|---|---|
| `on-push.yml` | commit on `dev` | the targets whose build context changed, plus everything built on top of them, for `alpha`, `testing` and `stable` |
| `on-constraints.yml` | `repository_dispatch` from ovos-releases, hourly poll, manual | per channel, the images that contain a package whose `constraints-<channel>.txt` line changed since they were last built |
| `pull-request.yml` | pull request | the affected targets, both architectures, no push |
| `scheduled-rebuild.yml` | weekly | every image of a channel |
| `build-images.yml` | called by the above, or manually | the reusable build: resolve → build per arch → verify (labels, platform, runtime smoke test on each arch) + vulnerability scan → merge (+ cosign, `<channel>-YYYYMMDD` tag) |

`scripts/affected.py` is the selector; the `build-state` branch records what each channel was built
from (digest, ovos-releases commit, installed packages). Every image carries the label
`io.openvoiceos.constraints.ref` with the ovos-releases commit its constraints came from.

## Related projects

- [OpenVoiceOS/ovos-core](https://github.com/OpenVoiceOS/ovos-core): the core runtime this repo packages
- [OpenVoiceOS/ovos-docker-stt](https://github.com/OpenVoiceOS/ovos-docker-stt): speech-to-text container images
- [OpenVoiceOS/ovos-docker-tts](https://github.com/OpenVoiceOS/ovos-docker-tts): text-to-speech container images

## Support

- [Matrix channel](https://matrix.to/#/#openvoiceos:matrix.org)
- [Contribute to Open Voice OS](https://openvoiceos.github.io/community-docs/contributing/)
- [Report bugs related to these Docker images](https://github.com/OpenVoiceOS/ovos-docker/issues)

## License

This repo is under the [Apache License 2.0](LICENSE).
