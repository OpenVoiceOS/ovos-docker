# Text-To-Speech plugins

The [Text-To-Speech](../../../about/glossary/terms.md#text-to-speech-tts) plugins allow you to connect Open Voice OS with different TTS servers, it could be [Piper](https://rhasspy.github.io/piper-samples/), [Coqui](https://coqui.ai/), [Amazon Polly](https://aws.amazon.com/polly/), [Mimic](https://mycroft-ai.gitbook.io/docs/mycroft-technologies/mimic-tts/mimic-overview), etc... Each of these TTS providers will have different voices and languages.

!!! note

    The Text-To-Speech plugins are handled by the `ovos_audio` container.

The `ovos_audio` container comes with few pre-installed TTS plugins such as:

- `ovos-tts-plugin-polly` is the Amazon Polly TTS server _(authentication required)_
- `ovos-tts-plugin-server` allows you to reach an external TTS service

If the existing TTS plugins are not enough then you can install yours by following the same principle as for the [skills](../installation/skills.md) by adding an `audio.list` file within the `~/ovos/config/` directory, this file acts as a Python `requirements.txt` file.

!!! warning "Plugins requirements"

    These plugins have to be compatible with the `pip install` method which requires a `setup.py` file.

When the `ovos_audio` container starts, it will look for this file and install the plugins defined in there.

```ini title="~/ovos/config/audio.list"
ovos-tts-plugin-marytts==0.0.1a1 # Specific plugin version on PyPi
neon-tts-plugin-mozilla-remote # Latest plugin version on PyPi
git+https://github.com/OpenVoiceOS/ovos-tts-plugin-piper.git@fix/whatever # Specific branch of a plugin on GitHub
```

The `ovos_audio` container must be restarted if a change occurs in the `audio.list` file.

=== "Docker"

    ```shell
    docker restart ovos_audio
    ```

=== "Podman"

    ```shell
    podman restart ovos_audio
    ```
