# Open Voice OS running on Mac OS with Docker

- [Open Voice OS running on Mac OS with Docker](#open-voice-os-running-on-mac-os-with-docker)
  * [Limitations](#limitations)
  * [Requirements](#requirements)
    + [Brew](#brew)
    + [Audio players](#audio-players)
    + [Docker](#docker)
  * [How to use these images](#how-to-use-these-images)
  * [Thanks](#thanks)
  * [Support](#support)

## Limitations

Because Open Voice OS was designed to run on Linux operating system, some limitations exist on Mac OS.

- Open Voice OS GUI is not available
- DBus is not yet supported which prevent the use of MPRIS via the `ovos_audio` container
- Some plugins with PHAL will/could be limited to what Mac OS supports

## Requirements

### Brew

In order to run Open Voice OS on Mac OS, some components such as DBus are required. Because these components come from the Linux ecosystem, `brew` package manager will be a requirement to install them.

For more information about Homebrew and how to install it, please read the [documentation](https://brew.sh/).

Once install, run the following command to ensure that Homebrew is correctly installed.

```bash
brew doctor
```

### Audio players

In order to play audio files, Open Voice OS requires some audio tools like `aplay`or `paplay` but these are tools from Linux. Mac OS comes with `afplay` which could be used to play some audio files but not all of them.

To solve this missing requirement, the `sox` package has to be installed via `brew`. By installing this package, few dependancies will be installed as well such as `flac`, `mpg123`, etc...

```bash
brew install sox
```

### Docker

Even if Podman is available on Mac OS, Docker Desktop is required in order to provide the container engine. For more information about Docker Desktop, please visit <https://www.docker.com/products/docker-desktop>.

Once installed and started, run the following command to ensure that Docker engine is up and running.

```bash
docker system info
```

*Docker Desktop doesn't start by default when Mac OS boots up.*

## How to use these images

Please refer to [this section](README.md#how-to-use-these-images) of the documentation to install Open Voice OS.

The `ovos-microphone-plugin-sounddevice` plugin will is required by the `ovos_listener` container to detect the wake word and listen for the utterance.

Adjust the `mycroft.conf` configuration with the following:

```json
{
  "play_wav_cmdline": "afplay %1",
  "listener": {
    "microphone": {
      "module": "ovos-microphone-plugin-sounddevice"
    }
  }
}
```

No need to restart the `ovos_listener` container as the change will be picked up by the Python processus.

## Thanks

Thanks to [@mikejgray](https://github.com/mikejgray/) and [@rushic24](https://github.com/rushic24) for helping :clap::punch:.

## Support

- [Matrix channel](https://matrix.to/#/#openvoiceos:matrix.org)
- [Open Voice OS documentation](https://openvoiceos.github.io/community-docs/)
- [Contribute to Open Voice OS](https://openvoiceos.github.io/community-docs/contributing/)
- [Report bugs related to these Docker images](https://github.com/OpenVoiceOS/ovos-docker/issues)
