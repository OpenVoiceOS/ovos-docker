# Install Open Voice OS

This section covers the installation of the [core components](../../../about/glossary/components.md) only.

!!! warning "Only core components"

    Keep following the documentation if you want to install some pre-selected [skills](./skills.md), [HiveMind](../security/hivemind.md) or even the [GUI](./gui.md).

## Deploy the stack

Before running the `docker compose` or `podman-compose` commands, please make to read this [section](../prerequisites/engine.md) first.


!!! note "Podman users :muscle:"

    If you are running Podman instead of Docker, replace `docker compose` with `podmand-compose`.

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

Depending your Internet speed, your Wi-Fi or Ethernet connection speed and your hardware *([I/O](https://en.wikipedia.org/wiki/Input/output))*, the whole process could take several minutes.

| Hardware                           | Time           |
| ---------------------------------- | -------------- |
| Raspberry Pi 3B+ with USB drive    | *~20 minutes*  |
| Raspberry Pi 4B with USB drive     | *~3 minutes*   |
| MacBook Air i7 Early 2015 with SSD | *~2.5 minutes* |
| AMD Ryzen 7 5800 with NVMe drive   | *~45 seconds*  |

!!! danger "Resources overhead"

    To reduce the potential ressources overhead due to the image downloads and extractions, the `--parallel x` option could be added to the command in order to process the images by batch of `x` *(where `x` is an integer)*.

## Containers status

At this point of the installation, here are the containers that should be up and running.

=== "Docker"

    ```shell
    docker container list --all --filter 'name=ovos'
    CONTAINER ID   IMAGE                                        COMMAND                  CREATED      STATUS                PORTS     NAMES
    219eb6254d32   smartgic/ovos-listener-dinkum:alpha          "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_listener
    31f5d5e7a1ec   smartgic/ovos-audio:alpha                    "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_audio
    05e94905b867   smartgic/ovos-core:alpha                     "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_core
    d256c2e7b6f3   smartgic/ovos-phal:alpha                     "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_phal
    a4db13a597a4   smartgic/ovos-phal-admin:alpha               "/bin/bash /usr/loca…"   25 hours ago   Up 8 hours                       ovos_phal_admin
    d157740c9965   smartgic/ovos-messagebus:alpha               "/bin/bash -c ovos-m…"   25 hours ago   Up 8 hours (healthy)             ovos_messagebus
    6e3536dcfae5   smartgic/ovos-cli:alpha                      "sleep infinity"         25 hours ago   Up 8 hours                       ovos_cli
    ```

=== "Podman"

    ```shell
    podman container list --all --filter 'name=ovos'
    CONTAINER ID   IMAGE                                        COMMAND                  CREATED      STATUS                PORTS     NAMES
    219eb6254d32   smartgic/ovos-listener-dinkum:alpha          "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_listener
    31f5d5e7a1ec   smartgic/ovos-audio:alpha                    "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_audio
    05e94905b867   smartgic/ovos-core:alpha                     "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_core
    d256c2e7b6f3   smartgic/ovos-phal:alpha                     "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_phal
    a4db13a597a4   smartgic/ovos-phal-admin:alpha               "/bin/bash /usr/loca…"   25 hours ago   Up 8 hours                       ovos_phal_admin
    d157740c9965   smartgic/ovos-messagebus:alpha               "/bin/bash -c ovos-m…"   25 hours ago   Up 8 hours (healthy)             ovos_messagebus
    6e3536dcfae5   smartgic/ovos-cli:alpha                      "sleep infinity"         25 hours ago   Up 8 hours                       ovos_cli
    ```
