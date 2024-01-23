# Debugging

## Enable debug mode

First thing's first, enable the Open Voice OS's debug mode in `~/ovos/config/mycroft.conf` to get more verbosity from the logs.

!!! info "Restart containers"

    All containers will have to be restarted to receive the configuration change.

    ```shell
    docker restart --time 0 $(docker container list --all --filter 'name=ovos' --filter 'name=hivemind' --quiet)
    ```

```json title="~/ovos/config/mycroft.conf"
{
  "debug": true,
  "log_level": "DEBUG"
}
```

!!! note
The commands below don't have to be executed in the same order as they are presented, free free to run them in the order you want!

## All containers logs

Access all the container logs at the same time, run the following command _(make sure it matches the `docker compose` or `podman-compose` command you run to deploy the stack)_.

=== "Docker"

    ```shell
    docker compose --file docker-compose.yml --file docker-compose.raspberrypi.yml --file docker-compose.skills.yml --env-file .env logs --follow --tail 200
    ```

=== "Podman"

    ```shell
    podman-compose --file docker-compose.yml --file docker-compose.raspberrypi.yml --file docker-compose.skills.yml --env-file .env logs --follow --tail 200
    ```

## Specific container logs

Access the logs of a specific container.

=== "Docker"

    ```shell
    docker logs --follow --tail 200 ovos_audio
    ```

=== "Podman"

    ```shell
    podman logs --follow --tail 200 ovos_audio
    ```

## Run command in a container

Execute a command inside a container without going into it.

=== "Docker"

    ```shell
    docker exec --tty --interactive ovos_audio pactl info
    ```

=== "Podman"

    ```shell
    podman exec --tty --interactive ovos_audio pactl info
    ```

## Connect inside a container

Go inside a container and run multiple commands _(where `sh` is the available shell in there)_.

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

    In order to use the `jq` command, the package should be installed on your operating system.

```shell
cat ~/ovos/config/mycroft.conf | jq
```

If the configuration file is not valid JSON, `jq` will return something like this:

```text
parse error: Expected another key-value pair at line 81, column 3
```

## Docker/Podman consumption

Get the CPU, memory and [I/O](https://en.wikipedia.org/wiki/Input/output) consumption per container.

=== "Docker"

    ```shell
    docker stats --all --no-trunc
    ```

=== "Podman"

    ```shell
    podman stats --all --no-trunc
    ```

## Docker/Podman volume usage

Get the disk usage per volumes.

=== "Docker"

    ```shell
    docker system df
    ```

=== "Podman"

    ```shell
    podman system df
    ```
