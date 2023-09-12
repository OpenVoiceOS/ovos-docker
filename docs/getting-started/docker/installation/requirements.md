# Final steps before the run

Before going further, please make sure to read this [section](../composition.md) as the following commands could defer depending your setup.

## Get the sources

=== "All"

  ```shell
  git clone https://github.com/OpenVoiceOS/ovos-docker.git
  mkdir -p ~/ovos/{config,share,tmp} ~/hivemind/{config,share}
  chown ${USER}:${USER} -R ~/ovos ~/hivemind
  cd ~/ovos-docker/compose
  ```

## Set the environment file

!!! note "`alpha` version by default"

    As mentioned [here](../composition.md#environment-files), the current default `VERSION` *(tag)* is `alpha`.

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
