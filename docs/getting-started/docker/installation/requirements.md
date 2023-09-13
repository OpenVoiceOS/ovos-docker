# Final steps before the run

Before going further, please make sure to refer to this [section](../composition.md) as the following commands could defer depending your setup.

## Get the `ovos-docker` sources

The `~/hivemind` directory is only required if you plan to use [HiveMind](../../../about/glossary/terms.md#hivemind).

=== "All"

  ```shell
  git clone https://github.com/OpenVoiceOS/ovos-docker.git -b dev
  mkdir -p ~/ovos/{config,share,tmp} ~/hivemind/{config,share}
  chown ${USER}:${USER} -R ~/ovos ~/hivemind
  cd ~/ovos-docker/compose
  ```

## Set the environment file

The `composer` requires an environment file in order to deploy the services and volumes with the correct settings for your setup.

!!! info "`alpha` version by default"

    As mentioned [in this section](../composition.md#environment-files), the current default `VERSION` *(tag)* is `alpha`.

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
