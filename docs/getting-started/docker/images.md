# Images

!!! tip "Pre-built images"

    The compose bundles in `compose/` reference images hosted on Docker Hub
    under `docker.io/smartgic`. The same images, with the same tags and
    digests, are also published to `ghcr.io/openvoiceos` (for example
    `ghcr.io/openvoiceos/ovos-core:alpha`), a mirror without pull-rate limits;
    point the `image:` references of your compose files there if Docker Hub
    rate-limits you. Buildx Bake defaults to `docker.io/smartgic`; if you
    publish to a different registry, update the `image:` references in your
    compose files.

Open Voice OS is a sophisticated piece of software which has several [components](../../about/glossary/components.md). These components have been split into containers to provide better isolation and a [microservice](https://en.wikipedia.org/wiki/Microservices) approach.

!!! info "GUI images size"

    The GUI container images are larger than the other images as they need many QT libraries and [GStreamer](https://en.wikipedia.org/wiki/GStreamer) plugins in order to provide all the features supported by the voice assistant.

## Supported CPU architectures

Container images can be used for different CPU architectures using the [multi-platform images](https://docs.docker.com/build/building/multi-platform/) feature.

| CPU architecture                                               | Description                                                                    |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| :material-check-circle-outline:{ style="color: green"} `amd64` | Such as AMD and Intel processors                                               |
| :material-check-circle-outline:{ style="color: green"} `arm64` | Such as Raspberry Pi 64-bit SoC                                                |
| :material-close-circle-outline:{ style="color: red" } `armv7l` | Such as Raspberry Pi 32-bit SoC (_not supported because of `onnxruntime`[^1]_) |

## Containers

The list below is not exhaustive and doesn't mention anything about skill containers, but it is a fair list of the main components currently supported in [ovos-docker](https://github.com/OpenVoiceOS/ovos-docker).

| Container            | Description                                                                                   |
| -------------------- | --------------------------------------------------------------------------------------------- |
| `ovos_messagebus`    | [Read more about ovos-messagebus](../../about/glossary/components.md#ovos-messagebus)         |
| `ovos_phal`          | [Read more about ovos-phal](../../about/glossary/components.md#ovos-phal)                     |
| `ovos_phal_admin`    | [Read more about ovos-phal admin variant](../../about/glossary/components.md#ovos-phal)       |
| `ovos_audio`         | [Read more about ovos-audio](../../about/glossary/components.md#ovos-audio)                   |
| `ovos_listener`      | [Read more about ovos-listener](../../about/glossary/components.md#ovos-listener)             |
| `ovos_core`          | [Read more about ovos-core](../../about/glossary/components.md#ovos-core)                     |
| `ovos_cli`           | [Read more about ovos-cli](../../about/glossary/components.md#ovos-cli)                       |
| `ovos_gui_websocket` | [Read more about ovos-gui-websocket](../../about/glossary/components.md#ovos-gui-websocket)  |
| `ovos_gui_shell`     | [Read more about ovos-gui](../../about/glossary/components.md#ovos-gui)                       |
| `ovos_gui_original`  | [Read more about ovos-gui](../../about/glossary/components.md#ovos-gui)                       |
| `ovos_plugin_ggwave` | [Read more about ovos-plugin-ggwave](../../about/glossary/components.md#ovos-plugin-ggwave)   |

## Tags

Container image tags allow you to deploy a specific version of Open Voice OS. This could be an untested version based on a nightly build or a stable version.

| Image tag                                                      | Description                                                          |
| -------------------------------------------------------------- | -------------------------------------------------------------------- |
| :material-check-circle-outline:{ style="color: green"} `alpha` | Built from `constraints-alpha.txt` of [ovos-releases](https://github.com/OpenVoiceOS/ovos-releases): alpha releases from [PyPI](https://pypi.org/), rebuilt automatically when the constraints change |
| :material-check-circle-outline:{ style="color: green"} `testing` | Built from `constraints-testing.txt`: stable versions selected for testing (the installer's default channel) |
| :material-check-circle-outline:{ style="color: green"} `stable` | Built from `constraints-stable.txt`                                  |
| :material-check-circle-outline:{ style="color: green"} `latest` | Always the same image as `stable`                                    |
| :material-check-circle-outline:{ style="color: green"} `<channel>-YYYYMMDD` | Immutable copy of a channel tag as published on that day, for rollbacks |
| :material-information-outline:{ style="color: grey"} `<channel>-amd64`, `<channel>-arm64` | Single-architecture images the build pipeline publishes before merging them; not meant to be pulled directly |

!!! warning "Tag availability"

    Tag availability depends on what has been published to the registry. Check
    the registry if you need a specific version.

!!! info "Stable alias"

    When building locally, `TAG=stable` also tags `LATEST_TAG` (default
    `latest`). Override `LATEST_TAG` if you want a different alias.

## What is inside

All Python images share one base (`ovos-base`, Debian slim with Python 3.13,
a virtual environment and a pinned [uv](https://github.com/astral-sh/uv));
services needing sound add `ovos-sound-base`, skills add `ovos-skill-base`.
Every channel tag is a multi-architecture manifest list (`amd64` + `arm64`)
carrying an SBOM and SLSA provenance attestation, signed with cosign, published
to both `docker.io/smartgic` and `ghcr.io/openvoiceos` with identical digests,
and labelled with:

| Label                                 | Content                                                                      |
| ------------------------------------- | ---------------------------------------------------------------------------- |
| `org.opencontainers.image.revision`   | `ovos-docker` commit the image was built from                                |
| `io.openvoiceos.constraints.ref`      | `ovos-releases` commit whose `constraints-<channel>.txt` pinned the packages  |
| `org.opencontainers.image.created`    | Build time                                                                    |

Verify a signature with:

```shell
cosign verify docker.io/smartgic/ovos-core:stable \
  --certificate-identity-regexp 'https://github.com/OpenVoiceOS/ovos-docker/' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

## Build images locally

If you need a private registry, custom tags, or local builds, use Docker Buildx
Bake from the source repository:

```shell
./scripts/bake.sh --load --no-push
TAG=alpha CHANNEL=alpha VERSION=alpha PLATFORMS=linux/amd64,linux/arm64 ./scripts/bake.sh
./scripts/bake.sh -T skills
```

Builds require Docker with Buildx (BuildKit). Podman works for running images,
but builds use Docker Buildx Bake.

For a full list of targets and build variables, see
[Build images](./build.md).

`--load` forces `linux/amd64` and cannot load multi-arch manifests locally.
Multi-arch builds may require binfmt/qemu; set `ENSURE_BINFMT=true` or use
`--ensure-binfmt`.

## Volumes

To allow data persistence, Docker or Podman volumes are required. They will prevent downloading the requirements every time the containers are re-created.

| Volume                  | Description                                                                                                                      |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `ovos_gui_files`        | Share QML files from skills between the GUI websocket service and the GUI client                                                  |
| `ovos_listener_records` | [Wake words](../../about/glossary/terms.md#wake-word) and [utterances](../../about/glossary/terms.md#utterance) recorded samples |
| `ovos_local_state`      | Mostly used to store logs from the different components                                                                          |
| `ovos_models`           | Models downloaded by `precise-lite` wake word plugin                                                                             |
| `ovos_nltk`             | [Punkt](https://www.askpython.com/python-modules/nltk-punkt) Python package required by [NLTK](https://www.nltk.org/index.html)  |
| `ovos_tts_cache`        | `.wav` and `.pho` files acting as cache from TTS transcription                                                                   |
| `ovos_vosk`             | Models downloaded by [VOSK](https://alphacephei.com/vosk/) during the initial boot                                               |

`ovos_listener_records` allows you to store samples of wake words and utterances which could help you to build or improve models.

!!! info "Enable samples recording"

    By default the recording features are disabled, `"record_wake_words": true` and `"save_utterances": true` will have to be added to the `listener` section of `mycroft.conf` to enable these capabilities.

    ```json title="~/ovos/config/mycroft.conf"
    {
      "listener": {
        "record_wake_words": true,
        "save_utterances": true
      }
    }
    ```

    But first thing's first you need to have Open Voice OS's containers up and running. [Follow the guide](./installation/requirements.md).

[^1]: <https://github.com/microsoft/onnxruntime/issues/15337>
