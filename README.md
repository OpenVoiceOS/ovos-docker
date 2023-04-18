# Open Voice OS running on Docker/Podman

[![Open Voice OS version](https://img.shields.io/badge/OpenVoiceOS-0.0.8-green)](https://openvoiceos.com/)
[![Debian version](https://img.shields.io/badge/Debian-Bookworm-green.svg?style=flat&logoColor=FFFFFF&color=87567)](https://www.debian.org)

- [Open Voice OS running on Docker/Podman](#open-voice-os-running-on-dockerpodman)
  - [What is Open Voice OS?](#what-is-open-voice-os)
  - [How does it work with Docker/Podman?](#how-does-it-work-with-dockerpodman)
  - [Supported architectures and tags](#supported-architectures-and-tags)
    - [Architectures](#architectures)
    - [Tags](#tags)

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
| `ovos_skills`        | The skills service is responsible for loading skills and intent parsers                                                      |
| `ovos_cli`           | Command line for OpenVoiceOS                                                                                                 |
| `ovos_gui_websocket` | Websocket process to handle messages for the OpenVoiceOS GUI                                                                 |

To allow data persistance, Docker/Podman volumes are required which will avoid to download requirements everytime that the the containers are re-created.

| Volume        | Description                                      |
| ---           | ---                                              |
| `ovos_models` | Models downloaded by `precise-lite`              |
| `ovos_vosk`   | Data downloaded by VOSK during the initial boot  |

## Supported architectures and tags

### Architectures

| Architecture | Information                                        |
| ---          | ---                                                |
| `amd64`      | Such as AMD and Intel processors                   |
| `aarch64`    | Such as Raspberry Pi 3/4 64-bit                    |

*These are examples, many other boards use these CPU architectures.*

### Tags

| Tag | Description                                                                         |
| --  | ---                                                                                 |
| `dev`/`latest`    | Nightly build based on the latest commits applied to the `dev` branch |
