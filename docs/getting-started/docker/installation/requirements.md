# Final steps before the run

Before going further, please make sure to refer to this [section](../composition.md) as the following commands could differ depending on your setup.

## Get the `ovos-docker` sources

The `/home/hivemind/hivemind` directory is only required if you plan to use [HiveMind](../../../about/glossary/terms.md#hivemind). If you don't need HiveMind, skip those paths.

=== "All"

```shell
git clone https://github.com/OpenVoiceOS/ovos-docker.git ~/ovos-docker
sudo mkdir -p /home/ovos/ovos/{config/phal,config/persona,share,tmp} /home/hivemind/hivemind/{config/phal,share}
sudo chown ${USER}:${USER} -R /home/ovos/ovos /home/hivemind/hivemind
cd ~/ovos-docker/compose
```

If you use your own compose files, cloning the repository is optional. If you plan
to build images locally, keep the repository handy for `scripts/bake.sh`.

## Enable user manager

Because some containers require `/run/user/1000` to be mounted, [systemd](https://en.wikipedia.org/wiki/Systemd) should be instructed to log the user in during the boot process and make the `/run/user/1000` directory available before the containers start.

=== "Raspberry Pi"

    ```shell
    sudo loginctl enable-linger $USER
    ```

=== "Linux"

    ```shell
    sudo loginctl enable-linger $USER
    ```

## Set the environment file

!!! danger "`.env` file is a strong requirement"

    Please make sure to read and understand this section because if you don't, the deployment might fail.

The `composer` requires an environment file in order to deploy the services and volumes with the correct settings for your setup.

!!! info "`alpha` version by default"

    As mentioned [in this section](../composition.md#environment-files), the current default `VERSION` *(tag)* is `alpha`.

Copy one of the provided examples to `.env` and adjust the values. The examples
live next to the compose files under `compose/`.

=== "Raspberry Pi"

    ```shell
    cp .env-raspberrypi .env
    ```

=== "Linux / Mac OS / Windows WSL2"

    ```shell
    cp .env.example .env
    ```

Below is a minimal example for Linux _(not Raspberry Pi)_. Please read
[this section](../composition.md#environment-files) for more details about what
these variables do.

```ini title=".env"
DISPLAY=:0
HIVEMIND_CONFIG_FOLDER=/home/hivemind/hivemind/config
HIVEMIND_CONFIG_PHAL_FOLDER=/home/hivemind/hivemind/config/phal
HIVEMIND_SHARE_FOLDER=/home/hivemind/hivemind/share
HIVEMIND_USER=hivemind
INPUT_GID=102
OVOS_CONFIG_FOLDER=/home/ovos/ovos/config
OVOS_CONFIG_PHAL_FOLDER=/home/ovos/ovos/config/phal
OVOS_PERSONA_FOLDER=/home/ovos/ovos/config/persona
OVOS_SHARE_FOLDER=/home/ovos/ovos/share
OVOS_USER=ovos
PULL_POLICY=always
TMP_FOLDER=/home/ovos/ovos/tmp
TZ=UTC
VERSION=alpha
VIDEO_GID=44
XDG_RUNTIME_DIR=/run/user/1000
```

Adjust the paths and IDs to match your system. Throughout the docs, `~/ovos`
refers to the host OVOS directory matching your `.env` settings (default
`/home/ovos/ovos`). The `compose/.env.example` file contains additional options
you can enable for specific platforms.

## I2C and SPI on Raspberry Pi

The Raspberry Pi board supports [I2C](https://en.wikipedia.org/wiki/I%C2%B2C), [I2S](https://en.wikipedia.org/wiki/I%C2%B2S) and [SPI](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface) buses. These three buses must be enabled in order to allow the containers below to start:

- `ovos_core`
- `ovos_phal`
- `ovos_phal_admin`

Follow the steps below to enable I2C, I2S and SPI.

=== "Raspberry Pi"

    ```shell
    echo "dtparam=i2c_arm=on" | sudo tee -a /boot/config.txt
    echo "dtparam=i2s=on" | sudo tee -a /boot/config.txt
    echo "dtparam=spi=on" | sudo tee -a /boot/config.txt
    echo "i2c-dev" | sudo tee /etc/modules-load.d/i2c.conf
    sudo reboot
    ```
