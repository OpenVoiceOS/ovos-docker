# Open Voice OS command line

The command line allows you to send a message *(but not only)* directly to the message bus by using the `ovos-cli-client` command from the `ovo_cli` container.

!!! warning "Skill interactions"

    The command line doesn't support any action related to skills other than `:skills` as this setup is running inside containers. Please read the [skill section](./installation/skills.md) to manage skills.

![type:video](../../assets/videos/ovos-cli.webm)

## ovos-cli-client

!!! warning "`ovos-cli-client` is deprecated"

    Please read https://github.com/OpenVoiceOS/ovos-cli-client/issues/14 for more information.

Interact directly with the [ncurses](https://en.wikipedia.org/wiki/Ncurses) OVOS client interface.

=== "Docker"

    ```shell
    docker exec --interactive --tty ovos_cli ovos-cli-client
    ```

=== "Podman"

    ```shell
    podman exec --interactive --tty ovos_cli ovos-cli-client
    ```

## ovos-config

To display or manage the current configuration, the `ovos-config` command could be used.

!!! failure "`read-write` access to the configuration"

    The `ovos_cli` container is the only one having `read-write` access to the `mycroft.conf` configuration file.

=== "Docker"

    ```shell
    docker exec --interactive --tty ovos_cli ovos-config show
    ```

=== "Podman"

    ```shell
    podman exec --interactive --tty ovos_cli ovos-config show
    ```

!!! note "`vim` as default editor"

    `vim` and `nano` editors are available within the `ovos-cli` image, `vim` has been set as default.

## ovos-speak

An easy way to make Open Voice OS speaks is to run the `ovos-speak` command.

=== "Docker"

    ```shell
    docker exec --interactive --tty ovos_cli ovos-speak "hello world"
    ```

=== "Podman"

    ```shell
    podman exec --interactive --tty ovos_cli ovos-speak "hello world"
    ```

## mana

[Neon Mana](https://github.com/NeonGeckoCom/neon-mana-utils) *(Messagebus Application for Neon AI)* provides tools for interacting with the message bus.

=== "Docker"

    ```shell
    docker exec --interactive --tty ovos_cli mana --help
    ```

=== "Podman"

    ```shell
    podman exec --interactive --tty ovos_cli mana --help
    ```
