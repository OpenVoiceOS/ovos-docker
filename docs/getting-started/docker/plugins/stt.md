# Speech-To-Text plugins

The [Speech-To-Text](../../../about/glossary/terms.md#speech-to-text-stt) plugins allow you to connect Open Voice OS with different STT servers, it could be [FasterWhisper](https://github.com/guillaumekln/faster-whisper), [VOSK](https://alphacephei.com/vosk/), [Google Translate](https://translate.google.com/), [Deepgram](https://deepgram.com/), etc... Each of these STT providers will have different languages support, precision and performances.

!!! note

    The Speech-To-Text plugins are handled by the `ovos_listener` container.

The `ovos_listener` container comes with few pre-installed STT plugins such as:

- `ovos-stt-plugin-chromium` uses the Google Chrome browser API
- `ovos-stt-plugin-server` allows you to reach an external STT service
- `ovos-stt-plugin-vosk` is an offline STT service

If the existing STT plugins are not enough then you can install yours by following the same principle as for the [microphone plugins](./microphone.md) by adding a `listener.list` file within the `~/ovos/config/` directory, this file acts as a Python `requirements.txt` file.

!!! warning "Plugins requirements"

    These plugins have to be compatible with the `pip install` method which requires a `setup.py` file.

When the `ovos_listener` container starts, it will look for this file and install the plugins defined in there.

```ini title="~/ovos/config/listener.list"
ovos-stt-plugin-vosk==0.2.0a1 # Specific plugin version on PyPi
ovos-stt-plugin-server # Latest plugin version on PyPi
git+https://github.com/OpenVoiceOS/ovos-stt-plugin-chromium.git@fix/whatever # Specific branch of a plugin on GitHub
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
