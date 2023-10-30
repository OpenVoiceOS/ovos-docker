# Sound system

[PulseAudio](https://en.wikipedia.org/wiki/PulseAudio) is a requirement and has to be up and running on the host *(not inside the containers)* to expose a socket *(for communication)* and a cookie *(for authentication)* to allow the containers to have access to the microphone *(input device)* and speakers *(output device)*.

On modern Linux distribution, [PipeWire](https://en.wikipedia.org/wiki/PipeWire) now handles the sound stack on the system.

!!! info "Sound server auto-detection"

    `ovos-docker` supports both native PulseAudio and PipeWire, the containers will automatically detect which sound server is running on the operating system.

## Mac OS and Windows

If you are running an operating system other Linux such as Mac OS or Windows, then PulseAudio will have to be installed to act as a gateway between the containers and the OS.

=== "Mac OS"

    ```shell
    brew install pulseaudio
    brew services stop pulseaudio
    sed -i "" "s/#load-module module-native-protocol-tcp/load-module module-native-protocol-tcp/g" $(brew ls pulseaudio | grep default.pa$)
    brew services start pulseaudio
    ```

=== "Windows WSL2"

    ```shell
    sudo apt install pulseaudio
    ```

## Permissions

The user running the containers must be part of the `audio` system group *(depending the Linux distribution)*.

!!! warning "PulseAudio files permissions"

    Check the permissions for `~/.config/pulse/` and `/run/user/1000/pulse` directories, they should belong to the user running the stack *(where `1000` is your user ID)*, not to `root` user.

    **If you are running on Mac OS, there is no `/run/user/1000/` directory.**

## Validation

`pactl` is a PulseAudio command shipped with the `pulseaudio-utils` package and `pw-cli` is a PipeWire command shipped with `pipewire-utils` or `pipewire-bin` depending your distribution.

These commands provide information about the status of PulseAudio or PipeWire.

=== "PulseAudio"

    ```shell
    pactl info
    ```

=== "PipeWire"

    ```shell
    pw-cli info
    ```

### List microphones

At least one of the sources *(microphones/audio input)* returned, should match the `Default Source` line from the `pactl info` command or the `Audio/Source` line from the `wpctl status` command.

=== "PulseAudio"

    ```shell
    pactl list sources short
    ```

=== "PipeWire"

    ```shell
    wpctl status | grep Audio/Source
    ```

### List speakers

At least one of the sinks *(speakers/audio output)* returned, should match the `Default Sink` line from the `pactl info` command or the `Audio/Sink` line from the `wpctl status` command.

=== "PulseAudio"

    ```shell
    pactl list sinks short
    ```

=== "PipeWire"

    ```shell
    wpctl status | grep Audio/Sink
    ```
