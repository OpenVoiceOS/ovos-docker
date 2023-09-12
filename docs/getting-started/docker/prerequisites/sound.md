# Sound system

## Installation

[PulseAudio](https://en.wikipedia.org/wiki/PulseAudio) is a requirement and has to be up and running on the host *(not inside the containers)* to expose a socket *(for communication)* and a cookie *(for authentication)* to allow the containers to have access to the microphone *(input device)* and speakers *(output device)*.

On modern Linux distribution, [PipeWire](https://en.wikipedia.org/wiki/PipeWire) now handles the sound stack on the system.

By default PipeWire doesn't handle the backward compatibility with the PulseAudio API so make sure PulseAudio support is enabled within PipeWire.

=== "Debian"

    ```shell
    sudo apt install pipewire-pulse pulseaudio-utils
    ```

=== "Fedora"

    ```shell
    sudo dnf install pipewire-pulse pulseaudio-utils
    ```

=== "Arch"

    ```shell
    sudo pacman -S pipewire-pulse pulseaudio-utils
    ```

=== "Mac OS"

    ```shell
    brew install pulseaudio
    ```

=== "Windows WSL2"

    ```shell
    sudo apt install pulseaudio

    ```

The `pipewire-pulse`service must be started as a simple user and not as `root` user.

=== "Linux"

    ```shell
    systemctl --user status pipewire-pulse
    systemctl --user start pipewire-pulse
    ```

=== "Mac OS"

    ```shell
    brew services stop pulseaudio
    sed -i "" "s/#load-module module-native-protocol-tcp/load-module module-native-protocol-tcp/g" $(brew ls pulseaudio | grep default.pa$)
    brew services start pulseaudio
    ```

The user running the containers must be part of the `audio` system group *(depending the Linux distribution)*.

!!! warning "PulseAudio files permissions"

    Check the permissions for `~/.config/pulse/` and `/run/user/1000/` directories, they should belong to the user running the stack *(where `1000` is your user ID)*, not to `root` user. **If you are running on Mac OS, there is no `/run/user/1000/` directory.**

## Validation

`pactl` is a PulseAudio command shipped with the `pulseaudio-utils` package. This command provides information about the status of PulseAudio.

=== "All"

    ```shell
    pactl info
    ```

When PulseAudio is succesfully running, you should see a similar output.

```text
Server String: /run/user/1000/pulse/native
Library Protocol Version: 35
Server Protocol Version: 35
Is Local: yes
Client Index: 216
Tile Size: 65472
User Name: goldyfruit
Host Name: stronghold
Server Name: PulseAudio (on PipeWire 0.3.77)
Server Version: 15.0.0
Default Sample Specification: float32le 2ch 48000Hz
Default Channel Map: front-left,front-right
Default Sink: alsa_output.usb-Burr-Brown_from_TI_USB_Audio_DAC-00.iec958-stereo
Default Source: alsa_input.usb-Audient_EVO4-00.analog-surround-40
Cookie: 678e:9865
```

!!! note ""

    If you are running PulseAudio via PipeWire, the `Server Name` will display `(on PipeWire X.X.X)`.

### List microphones

At least one of the sources *(microphones/audio input)* returned, should match the `Default Source` line from the `pactl info` command.

=== "All"

    ```shell
    pactl list sources short
    ```

### List speakers

At least one of the sinks *(speakers/audio output)* returned, should match the `Default Sink` line from the `pactl info` command.

=== "All"

    ```shell
    pactl list sinks short
    ```
