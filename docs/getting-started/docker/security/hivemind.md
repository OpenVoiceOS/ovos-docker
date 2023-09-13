# HiveMind to the rescue

## What is HiveMind?

> HiveMind is a community-developed superset or extension of Open Voice OS, the open-source voice operating system.
>
> With HiveMind, you can extend one *(or more, but usually just one!)* instance of Open Voice OS to as many devices as you want, including devices that can't ordinarily run Open Voice OS!

*<div align="right">[Official documentation](https://jarbashivemind.github.io/HiveMind-community-docs/)</div>*

What it means, is that [HiveMind](../../../about/glossary/terms.md#hivemind) allows external connections to the message bus by using a secured protocol.

!!! tip "Fulfill the requirements first"

    Before going further, please make sure that all the [requirements](../installation/requirements.md) are fulfilled.

A [composition](../composition.md) file is available in order to deploy `hivemind_listener` and `hivemind_cli` services.

!!! note "Podman users :muscle:"

    If you are running Podman instead of Docker, replace `docker compose` with `podmand-compose`.

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

Once the HiveMind containers are up and running, the HiveMind command line allows you to add client, to list them, to delete them, etc...

=== "Docker"

    ```shell
    docker exec --interactive --tty hivemind_cli hivemind-core --help
    ```

=== "Podman"

    ```shell
    podman exec --interactive --tty hivemind_cli hivemind-core --help
    ```

!!! warning "Port `5678` must be open"

    In order to to reach the HiveMind listener, the port `5678` has to be open on the host. Please make sure your firewall allows the connection to this port or the clients will not be able to connect to it.

## Containers status

At this point of the installation, here are the containers that should be up and running.

=== "Docker"

    ```shell
    docker container list --all --filter 'name=ovos'
    CONTAINER ID   IMAGE                                        COMMAND                  CREATED          STATUS                 PORTS     NAMES
    4e2d45799de8   smartgic/hivemind-cli:alpha                  "sleep infinity"         16 minutes ago   Up 16 minutes                    hivemind_cli
    612a9ea32405   smartgic/hivemind-listener:alpha             "hivemind-core listen"   16 minutes ago   Up 16 minutes                    hivemind_listener
    1446b87d7a32   smartgic/ovos-skill-volume:alpha             "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_volume
    7ad46a871661   smartgic/ovos-skill-wikipedia:alpha          "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_wikipedia
    b43b8cf31a43   smartgic/ovos-skill-fallback-unknown:alpha   "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_fallback_unknown
    f27d3fceecec   smartgic/ovos-skill-alerts:alpha             "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_alerts
    30b70c9e72ef   smartgic/ovos-skill-hello-world:alpha        "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_hello_world
    f42175c6d7b8   smartgic/ovos-skill-weather:alpha            "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_weather
    0ae42a59fb0b   smartgic/ovos-skill-stop:alpha               "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_stop
    5760fb22deb9   smartgic/ovos-skill-date-time:alpha          "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_date_time
    73f4d4b0a091   smartgic/ovos-skill-personal:alpha           "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_personal
    219eb6254d32   smartgic/ovos-listener-dinkum:alpha          "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_listener
    31f5d5e7a1ec   smartgic/ovos-audio:alpha                    "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_audio
    05e94905b867   smartgic/ovos-core:alpha                     "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_core
    d256c2e7b6f3   smartgic/ovos-phal:alpha                     "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_phal
    a4db13a597a4   smartgic/ovos-phal-admin:alpha               "/bin/bash /usr/loca…"   25 hours ago     Up 8 hours                       ovos_phal_admin
    d157740c9965   smartgic/ovos-messagebus:alpha               "/bin/bash -c ovos-m…"   25 hours ago     Up 8 hours (healthy)             ovos_messagebus
    6e3536dcfae5   smartgic/ovos-cli:alpha                      "sleep infinity"         25 hours ago     Up 8 hours                       ovos_cli
    ```

=== "Podman"

    ```shell
    podman container list --all --filter 'name=ovos'
    CONTAINER ID   IMAGE                                        COMMAND                  CREATED          STATUS                 PORTS     NAMES
    4e2d45799de8   smartgic/hivemind-cli:alpha                  "sleep infinity"         16 minutes ago   Up 16 minutes                    hivemind_cli
    612a9ea32405   smartgic/hivemind-listener:alpha             "hivemind-core listen"   16 minutes ago   Up 16 minutes                    hivemind_listener
    1446b87d7a32   smartgic/ovos-skill-volume:alpha             "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_volume
    7ad46a871661   smartgic/ovos-skill-wikipedia:alpha          "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_wikipedia
    b43b8cf31a43   smartgic/ovos-skill-fallback-unknown:alpha   "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_fallback_unknown
    f27d3fceecec   smartgic/ovos-skill-alerts:alpha             "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_alerts
    30b70c9e72ef   smartgic/ovos-skill-hello-world:alpha        "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_hello_world
    f42175c6d7b8   smartgic/ovos-skill-weather:alpha            "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_weather
    0ae42a59fb0b   smartgic/ovos-skill-stop:alpha               "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_stop
    5760fb22deb9   smartgic/ovos-skill-date-time:alpha          "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_date_time
    73f4d4b0a091   smartgic/ovos-skill-personal:alpha           "ovos-skill-launcher…"   19 hours ago     Up 8 hours                       ovos_skill_personal
    219eb6254d32   smartgic/ovos-listener-dinkum:alpha          "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_listener
    31f5d5e7a1ec   smartgic/ovos-audio:alpha                    "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_audio
    05e94905b867   smartgic/ovos-core:alpha                     "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_core
    d256c2e7b6f3   smartgic/ovos-phal:alpha                     "/bin/bash /usr/loca…"   19 hours ago     Up 8 hours                       ovos_phal
    a4db13a597a4   smartgic/ovos-phal-admin:alpha               "/bin/bash /usr/loca…"   25 hours ago     Up 8 hours                       ovos_phal_admin
    d157740c9965   smartgic/ovos-messagebus:alpha               "/bin/bash -c ovos-m…"   25 hours ago     Up 8 hours (healthy)             ovos_messagebus
    6e3536dcfae5   smartgic/ovos-cli:alpha                      "sleep infinity"         25 hours ago     Up 8 hours                       ovos_cli
    ```
