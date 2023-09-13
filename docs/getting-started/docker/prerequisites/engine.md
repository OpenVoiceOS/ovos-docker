# Container engine

## Installation

As we are leveraging containers, a container engine such as Docker or Podman is required *(only one of them should be installed)*, as well as their `composer`.

*If you are not familiar with what a container engine or a `composer` are then please refer to [this section](../index.md) first as these fundamentals must be understood.*

### Versions

!!! danger "`docker-compose` versus `docker compose`"

    As [mentioned by Docker](https://docs.docker.com/compose/), from July 2023 Compose V1 *(`docker-compose`)* will not received updates anymore which makes it deprecated and replaced by Compose V2 *(`docker compose`)* directly embedded into the `docker` command line.

Either you choose to install [Docker](https://www.docker.com/) or [Podman](https://podman.io/) and their `composer` on [Linux](https://en.wikipedia.org/wiki/Linux), [Mac OS](https://en.wikipedia.org/wiki/Mac_operating_systems) or [Windows](https://en.wikipedia.org/wiki/Microsoft_Windows), please refer to the official documentation[^1].

!!! warning "Minimum required versions"

    In order to get the latest features supported by [ovos-docker](https://github.com/OpenVoiceOS/ovos-docker/), please make sure to install a recent version of Docker *(`>= 24.x.x`)* or Podman *(`>= 4.x.x`)* for your operating system.

### Don't be `root`, be a user

You should not run `docker` command as `root` user or using the `sudo` command, if so then you will get some error messages such as `Permission denied` and some containers could restart in a loop.

To allow a simple user to execute the `docker` command, make sure to add the user to the `docker` group.

=== "Linux"

    ```shell
    sudo usermod -a -G docker $USER
    ```

Once added to the `docker` group you will have to logout from the current session *(graphical or [SSH](https://en.wikipedia.org/wiki/Secure_Shell))* in order to get the group added to your user once you reconnect.

Once reconnected, run the following command to ensure the `docker` has been appened to your `$USER`.

=== "Linux"

    ```shell
    id
    uid=1000(foobar) gid=1000(foobar) groups=1000(foobar),973(docker)
    ```

*The `GID` could differ compare to your setup.*

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
