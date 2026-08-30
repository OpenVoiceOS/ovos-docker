# Composition and environment files

The easiest and quickest way to deploy Open Voice OS containers is to use a [composer](./index.md#composer-definition) such as `docker compose` or `podman-compose`.

!!! info "Compose files"

    Compose files live under `compose/` in the repository. Run commands from
    that directory or pass `--env-file compose/.env` and `--file compose/<name>`.

## Composition files

Composition files provide an easy way to provision the stack _(services and volumes)_ with the required options and configuration for each of the services. The names below reflect the bundle layout shipped in `compose/`.

| Compose file                         | Platforms                                                                                                                                                                                                               | Description                                                                      |
| ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| `docker-compose.yml`                 | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                           | Install [core](../../about/glossary/components.md) components _(except the GUI)_ |
| `docker-compose.gui.yml`             | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                           | Install [GUI](../../about/glossary/components.md#ovos-gui) components            |
| `docker-compose.skills.yml`          | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | Install pre-defined [skills](../../about/glossary/terms.md#skill)                |
| `docker-compose.skills-extra.yml`    | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | Install additional optional skills                                               |
| `docker-compose.hivemind.yml`        | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | Install [HiveMind](../../about/glossary/terms.md#hivemind) components            |
| `docker-compose.server.yml`          | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | Lightweight server stack (core + messagebus + HiveMind)                          |
| `docker-compose.macos.yml`           | :fontawesome-brands-apple:{ .lg title="Mac OS" }                                                                                                                                                                        | Install [core](../../about/glossary/components.md) components _(except the GUI)_ |
| `docker-compose.windows.yml`         | :fontawesome-brands-windows:{ .lg title="Windows WSL2" }                                                                                                                                                                | Install [core](../../about/glossary/components.md) components _(except the GUI)_ |
| `docker-compose.raspberrypi.yml`     | :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                                                                           | Add GPIO support to `ovos_core` component                                        |
| `docker-compose.raspberrypi.gui.yml` | :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                                                                           | Add `/dev/vchiq` to `ovos_gui` component _(GUI images are no longer built)_      |

## Server-only stack

The `docker-compose.server.yml` bundle runs a lightweight stack with
`ovos_messagebus`, `ovos_core`, and HiveMind services. It omits audio, listener,
and GUI containers, making it a good fit for headless deployments or a central
HiveMind hub.

=== "Raspberry Pi"

    ```shell
    docker compose --project-name ovos --file docker-compose.server.yml up --detach
    ```

=== "Linux"

    ```shell
    docker compose --project-name ovos --file docker-compose.server.yml up --detach
    ```

=== "Mac OS"

    ```shell
    docker compose --project-name ovos --file docker-compose.server.yml --env-file .env up --detach
    ```

=== "Windows WSL2"

    ```shell
    docker compose --project-name ovos --file docker-compose.server.yml --env-file .env up --detach
    ```

To expand beyond the server stack, switch to `docker-compose.yml` and add other
bundles like `docker-compose.skills.yml` or `docker-compose.gui.yml`.

## Environment files

A Docker or Podman environment file contains lines about environment variables that are usable by the Docker or Podman command line. It is a convenient way to pass many environment variables to a single command.

| Environment file       | Platforms                                                                                                                                                 | Description                                                     |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| `.env`                 | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | Set of variables used by the composition files                  |
| `.env-raspberrypi`     | :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                             | Raspberry Pi tuned defaults and GPIO/I2C/SPI group IDs           |

Some variables might need to be tuned to match your setup such as the `TZ`, `XDG_RUNTIME_DIR`, etc...

| Variable                      | Default                                               | Platforms                                                                                                                                                                                                               | Description                            |
| ----------------------------- | -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| `DISPLAY`                     | `:0`                                                  | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                           | Display used by X or Wayland           |
| `PULSE_SERVER`                | Platform-specific                                    | :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" }                                                                                                               | PulseAudio server address              |
| `GPIO_GID`                    | `997`                                                 | :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                                                                           | `gpio` group ID on Raspberry Pi        |
| `HIVEMIND_CONFIG_FOLDER`      | `/home/hivemind/hivemind/config`                     | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | HiveMind configuration directory       |
| `HIVEMIND_CONFIG_PHAL_FOLDER` | `/home/hivemind/hivemind/config/phal`                | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | HiveMind PHAL configuration directory  |
| `HIVEMIND_SHARE_FOLDER`       | `/home/hivemind/hivemind/share`                      | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | HiveMind shared directory              |
| `HIVEMIND_USER`               | `hivemind`                                         | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | User running in the container          |
| `I2C_GID`                     | `994`                                                 | :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                                                                           | `i2c` group ID on Raspberry Pi         |
| `INPUT_GID`                   | `102`                                                 | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                           | `input` group ID                       |
| `OVOS_CONFIG_FOLDER`          | `/home/ovos/ovos/config`                              | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | OVOS configuration directory           |
| `OVOS_CONFIG_PHAL_FOLDER`     | `/home/ovos/ovos/config/phal`                         | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | OVOS PHAL configuration directory      |
| `OVOS_PERSONA_FOLDER`         | `/home/ovos/ovos/config/persona`                      | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | OVOS persona directory                 |
| `OVOS_SHARE_FOLDER`           | `/home/ovos/ovos/share`                               | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | OVOS shared directory                  |
| `OVOS_USER`                   | `ovos`                                             | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | User running in the container          |
| `PULL_POLICY`                 | `always`                                           | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | Policy to pull Docker images           |
| `QT_QPA_EGLFS_INTEGRATION`    | `eglfs`                                            | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                           | QT preferred backend to use for EGLFS  |
| `QT_QPA_EGLFS_KMS_CONFIG`     | `/home/$OVOS_USER/.config/mycroft/ovos-eglfs.json` | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                           | QT EGLFS KMS configuration             |
| `QT_QPA_PLATFORM`             | `eglfs`                                            | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                           | QT platform plugin to use              |
| `RENDER_GID`                  | `106`                                              | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                           | `render` group ID                      |
| `SPI_GID`                     | `995`                                              | :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                                                                           | `spi` group ID on Raspberry Pi         |
| `TMP_FOLDER`                  | `/home/ovos/ovos/tmp`                                | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | OVOS temporary directory               |
| `TZ`                          | `UTC`                                                | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | Timezone to set in the container       |
| `VERSION`                     | `alpha`                                            | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | Container image tag to pull            |
| `CORE_MEMORY_LIMIT`           | `2G`                                               | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | Memory limit of `ovos_core`             |
| `STANDARD_MEMORY_LIMIT`       | `1G`                                               | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | Memory limit of listener, audio, PHAL, message bus, CLI |
| `LIGHT_MEMORY_LIMIT`          | `512M`                                             | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } | Memory limit of skills and HiveMind      |
| `GUI_MEMORY_LIMIT`            | `1G`                                               | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } | Memory limit of `ovos_gui` _(GUI images are no longer built)_ |
| `VIDEO_GID`                   | `44`                                               | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                           | `video` group ID                       |
| `WAYLAND_DISPLAY`             | `wayland-0`                                        | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" }                                                                                                           | Compositor used by Wayland             |
| `XDG_RUNTIME_DIR`             | `/run/user/1000`                                   | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" }                                                  | Path to XDG runtime directory          |

!!! bug "Do not change `OVOS_USER` or `HIVEMIND_USER`"

    The `OVOS_USER` and `HIVEMIND_USER` variables should not be changed unless you build your own container images with a different user.

### How to get the GID?

The `getent` command could be used in order to get the `GID` of `gpio` and `render` groups.

=== "Raspberry Pi"

    ```shell
    getent group gpio
    getent group render
    getent group video
    getent group input
    getent group i2c
    getent group spi
    ```

=== "Linux"

    ```shell
    getent group render
    getent group video
    getent group input
    ```

### How to get the UID?

The `XDG_RUNTIME_DIR` variable requires a `UID`. This `UID` is the unique `ID` of the current user who will run the `docker compose` or `podman-compose` command.

=== "Linux"

    ```shell
    echo $UID
    ```

=== "Windows WSL2"

    ```shell
    echo $UID
    ```

!!! info "XDG Base Directory"

    Mac OS doesn't leverage `XDG_RUNTIME_DIR` variable as there is no support of [XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) on Mac OS.
