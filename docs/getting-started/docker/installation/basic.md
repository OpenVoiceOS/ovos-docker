# Install Open Voice OS

This section covers the installation of the [core components](../../../about/glossary/components.md) only.

!!! warning "Only core components"

    Keep following the documentation if you want to install some pre-selected [skills](./skills.md), [HiveMind](../security/hivemind.md) or even the [GUI](./gui.md).

## Deploy the stack

Before running the `docker compose` or `podman-compose` commands, please read this [section](../prerequisites/engine.md) first.

!!! note "Podman users :muscle:"

    If you are running Podman instead of Docker, replace `docker compose` with `podman-compose`.

!!! note "Compose file names"

    The file names below are examples. Use the compose files provided by your
    installer or your own bundle names. If you cloned `ovos-docker`, the bundles
    live under `compose/`.

=== "Raspberry Pi"

    ```shell
    docker compose --project-name ovos --file docker-compose.yml --file docker-compose.raspberrypi.yml up --detach
    ```

=== "Linux"

    ```shell
    docker compose --project-name ovos --file docker-compose.yml up --detach
    ```

=== "Mac OS"

    ```shell
    docker compose --project-name ovos --file docker-compose.macos.yml --env-file .env up --detach
    ```

=== "Windows WSL2"

    ```shell
    docker compose --project-name ovos --file docker-compose.windows.yml up --detach
    ```

Depending on your Internet speed, your Wi-Fi or Ethernet connection speed, and your hardware _([I/O](https://en.wikipedia.org/wiki/Input/output))_, the whole process could take several minutes.

| Hardware                           | Time           |
| ---------------------------------- | -------------- |
| Raspberry Pi 3B+ with USB drive    | _~20 minutes_  |
| Raspberry Pi 4B with USB drive     | _~3 minutes_   |
| MacBook Air i7 Early 2015 with SSD | _~2.5 minutes_ |
| AMD Ryzen 7 5800 with NVMe drive   | _~45 seconds_  |

!!! danger "Resources overhead"

    To reduce the potential resources overhead due to image downloads and extractions, the `--parallel x` option can be added to the command in order to process the images in batches of `x` *(where `x` is an integer)*.

## Containers status

At this point of the installation, here are the containers that should be up and running.

!!! note "Registry"

    The image prefix in your output depends on the compose files you use.
    The default bundles under `compose/` reference `docker.io/smartgic`.

=== "Docker"

    ```shell
    docker container list --all --filter 'name=ovos'
    CONTAINER ID   IMAGE                                        COMMAND                  CREATED      STATUS                PORTS     NAMES
    219eb6254d32   docker.io/smartgic/ovos-listener:alpha       "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_listener
    31f5d5e7a1ec   docker.io/smartgic/ovos-audio:alpha          "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_audio
    05e94905b867   docker.io/smartgic/ovos-core:alpha           "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_core
    d256c2e7b6f3   docker.io/smartgic/ovos-phal:alpha           "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_phal
    a4db13a597a4   docker.io/smartgic/ovos-phal-admin:alpha     "/bin/bash /usr/loca…"   25 hours ago   Up 8 hours                       ovos_phal_admin
    d157740c9965   docker.io/smartgic/ovos-messagebus:alpha     "/bin/bash -c ovos-m…"   25 hours ago   Up 8 hours (healthy)             ovos_messagebus
    6e3536dcfae5   docker.io/smartgic/ovos-cli:alpha            "sleep infinity"         25 hours ago   Up 8 hours                       ovos_cli
    12c2b6d4f6e7   docker.io/smartgic/ovos-plugin-ggwave:alpha  "sleep infinity"         25 hours ago   Up 8 hours                       ovos_plugin_ggwave
    ```

=== "Podman"

    ```shell
    podman container list --all --filter 'name=ovos'
    CONTAINER ID   IMAGE                                        COMMAND                  CREATED      STATUS                PORTS     NAMES
    219eb6254d32   docker.io/smartgic/ovos-listener:alpha       "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_listener
    31f5d5e7a1ec   docker.io/smartgic/ovos-audio:alpha          "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_audio
    05e94905b867   docker.io/smartgic/ovos-core:alpha           "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_core
    d256c2e7b6f3   docker.io/smartgic/ovos-phal:alpha           "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_phal
    a4db13a597a4   docker.io/smartgic/ovos-phal-admin:alpha     "/bin/bash /usr/loca…"   25 hours ago   Up 8 hours                       ovos_phal_admin
    d157740c9965   docker.io/smartgic/ovos-messagebus:alpha     "/bin/bash -c ovos-m…"   25 hours ago   Up 8 hours (healthy)             ovos_messagebus
    6e3536dcfae5   docker.io/smartgic/ovos-cli:alpha            "sleep infinity"         25 hours ago   Up 8 hours                       ovos_cli
    12c2b6d4f6e7   docker.io/smartgic/ovos-plugin-ggwave:alpha  "sleep infinity"         25 hours ago   Up 8 hours                       ovos_plugin_ggwave
    ```
