# HiveMind to the rescue

## What is HiveMind?

> HiveMind is a community-developed superset or extension of Open Voice OS, the open-source voice operating system.
>
> With HiveMind, you can extend one _(or more, but usually just one!)_ instance of Open Voice OS to as many devices as you want, including devices that can't ordinarily run Open Voice OS!

_<div align="right">[Official documentation](https://jarbashivemind.github.io/HiveMind-community-docs/)</div>_

This means that [HiveMind](../../../about/glossary/terms.md#hivemind) allows external connections to the message bus by using a secured protocol.

!!! tip "Fulfill the requirements first"

    Before going further, please make sure that all the [requirements](../installation/requirements.md) are fulfilled.

A [composition](../composition.md) file is available to deploy `hivemind_listener` and `hivemind_cli` services.

!!! note "Podman users :muscle:"

    If you are running Podman instead of Docker, replace `docker compose` with `podman-compose`.

!!! note "Compose file names"

    The file names below are examples. Use the compose files provided by your
    installer or your own bundle names. If you cloned `ovos-docker`, the bundles
    live under `compose/`.

!!! tip "Server-only stack"

    If you only need the messagebus, core, and HiveMind, use
    `docker-compose.server.yml` instead of the full stack. See
    [Server-only stack](../composition.md#server-only-stack).

=== "Raspberry Pi"

    ```shell
    docker compose --project-name ovos --file docker-compose.yml --file docker-compose.raspberrypi.yml --file docker-compose.skills.yml --file docker-compose.hivemind.yml up --detach
    ```

=== "Linux"

    ```shell
    docker compose --project-name ovos --file docker-compose.yml --file docker-compose.skills.yml --file docker-compose.hivemind.yml up --detach
    ```

=== "Mac OS"

    ```shell
    docker compose --project-name ovos --file docker-compose.macos.yml --file docker-compose.skills.yml --file docker-compose.hivemind.yml --env-file .env up --detach
    ```

=== "Windows WSL2"

    ```shell
    docker compose --project-name ovos --file docker-compose.windows.yml --file docker-compose.skills.yml --file docker-compose.hivemind.yml up --detach
    ```

For more information about how to authenticate with the HiveMind listener, please read the [HiveMind-core repository documentation](https://github.com/JarbasHiveMind/HiveMind-core).

Once the HiveMind containers are up and running, the HiveMind command line allows you to add clients, list them, delete them, etc...

=== "Docker"

    ```shell
    docker exec --interactive --tty hivemind_cli hivemind-core --help
    ```

=== "Podman"

    ```shell
    podman exec --interactive --tty hivemind_cli hivemind-core --help
    ```

!!! warning "Port `5678` must be open"

    In order to reach the HiveMind listener, the port `5678` has to be open on the host. Please make sure your firewall allows the connection to this port or the clients will not be able to connect to it.

## Containers status

At this point of the installation, here are the containers that should be up and running.

!!! note "Registry"

    HiveMind images are maintained separately. The OVOS compose bundles default
    to `docker.io/smartgic`. If you use a different registry, update the image
    references accordingly.

=== "Docker"

    ```shell
    docker container list --all --filter 'name=ovos' --filter 'name=hivemind'
    CONTAINER ID   IMAGE                                        COMMAND                  CREATED          STATUS                 PORTS     NAMES
    4e2d45799de8   smartgic/hivemind-cli:alpha                  "sleep infinity"         16 minutes ago   Up 16 minutes                    hivemind_cli
    612a9ea32405   smartgic/hivemind-listener:alpha             "hivemind-core listen"   16 minutes ago   Up 16 minutes                    hivemind_listener
    1446b87d7a32   docker.io/smartgic/ovos-skill-wikipedia:alpha   "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_wikipedia
    7ad46a871661   docker.io/smartgic/ovos-skill-weather:alpha     "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_weather
    b43b8cf31a43   docker.io/smartgic/ovos-skill-volume:alpha      "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_volume
    f27d3fceecec   docker.io/smartgic/ovos-skill-date-time:alpha   "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_date_time
    30b70c9e72ef   docker.io/smartgic/ovos-skill-personal:alpha    "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_personal
    5760fb22deb9   docker.io/smartgic/ovos-skill-fallback-unknown:alpha "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_fallback_unknown
    73f4d4b0a091   docker.io/smartgic/ovos-skill-hello-world:alpha "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_hello_world
    219eb6254d32   docker.io/smartgic/ovos-skill-alerts:alpha      "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_alerts
    31f5d5e7a1ec   docker.io/smartgic/ovos-skill-ggwave:alpha      "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_ggwave
    05e94905b867   docker.io/smartgic/ovos-skill-duckduckgo:alpha  "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_duckduckgo
    d256c2e7b6f3   docker.io/smartgic/ovos-skill-wordnet:alpha     "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_wordnet
    a4db13a597a4   docker.io/smartgic/ovos-listener:alpha          "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_listener
    d157740c9965   docker.io/smartgic/ovos-audio:alpha             "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_audio
    05e94905b867   docker.io/smartgic/ovos-core:alpha              "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_core
    d256c2e7b6f3   docker.io/smartgic/ovos-phal:alpha              "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_phal
    a4db13a597a4   docker.io/smartgic/ovos-phal-admin:alpha        "/bin/bash /usr/loca…"   25 hours ago     Up 8 hours                       ovos_phal_admin
    d157740c9965   docker.io/smartgic/ovos-messagebus:alpha        "/bin/bash -c ovos-m…"   25 hours ago     Up 8 hours (healthy)             ovos_messagebus
    6e3536dcfae5   docker.io/smartgic/ovos-cli:alpha               "sleep infinity"         25 hours ago     Up 8 hours                       ovos_cli
    ```

=== "Podman"

    ```shell
    podman container list --all --filter 'name=ovos'
    CONTAINER ID   IMAGE                                        COMMAND                  CREATED          STATUS                 PORTS     NAMES
    4e2d45799de8   smartgic/hivemind-cli:alpha                  "sleep infinity"         16 minutes ago   Up 16 minutes                    hivemind_cli
    612a9ea32405   smartgic/hivemind-listener:alpha             "hivemind-core listen"   16 minutes ago   Up 16 minutes                    hivemind_listener
    1446b87d7a32   docker.io/smartgic/ovos-skill-wikipedia:alpha   "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_wikipedia
    7ad46a871661   docker.io/smartgic/ovos-skill-weather:alpha     "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_weather
    b43b8cf31a43   docker.io/smartgic/ovos-skill-volume:alpha      "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_volume
    f27d3fceecec   docker.io/smartgic/ovos-skill-date-time:alpha   "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_date_time
    30b70c9e72ef   docker.io/smartgic/ovos-skill-personal:alpha    "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_personal
    5760fb22deb9   docker.io/smartgic/ovos-skill-fallback-unknown:alpha "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_fallback_unknown
    73f4d4b0a091   docker.io/smartgic/ovos-skill-hello-world:alpha "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_hello_world
    219eb6254d32   docker.io/smartgic/ovos-skill-alerts:alpha      "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_alerts
    31f5d5e7a1ec   docker.io/smartgic/ovos-skill-ggwave:alpha      "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_ggwave
    05e94905b867   docker.io/smartgic/ovos-skill-duckduckgo:alpha  "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_duckduckgo
    d256c2e7b6f3   docker.io/smartgic/ovos-skill-wordnet:alpha     "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_wordnet
    a4db13a597a4   docker.io/smartgic/ovos-listener:alpha          "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_listener
    d157740c9965   docker.io/smartgic/ovos-audio:alpha             "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_audio
    05e94905b867   docker.io/smartgic/ovos-core:alpha              "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_core
    d256c2e7b6f3   docker.io/smartgic/ovos-phal:alpha              "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_phal
    a4db13a597a4   docker.io/smartgic/ovos-phal-admin:alpha        "/bin/bash /usr/loca…"   25 hours ago     Up 8 hours                       ovos_phal_admin
    d157740c9965   docker.io/smartgic/ovos-messagebus:alpha        "/bin/bash -c ovos-m…"   25 hours ago     Up 8 hours (healthy)             ovos_messagebus
    6e3536dcfae5   docker.io/smartgic/ovos-cli:alpha               "sleep infinity"         25 hours ago     Up 8 hours                       ovos_cli
    ```
