# Open Voice OS running on Docker/Podman

[![Open Voice OS version](https://img.shields.io/badge/OpenVoiceOS-0.0.8-green)](https://openvoiceos.com/)
[![Debian version](https://img.shields.io/badge/Debian-Bookworm-green.svg?style=flat&logoColor=FFFFFF&color=87567)](https://www.debian.org)

- [Open Voice OS running on Docker/Podman](#open-voice-os-running-on-dockerpodman)
  - [What is Open Voice OS?](#what-is-open-voice-os)
  - [How does it work with Docker/Podman?](#how-does-it-work-with-dockerpodman)
  - [Supported architectures and tags](#supported-architectures-and-tags)
    - [Architectures](#architectures)
    - [Tags](#tags)
  - [Requirements](#requirements)
  - [How to build these images](#how-to-build-these-images)
    - [Message bus](#message-bus)
    - [Listener](#listener)
  - [How to use these images](#how-to-use-these-images)
  - [Skills](#skills)
  - [Support](#support)

## What is Open Voice OS?

[![Open Voice OS logo](https://openvoiceos.com/wp-content/uploads/2021/04/ovos-egg.png)](https://openvoiceos.com/)

[Open Voice OS](https://openvoiceos.com/) is a community-driven, open-source voice AI platform for creating custom voice-controlled ​interfaces across devices with NLP, a customizable UI, and a focus on privacy and security.

More information about Open Voice OS genesis [here](https://openvoiceos.com/a-brief-history-of-open-voice-os/).

## How does it work with Docker/Podman?

Open Voice OS is a complex piece of software which has several core services. These core services have been split into containers to provide isolation and a micro service approach.

| Container            | Description                                                                                                                  |
| ---                  | ---                                                                                                                          |
| `ovos_messagebus`    | Message bus service, the nervous system of OpenVoiceOS                                                                       |
| `ovos_phal`          | PHAL is our Platform/Hardware Abstraction Layer, it completely replaces the concept of hardcoded enclosure from mycroft-core |
| `ovos_phal_admin`    | This service is intended for handling any OS-level interactions requiring escalation of privileges                           |
| `ovos_audio`         | The audio service handles playback and queueing of tracks                                                                    |
| `ovos_listener`      | The speech client is responsible for loading STT, VAD and Wake Word plugins                                                  |
| `ovos_core`          | The core service is responsible for loading skills and intent parsers                                                        |
| `ovos_cli`           | Command line for OpenVoiceOS                                                                                                 |
| `ovos_gui_websocket` | Websocket process to handle messages for the OpenVoiceOS GUI                                                                 |

To allow data persistance, Docker/Podman volumes are required which will avoid to download requirements everytime that the the containers are re-created.

| Volume                  | Description                                      |
| ---                     | ---                                              |
| `ovos_listener_records` | Wake word and utterance records                  |
| `ovos_models`           | Models downloaded by `precise-lite`              |
| `ovos_vosk`             | Data downloaded by VOSK during the initial boot  |

## Supported architectures and tags

### Architectures

| Architecture | Information                                        |
| ---          | ---                                                |
| `amd64`      | Such as AMD and Intel processors                   |
| `aarch64`    | Such as Raspberry Pi 3/4 64-bit                    |

*These are examples, many other boards use these CPU architectures.*

### Tags

| Tag | Description                                                                      |
| --  | ---                                                                              |
| `dev`/`latest` | Nightly build based on the latest commits applied to the `dev` branch |
| `stable`       | The latest stable version based on release versions *(e.g `0.0.8`)*   |

## Requirements

Docker or Podman is of course required and `docker compose`/`podman compose` is a nice to have to simplify the whole process by using the `docker-compose.yml` files *(this will be embedded depending your Docker/Podman version)*.

PulseAudio is a requirement and has to be up and running on the host to expose a socket and a cookie and to allow as well the containers to use the microphone and speakers. On modern Linux distribution, Pipewire handles the sound stack on the system, make sure PulseAudio support is enabled within PipeWire.

## How to build these images

The `base` image is the main image for the other images, for example the `messagebus` image requires the `base` image to be build. The `sound-base` image is based on the `base` image as well but it's role is dedicated to images that requires sound capabilities such as `audio`, `listener`, `phal` *etc...*

```bash
git clone https://github.com/OpenVoiceOS/ovos-docker.git
cd ovos-docker
docker buildx build base/ -t smartgic/ovos-base:dev --build-arg BRANCH=dev --no-cache
```

Open Voice OS provides two *(2)* different implementations for the bus as well for the listener:

### Message bus

- `ovos-messagebus` image which is a Python implementation
- `ovos-bus-server` image which is a C++ implementation *(better performances but lack of configuration)*

### Listener

- `ovos-listener` image which is currently the default listener
- `ovos-listener-dinkum` image which is a port from Mycroft DinKum *(better performances, less resources consumption but still under heavy development)*

Only one implementation can be selected at a time.

Thirteen *(13)* images needs to be build; `ovos-base`, `ovos-listener` or `ovos-listener-dinkum`, `ovos-core`, `ovos-cli`, `ovos-messagebus` or `ovos-bus-server`, `ovos-phal`, `ovos-phal-admin`, `ovos-sound-base`, `ovos-audio`, `ovos-gui` and `ovos-gui-websocket`.

## How to use these images

`docker-compose.yml` files provides an easy way to provision the Docker stack *(volumes and containers)* with the required configuration for each of them. `docker compose` supports environment file, check the `.env` *(`.env-raspberrypi` for Raspberry Pi)* files prior the execution to set your custom values.

```bash
git clone https://github.com/OpenVoiceOS/ovos-docker.git
mkdir -p ~/ovos/{config,share,tmp}
chown 1000:1000 -R ~/ovos
cd ovos-docker
docker compose up -d
```

By default, `docker compose` will look for a `docker-compose.yml` and an `.env` files but more files could be added to the command to extend the services configuration.

```bash
docker compose -f docker-compose.yml -f docker-compose.raspberrypi.yml --env-file .env --env-file .env-raspberrypi up -d
```

## Skills

## Support

- [Matrix channel](https://matrix.to/#/#openvoiceos:matrix.org)
- [Open Voice OS documentation](https://openvoiceos.github.io/community-docs/)
- [Contribute to Open Voice OS](https://openvoiceos.github.io/community-docs/contributing/)
- [Report bugs related to these Docker images](https://github.com/OpenVoiceOS/ovos-docker/issues)
