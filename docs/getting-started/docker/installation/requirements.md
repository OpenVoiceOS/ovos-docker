# Final steps before the run

Before going further, please make sure to refer to this [section](../composition.md) as the following commands could defer depending your setup.

## Get the `ovos-docker` sources

The `~/hivemind` directory is only required if you plan to use [HiveMind](../../../about/glossary/terms.md#hivemind).

=== "All"

```shell
git clone https://github.com/OpenVoiceOS/ovos-docker.git ~/ovos-docker
mkdir -p ~/ovos/{config,share,tmp} ~/hivemind/{config,share}
chown ${USER}:${USER} -R ~/ovos ~/hivemind
cd ~/ovos-docker/compose
```

## Enable user manager

Because some containers require `/run/user/1000` to be mounted, [systemd](https://en.wikipedia.org/wiki/Systemd) should be instructed to log the user during the boot process and make `/run/user/1000` directory available before the containers start.

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

    Please make sure to read and understand this section as if you don't then the deployment migth fail.

The `composer` requires an environment file in order to deploy the services and volumes with the correct settings for your setup.

!!! info "`alpha` version by default"

    As mentioned [in this section](../composition.md#environment-files), the current default `VERSION` *(tag)* is `alpha`.

The example files start with a `.` _(dot)_ which means they are hidden, use the `ls -a` command to list all the files included the hidden ones.

Below is an example of `.env` for Linux _(not Raspberry Pi)_, please read [this section](../composition.md#environment-files) for more details about what these variables do.

```ini title=".env"
DISPLAY=:0
HIVEMIND_CONFIG_FOLDER=~/hivemind/config
HIVEMIND_SHARE_FOLDER=~/hivemind/share
HIVEMIND_USER=hivemind
INPUT_GID=102
OVOS_CONFIG_FOLDER=~/ovos/config
OVOS_SHARE_FOLDER=~/ovos/share
OVOS_USER=ovos
PULL_POLICY=always
TMP_FOLDER=~/ovos/tmp
TZ=America/Montreal
VERSION=alpha
VIDEO_GID=44
XDG_RUNTIME_DIR=/run/user/1000
```

=== "Raspberry Pi"

    ```shell
    cp .env-raspberrypi .env
    ```

=== "Linux"

    ```shell
    cp .env.example .env
    ```

=== "Mac OS"

    ```shell
    cp .env.example .env
    ```

=== "Windows WSL2"

    ```shell
    cp .env.example .env
    ```

Examples are provided, please make sure to select the right one and to set the proper values.

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
