# Container engine

## Installation

As we are leveraging containers, a container engine such as Docker or Podman is required *(only one of them should be installed)*, as well as their `composer`. If you are not familiar with what a `composer` is then please read [this section](../index.md) first.

!!! danger "`docker-compose` versus `docker compose`"

    As [mentioned by Docker](https://docs.docker.com/compose/), from July 2023 Compsoe V1 (`docker-compose`) will not received updates anymore which makes it deprecated and replaced by Compose V2 (`docker compose`) directly embedded into the `docker` command line.

Either you choose to install Docker or Podman and their `composer` on Linux, Mac OS or Windows, please refer to the official documentation[^1].

!!! warning "Minimum required versions"

    In order to get the latest features supported by [ovos-docker](https://github.com/OpenVoiceOS/ovos-docker/), please make sure to install a recent version of Docker or Podman for your operating system.

You should not run `docker` command as `root` user or using `sudo` command, if so then you will get some error message such as `Permission denied` and some containers could restart in a loop. To allow a simple user to execute the `docker` command, make sure to add the user to the `docker` group.

=== "Linux"

    ```shell
    sudo usermod -a -G docker $USER
    ```

Once added to the `docker` group you will have to logout from the current session *(graphical or SSH)*.

## Validation

=== "Docker"

    ```shell
    docker system info
    docker container list
    ```

=== "Podman"

    ```shell
    podman system info
    podman container list
    ```

[^1]: [Docker official documentation](https://docs.docker.com/engine/install/) or [Podman official documentation](https://podman.io/docs/installation).
