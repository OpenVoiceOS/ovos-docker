# Debugging

## Enable debug mode

First thing's first, enable the Open Voice OS's debug mode in `~/ovos/config/mycroft.conf` to get more verbosity from the logs.

!!! info "Restart containers"

    All containers will have to be restarted to receive the configuration change.

```json title="~/ovos/config/mycroft.conf"
{
  "debug": true,
  "log_level": "DEBUG",
  "logs": {
    "path": "stdout"
  }
}
```

## All containers logs

!!! note
    The commands below are not don't have to be followed in the same order as they are presented!

To access all the container logs at the same time, run the following command *(make sure it matches the `docker compose` or `podman-compose` command you run to deploy the stack)*:

=== "Docker"

    ```shell
    docker compose --file docker-compose.yml --file docker-compose.raspberrypi.yml --file docker-compose.skills.yml --env-file .env logs --follow --tail 200
    ```

=== "Podman"

    ```shell
    podman-compose --file docker-compose.yml --file docker-compose.raspberrypi.yml --file docker-compose.skills.yml --env-file .env logs --follow --tail 200
    ```

## Specific contaienr logs

To access the logs of a specific container, run the following command:

=== "Docker"

    ```shell
    docker logs --follow --tail 200 ovos_audio
    ```

=== "Podman"

    ```shell
    podman logs --follow --tail 200 ovos_audio
    ```

## Run command in a container

To execute a command inside a container without going into it, run the following command:

=== "Docker"

    ```shell
    docker exec --tty --interactive ovos_audio pactl info
    ```

=== "Podman"

    ```shell
    podman exec --tty --interactive ovos_audio pactl info
    ```

## Connect inside a container

To go inside a container and run multiple commands, run the following command *(where `sh` is the available shell in there)*:

=== "Docker"

    ```shell
    docker exec --tty --interactive ovos_audio sh
    ```

=== "Podman"

    ```shell
    podman exec --tty --interactive ovos_audio sh
    ```

## Configuration syntax check

Make sure the `mycroft.conf` configuration file is [JSON](https://en.wikipedia.org/wiki/JSON) valid by using the `jq` command.

!!! warning "`jq` command"

    In order to use `jq` command, it should be installed on your system.

```shell
cat ~/ovos/config/mycroft.conf | jq
```

If the configuration file is not valid JSON, `jq` will return something like this:

```text
parse error: Expected another key-value pair at line 81, column 3
```

## Docker/Podman consumption

To get the CPU, memory and [I/O](https://en.wikipedia.org/wiki/Input/output) consumption per container, run the following command:

=== "Docker"

    ```shell
    docker stats --all --no-trunc
    ```

=== "Podman"

    ```shell
    podman stats --all --no-trunc
    ```

## Docker/Podman volume usage

To get the disk usage per volumes, run the following command:

=== "Docker"

    ```shell
    docker system df
    ```

=== "Podman"

    ```shell
    podman system df
    ```
