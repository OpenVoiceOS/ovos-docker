# Microphone plugins

A microhpone plugin allows you to use a specific sound protocol in order to get voice samples from your Microphone. Depending the operating you are running on, you will have to choose the correct plugin.

!!! note

    The microhpone plugins are handled by the `ovos_listener` container.

The `ovos_listener` container comes with few pre-installed microphone plugins such as:

- `ovos-microphone-plugin-alsa` is using [pyalsaaudio](https://larsimmisch.github.io/pyalsaaudio/) Python library
- `ovos-microphone-plugin-sounddevice` is using [sounddevice](https://python-sounddevice.readthedocs.io/) Python library

If the existing microphone plugins are not enough then you can install yours by following the same principle as for the [TTS plugins](./tts.md) by adding a `listener.list` file within the `~/ovos/config/` directory, this file acts as a Python `requirements.txt` file.

When the `ovos_listener` container starts, it will look for this file and install the skills defined in there. These skills have to be compatible with the `pip install` method which requires a `setup.py` file.

```ini title="~/ovos/config/listener.list"
ovos-microphone-plugin-pyaudio==0.2.0a1 # Specific plugin version on PyPi
ovos-microphone-plugin-arecord  # Latest plugin version on PyPi
git+https://github.com/OpenVoiceOS/ovos-microphone-plugin-socket.git@fix/whatever # Specific branch of a plugin on GitHub
```

The `ovos_listener` container must be restarted if a change occurs in the `listener.list` file.

=== "Docker"

    ```shell
    docker restart ovos_listener
    ```

=== "Podman"

    ```shell
    podman restart ovos_listener
    ```

## Which plugin to choose?

Here are the two main plugins to use per platform.

| Plugin                               | Platforms                                                                                                                                                                                                               |
| ------------------------------------ |  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ovos-microphone-plugin-alsa`        | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } |
| `ovos-microphone-plugin-sounddevice` | :fontawesome-brands-linux:{ .lg title="Linux" } :fontawesome-brands-raspberry-pi:{ .lg title="Raspberry Pi" } :fontawesome-brands-apple:{ .lg title="Mac OS" } :fontawesome-brands-windows:{ .lg title="Windows WSL2" } |

!!! warning "Choose the correct plugin"

    If a wrong plugin is used, the [listener](../../../about/glossary/components.md#ovos-listener) will not be able to hear you which means that you will not be able to interact with your Open Voice OS instance.
