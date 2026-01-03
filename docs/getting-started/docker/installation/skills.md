# How to install skills?

Two different methods are supported by `ovos-docker` to install Open Voice OS's skills, each of them having pros :material-thumb-up-outline:{ style="color: green" } and cons :material-thumb-down-outline:{ style="color: red" }.

!!! danger "Slow hardware"

    When running Open Voice OS on slow hardware such as Raspberry Pi 3B+, it is recommended to install skills using the "[As part of `ovos_core` container](#as-part-of-ovos_core-container)" method in order to reduce the memory consumption.

## As part of `ovos_core` container

The first method is to use a `skills.list` file within the `~/ovos/config/` directory _(it does not exist by default)_, this file acts as a Python `requirements.txt` file.

When `ovos_core` container starts, it will look for a `skills.list` file and install the skills defined in there.

!!! warning "Skill requirements"

    The skill has to be compatible with the `pip install` method which requires a `setup.py` file.

```ini title="~/ovos/config/skills.list"
ovos-skill-stop # Latest skill version on PyPi
ovos-skill-volume==0.0.1 # Specific skill version on PyPi
git+https://github.com/OpenVoiceOS/skill-ovos-wikipedia.git@fix/whatever # Specific skill's branch on GitHub
```

If the `ovos_core` container is wiped for any reasons _(like an update)_, the skill(s) will be automatically reprovisioned.

!!! tip "Not only for skills"

    The `skills.list` file can also be used to install extra Python libraries, *e.g.*, `SoCo`, `RPi.GPIO`. Just make sure to avoid empty lines.

The main advantage of this method is the simplicity **but** the downside will be more Python dependencies _(libraries)_ within the `ovos_core` container, potential conflicts across them, a lack of isolation and a slower start of the container.

Once the `~/ovos/config/skills.list` file is populated with the wanted skills, the `ovos_core` container must be restarted to handle the new requirements.

!!! note "Podman users :muscle:"

    If you are running Podman instead of Docker, replace `docker compose` with `podman-compose`.

!!! note "Compose file names"

    The file names below are examples. Use the compose files provided by your
    installer or your own bundle names. If you cloned `ovos-docker`, the bundles
    live under `compose/`.

!!! tip "Extra skills"

    To include the optional skill bundle, add `--file docker-compose.skills-extra.yml`
    to the commands below.

=== "Raspberry Pi"

    ```shell
    docker restart ovos_core
    ```

=== "Linux"

    ```shell
    docker restart ovos_core
    ```

=== "Mac OS"

    ```shell
    docker restart ovos_core
    ```

=== "Windows WSL2"

    ```shell
    docker restart ovos_core
    ```

## As standalone container _(recommended)_

The second method is to leverage the [ovos-workshop](../../../about/glossary/components.md#ovos-workshop) component by running a skill as standalone, it means the skill will not be part of `ovos_core` container but it will be running inside its own container.

The main advantage is that each skill is isolated which provide more flexibility about Python dependencies _(libraries)_, packages. It is easier to update and more secure **but** the downside will be that more system resources will be consumed and a container image has to be built for each skill.

!!! note "Podman users :muscle:"

    If you are running Podman instead of Docker, replace `docker compose` with `podman-compose`.

=== "Raspberry Pi"

    ```shell
    docker compose --project-name ovos --file docker-compose.yml --file docker-compose.raspberrypi.yml --file docker-compose.skills.yml up --detach
    ```

=== "Linux"

    ```shell
    docker compose --project-name ovos --file docker-compose.yml --file docker-compose.skills.yml up --detach
    ```

=== "Mac OS"

    ```shell
    docker compose --project-name ovos --file docker-compose.macos.yml --file docker-compose.skills.yml --env-file .env up --detach
    ```

=== "Windows WSL2"

    ```shell
    docker compose --project-name ovos --file docker-compose.windows.yml --file docker-compose.skills.yml up --detach
    ```

Depending on your Internet speed, your Wi-Fi or Ethernet connection speed, and your hardware _([I/O](https://en.wikipedia.org/wiki/Input/output))_, the whole process could take several minutes.

| Hardware                           | Time          |
| ---------------------------------- | ------------- |
| Raspberry Pi 3B+ with USB drive    | _~12 minutes_ |
| Raspberry Pi 4B with USB drive     | _~48 seconds_ |
| MacBook Air i7 Early 2015 with SSD | _~50 seconds_ |
| AMD Ryzen 7 5800 with NVMe drive   | _~15 seconds_ |

!!! danger "Resources overhead"

    To reduce the potential resources overhead due to image downloads and extractions, the `--parallel x` option can be added to the command in order to process the images in batches of `x` *(where `x` is an integer)*.

If the `ovos_core` container is restarted or even deleted, the skill containers will automatically register again to it.

## Optional skills bundle

If you add `docker-compose.skills-extra.yml`, the following extra skill images
are included:

| Skill image             | Notes                               |
| ----------------------- | ----------------------------------- |
| `ovos-skill-camera`     | Requires camera access              |
| `ovos-skill-easter-eggs` | Optional fun responses              |
| `ovos-skill-jokes`      | Joke responses                      |
| `ovos-skill-parrot`     | Repeat-back skill                   |
| `ovos-skill-randomness` | Randomness utilities                |
| `ovos-skill-wikihow`    | WikiHow responses                   |
| `ovos-skill-wolfie`     | Wolfie skill                        |

Add the bundle to your compose command:

```shell
docker compose --project-name ovos --file docker-compose.yml --file docker-compose.skills.yml --file docker-compose.skills-extra.yml up --detach
```

On Mac OS or Windows WSL2, include the env file:

```shell
docker compose --project-name ovos --file docker-compose.macos.yml --file docker-compose.skills.yml --file docker-compose.skills-extra.yml --env-file .env up --detach
```

## Containers status

At this point of the installation, here are the containers that should be up and running.

=== "Docker"

    ```shell
    docker container list --all --filter 'name=ovos'
    CONTAINER ID   IMAGE                                        COMMAND                  CREATED        STATUS                 PORTS     NAMES
    1446b87d7a32   docker.io/smartgic/ovos-skill-wikipedia:alpha   "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_wikipedia
    7ad46a871661   docker.io/smartgic/ovos-skill-weather:alpha     "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_weather
    b43b8cf31a43   docker.io/smartgic/ovos-skill-volume:alpha      "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_volume
    f27d3fceecec   docker.io/smartgic/ovos-skill-date-time:alpha   "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_date_time
    30b70c9e72ef   docker.io/smartgic/ovos-skill-personal:alpha    "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_personal
    5760fb22deb9   docker.io/smartgic/ovos-skill-fallback-unknown:alpha "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_fallback_unknown
    73f4d4b0a091   docker.io/smartgic/ovos-skill-hello-world:alpha "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_hello_world
    219eb6254d32   docker.io/smartgic/ovos-skill-alerts:alpha      "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_alerts
    31f5d5e7a1ec   docker.io/smartgic/ovos-skill-ggwave:alpha      "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_ggwave
    05e94905b867   docker.io/smartgic/ovos-skill-duckduckgo:alpha  "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_duckduckgo
    d256c2e7b6f3   docker.io/smartgic/ovos-skill-wordnet:alpha     "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_wordnet
    a4db13a597a4   docker.io/smartgic/ovos-listener:alpha          "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_listener
    d157740c9965   docker.io/smartgic/ovos-audio:alpha             "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_audio
    6e3536dcfae5   docker.io/smartgic/ovos-core:alpha              "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_core
    12c2b6d4f6e7   docker.io/smartgic/ovos-phal:alpha              "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_phal
    98110d0b4b97   docker.io/smartgic/ovos-phal-admin:alpha        "/bin/bash /usr/loca…"   25 hours ago   Up 8 hours                       ovos_phal_admin
    8a179e135a6f   docker.io/smartgic/ovos-messagebus:alpha        "/bin/bash -c ovos-m…"   25 hours ago   Up 8 hours (healthy)             ovos_messagebus
    9c5fbad6c50d   docker.io/smartgic/ovos-cli:alpha               "sleep infinity"         25 hours ago   Up 8 hours                       ovos_cli
    f0a451e1b14d   docker.io/smartgic/ovos-plugin-ggwave:alpha     "sleep infinity"         25 hours ago   Up 8 hours                       ovos_plugin_ggwave
    ```

=== "Podman"

    ```shell
    podman container list --all --filter 'name=ovos'
    CONTAINER ID   IMAGE                                        COMMAND                  CREATED        STATUS                 PORTS     NAMES
    1446b87d7a32   docker.io/smartgic/ovos-skill-wikipedia:alpha   "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_wikipedia
    7ad46a871661   docker.io/smartgic/ovos-skill-weather:alpha     "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_weather
    b43b8cf31a43   docker.io/smartgic/ovos-skill-volume:alpha      "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_volume
    f27d3fceecec   docker.io/smartgic/ovos-skill-date-time:alpha   "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_date_time
    30b70c9e72ef   docker.io/smartgic/ovos-skill-personal:alpha    "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_personal
    5760fb22deb9   docker.io/smartgic/ovos-skill-fallback-unknown:alpha "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_fallback_unknown
    73f4d4b0a091   docker.io/smartgic/ovos-skill-hello-world:alpha "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_hello_world
    219eb6254d32   docker.io/smartgic/ovos-skill-alerts:alpha      "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_alerts
    31f5d5e7a1ec   docker.io/smartgic/ovos-skill-ggwave:alpha      "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_ggwave
    05e94905b867   docker.io/smartgic/ovos-skill-duckduckgo:alpha  "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_duckduckgo
    d256c2e7b6f3   docker.io/smartgic/ovos-skill-wordnet:alpha     "ovos-skill-launcher…"   18 hours ago   Up 8 hours                       ovos_skill_wordnet
    a4db13a597a4   docker.io/smartgic/ovos-listener:alpha          "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_listener
    d157740c9965   docker.io/smartgic/ovos-audio:alpha             "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_audio
    6e3536dcfae5   docker.io/smartgic/ovos-core:alpha              "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_core
    12c2b6d4f6e7   docker.io/smartgic/ovos-phal:alpha              "/bin/bash /usr/loca…"   18 hours ago   Up 8 hours                       ovos_phal
    98110d0b4b97   docker.io/smartgic/ovos-phal-admin:alpha        "/bin/bash /usr/loca…"   25 hours ago   Up 8 hours                       ovos_phal_admin
    8a179e135a6f   docker.io/smartgic/ovos-messagebus:alpha        "/bin/bash -c ovos-m…"   25 hours ago   Up 8 hours (healthy)             ovos_messagebus
    9c5fbad6c50d   docker.io/smartgic/ovos-cli:alpha               "sleep infinity"         25 hours ago   Up 8 hours                       ovos_cli
    f0a451e1b14d   docker.io/smartgic/ovos-plugin-ggwave:alpha     "sleep infinity"         25 hours ago   Up 8 hours                       ovos_plugin_ggwave
    ```
