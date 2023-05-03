# Open Voice OS running on Docker/Podman

[![Open Voice OS version](https://img.shields.io/badge/OpenVoiceOS-0.0.8-blue)](https://openvoiceos.com/)
[![Debian version](https://img.shields.io/badge/Debian-Bookworm-yellow)](https://www.debian.org)
[![Chat](https://img.shields.io/matrix/openvoiceos-general:matrix.org)](https://matrix.to/#/#OpenVoiceOS-general:matrix.org)
[![Docker pulls](https://img.shields.io/docker/pulls/smartgic/ovos-base)](https://hub.docker.com/r/smartgic/ovos-base)

- [Open Voice OS running on Docker/Podman](#open-voice-os-running-on-dockerpodman)
  - [What is Open Voice OS?](#what-is-open-voice-os)
  - [How does it work with Docker/Podman?](#how-does-it-work-with-dockerpodman)
  - [Supported architectures and tags](#supported-architectures-and-tags)
    - [Architectures](#architectures)
    - [Tags](#tags)
  - [Requirements](#requirements)
    - [Docker / Podman](#docker--podman)
    - [PulseAudio](#pulseaudio)
  - [How to build these images](#how-to-build-these-images)
    - [Arguments](#arguments)
    - [Image alternatives](#image-alternatives)
      - [Message bus](#message-bus)
      - [Listener](#listener)
  - [How to use these images](#how-to-use-these-images)
  - [Skills management](#skills-management)
    - [Skill running inside ovos-core container](#skill-running-inside-ovos-core-container)
    - [Skill running as standalone container](#skill-running-as-standalone-container)
  - [Open Voice OS CLI](#open-voice-os-cli)
  - [Open Voice OS GUI](#open-voice-os-gui)
  - [FAQ](#faq)
  - [Support](#support)

## What is Open Voice OS?

[![Open Voice OS logo](https://openvoiceos.com/wp-content/uploads/2021/04/ovos-egg.png)](https://openvoiceos.com/)

[Open Voice OS](https://openvoiceos.com/) is a community-driven, open-source voice AI platform for creating custom voice-controlled ​interfaces across devices with NLP, a customizable UI, and a focus on privacy and security.

More information about Open Voice OS genesis [here](https://openvoiceos.com/a-brief-history-of-open-voice-os/).

## How does it work with Docker/Podman?

Open Voice OS is a complex piece of software which has several core components. These core components have been split into containers to provide a better isolation and a microservice approach.

| Container            | Description                                                                                                                    |
| ---                  | ---                                                                                                                            |
| `ovos_messagebus`    | Message bus service, the nervous system of Open Voice OS                                                                       |
| `ovos_phal`          | PHAL is the Platform/Hardware Abstraction Layer, it completely replaces the concept of hardcoded enclosure from `mycroft-core` |
| `ovos_phal_admin`    | This service is intended for handling any OS-level interactions requiring escalation of privileges                             |
| `ovos_audio`         | The audio service handles playback and queueing of tracks                                                                      |
| `ovos_listener`      | The speech client is responsible for loading STT, VAD and Wake Word plugins                                                    |
| `ovos_core`          | The core service is responsible for loading skills and intent parsers                                                          |
| `ovos_cli`           | Command line for Open Voice OS                                                                                                 |
| `ovos_gui_websocket` | Websocket process to handle messages for the Open Voice OS GUI                                                                 |
| `ovos_gui`           | Open Voice OS graphical user interface                                                                                         |

To allow data persistence, Docker/Podman volumes are required which will prevent to download requirements everytime that the containers are re-created.

| Volume                  | Description                                      |
| ---                     | ---                                              |
| `ovos_listener_records` | Wake word and utterance records                  |
| `ovos_models`           | Models downloaded by `precise-lite`              |
| `ovos_vosk`             | Data downloaded by VOSK during the initial boot  |

`ovos_listener_records` will allow you to retrieve recorded wake words which could help you to build or improve models. By default, the recording feature is disabled, `"record_wake_words": true` and `"save_utterances": true` will have to be added to the `listener` section of `mycroft.conf` to enable these capabilities.

## Supported architectures and tags

### Architectures

| Architecture | Information                      |
| ---          | ---                              |
| `amd64`      | Such as AMD and Intel processors |
| `aarch64`    | Such as Raspberry Pi 3/4 64-bit  |

*These are examples, many other boards use these CPU architectures.*

### Tags

| Tag | Description                                                                 |
| --  | ---                                                                         |
| `alpha` | Nightly build based on the latest commits applied to the `dev` branches |

## Requirements

### Docker / Podman

Docker or Podman is of course required and `docker compose`/`podman compose` is a nice to have to simplify the whole process of deploying the whole stack by using the `docker-compose.yml` files *(this command will be embedded depending your Docker/Podman version)*.

### PulseAudio

PulseAudio is a requirement and has to be up and running on the host to expose a socket and a cookie and to allow as well the containers to use the microphone and speakers. On modern Linux distribution, Pipewire handles the sound stack on the system, make sure PulseAudio support is enabled within PipeWire and the service is started as a user and not as `root`.

## How to build these images

The `base` image is the main image for the other images, for example the `messagebus` image requires the `base` image to be build. The `sound-base` image is based on the `base` image as well but it's role is dedicated to images that requires sound capabilities such as `audio`, `listener`, `phal`, *etc...*

**Since there is not yet a stable Open Voice OS release compatible with this current container architecture, the `--build-arg ALPHA=true` is "mandatory" to build working images *(except the `ovos-gui` and `ovos-bus-server` images)*.**

```bash
git clone https://github.com/OpenVoiceOS/ovos-docker.git
cd ovos-docker
docker buildx build base/ -t smartgic/ovos-base:alpha --build-arg ALPHA=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --no-cache
docker buildx build gui/ -t smartgic/ovos-gui:alpha --build-arg BRANCH_OVOS=master --build-arg BRANCH_MYCROFT=stable-qt5 --no-cache
```

### Arguments

There are few arguments available that could be used during the image build process.

| Name             | Value                              | Default      | Description                                                      |
| ---              | ---                                | ---          | ---                                                              |
| `ALPHA`          | `true`                             | `false`      | Using the alpha releases from PyPi built from the `dev` branches |
| `BUILD_DATE`     | `$(date -u +'%Y-%m-%dT%H:%M:%SZ')` | `unkown`     | Use as `LABEL` within the Dockerfile to determine the build date |
| `BRANCH_OVOS`    | `master`                           | `master`     | Branch of `ovos-shell`Git  repository                            |
| `BRANCH_MYCROFT` | `stable-qt5`                       | `stable-qt5` | Branch of `mycroft-gui` Git repository                           |
| `TAG`            | `alpha`                            | `alpha`      | OCI image tag, (e.g. `docker pull smartgic/ovos-base:alpha`)     |
| `VERSION`        | `0.0.8`                            | `unknown`    | Use as `LABEL` within the Dockerfile to determine the version    |

### Image alternatives

Open Voice OS provides two *(2)* different implementations for the bus as well as for the listener.

#### Message bus

- `ovos-messagebus` image which is a Python implementation *(default)*
- `ovos-bus-server` image which is a C++ implementation *(better performances but lack of configuration)*

#### Listener

- `ovos-listener` image which is currently the original implementation *(default)*
- `ovos-listener-dinkum` image which is a port from Mycroft DinKum *(better performances, less resources consumption but still under heavy development)*

**Only one implementation can be selected at a time.**

Thirteen *(13)* images needs to be build; `ovos-base`, `ovos-listener` or `ovos-listener-dinkum`, `ovos-core`, `ovos-cli`, `ovos-messagebus` or `ovos-bus-server`, `ovos-phal`, `ovos-phal-admin`, `ovos-sound-base`, `ovos-audio`, `ovos-gui` and `ovos-gui-websocket`.

Pre-build images are already available [here](https://hub.docker.com/u/smartgic) and are the default referenced with the `docker-compose.yml` and `docker-compose.skills.yml` files.

## How to use these images

`docker-compose.yml` files provides an easy way to provision the container stack *(volumes and services)* with the required configuration for each of them. `docker compose` supports environment file, check the `.env` *(`.env-raspberrypi` for Raspberry Pi)* files.

```bash
git clone https://github.com/OpenVoiceOS/ovos-docker.git
mkdir -p ~/ovos/{config,share,tmp}
chown 1000:1000 -R ~/ovos
cd ovos-docker
docker compose up -d
```

By default, `docker compose` will look for a `docker-compose.yml` and an `.env` files, but more files could be added to the command to extend the services configuration.

```bash
docker compose -f docker-compose.yml -f docker-compose.raspberrypi.yml --env-file .env --env-file .env-raspberrypi up -d
```

Some variables might need to be updated to match your setup/environment such as timezone, directories, etc..., please have a look into the `.env` and `.env-raspberrypi` files before running `docker compose`.

## Skills management

There are two *(2)* different ways to install a skill with Open Voice OS, each having pros and cons.

### Skill running inside ovos-core container

The first way is to use the `skills.list` file within the `~/ovos/config/` directory, this file will act as a Python `requirements.txt` file. When the `ovos-core` container will start, it will look for this file and install the skills defined in there. These skills will have to be compatible with the `pip install` method which requires a `setup.py` file.

```ini
ovos-skill-volume==0.0.1 # Specific skill version
ovos-skill-stop # Latest skill version
git+https://github.com/OpenVoiceOS/skill-ovos-wikipedia.git@fix/whatever # Specific branch of a skill on GitHub
```

If the `ovos-core` container is wiped for any reason, the skill(s) will be reinstalled automatically.

The advantage is the simplicity but the cost will be more Python dependancies *(libraries)* within the `ovos-core` container and potential conflicts across versions.

### Skill running as standalone container

The second way is to leverage the `ovos-workshop` component by running a skill as standalone. This means that the skill will not be part of the same container as `ovos-core` but it will be running inside it's own container.

The advantage is that each skill are isolated which provide more flexibility about Python libraries version, packages, etc... and more security but the downside will be that more system resources will be consumed and a container image has to be build.

Few skills are already build [here](https://hub.docker.com/u/smartgic) and a `docker-compose.skills.yml` file is available. Run the following command to install the skills in there as containers.

```bash
docker compose -f docker-compose.yml -f docker-compose.skills.yml up -d
```

If the `ovos_core` container is deleted, the skill will remained available until the `ovos_core` container comes back.

## Open Voice OS CLI

The command line allows a user to send message directly but not only to the bus by using the `ovos-cli-client` command.

```bash
docker exec -ti ovos_cli ovos-cli-client
```

To display or manage the current configuration, the `ovos-config` command could be used.

```bash
docker exec -ti ovos_cli ovos-config show
```

`vim` and `nano` editors are available within the `ovos-cli` image, `vim` as be set as default.

## Open Voice OS GUI

The Open Voice OS GUI is available with the Open Voice OS Shell layer on top of it. **This container still under some development** mostly because of the skill's QML files not been shared between `ovos_gui` container and `ovos_skill_*` containers.

In order to allow only the `ovos_gui` container to access to the X server, you will have to allow this container to connect to X.

```bash
xhost +local:ovos_gui
```

`xhost` is part of the `x11-xserver-utils` package on Debian based distributions.

## FAQ

- [When mycroft.conf changed the listener doesn't listen anymore](https://github.com/OpenVoiceOS/ovos-listener/issues/15)
- [Killed if previous bus.pid exists](https://github.com/OpenVoiceOS/ovos-messagebus/issues/4)

## Support

- [Matrix channel](https://matrix.to/#/#openvoiceos:matrix.org)
- [Open Voice OS documentation](https://openvoiceos.github.io/community-docs/)
- [Contribute to Open Voice OS](https://openvoiceos.github.io/community-docs/contributing/)
- [Report bugs related to these Docker images](https://github.com/OpenVoiceOS/ovos-docker/issues)
