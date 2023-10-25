# Open Voice OS running on Mac OS with Docker

*   [Open Voice OS running on Mac OS with Docker](#open-voice-os-running-on-mac-os-with-docker)
*   [Limitations](#limitations)
*   [Requirements](#requirements)
  *   [Brew](#brew)
  *   [Docker](#docker)
  *   [PulseAudio](#pulseaudio)
*   [How to use these images](#how-to-use-these-images)
*   [Thanks](#thanks)
*   [Support](#support)

## Limitations

Because Open Voice OS was designed to run on Linux operating system, some limitations exist on Mac OS.

*   Open Voice OS GUI is not available
*   DBus is not yet supported which prevent the use of MPRIS via the `ovos_audio` container
*   Some plugins with PHAL will/could be limited to what Mac OS supports

## Requirements

### Brew

In order to run Open Voice OS on Mac OS, some components such as PulseAudio or DBus are required. Because these components come from the Linux ecosystem, `brew` package manager will be a requirement to install them.

For more information about Homebrew and how to install it, please read the [documentation](https://brew.sh/).

Once install, run the following command to ensure that Homebrew is correctly installed.

```bash
brew doctor
```

### Docker

Even if Podman is available on Mac OS, Docker Desktop is required in order to provide the container engine. For more information about Docker Desktop, please visit <https://www.docker.com/products/docker-desktop>.

Once installed and started, run the following command to ensure that Docker engine is up and running.

```bash
docker system info
```

*Docker Desktop doesn't start by default when Mac OS boots up.*

### PulseAudio

PulseAudio doesn't run natively on Mac OS, fortunatly, `brew` provides a package to install it.

```bash
brew install pulseaudio
```

By default, PulseAudio is using a Unix socket as communication channel but this will not be enough, the native TCP module must be enabled.

```bash
brew services stop pulseaudio
sed -i "" "s/#load-module module-native-protocol-tcp/load-module module-native-protocol-tcp/g" $(brew ls pulseaudio | grep default.pa$)
```

Once the `default.pa` file is edited, start the service *(the service will be started at each login)*.

```bash
brew services start pulseaudio
brew services info pulseaudio
```

Make sure the service is running properly as a daemon.

```bash
pulseaudio --check -v
```

If eveything is up and running, then the `pactl info` command should return basic information about PulseAudio such as the default `sink` and `source`.

The ultime test will be to run a Docker container and waiting for the sounds the be played.

```bash
docker run --rm -it -v ~/.config/pulse:/home/pulseaudio/.config/pulse keinos/speaker-test
```

If successful you should hear test sounds from left and right speakers and see this output:

```text
speaker-test 1.2.2

Playback device is default
Stream parameters are 48000Hz, S16_LE, 2 channels
WAV file(s)
Rate set to 48000Hz (requested 48000Hz)
Buffer size range from 96 to 1048576
Period size range from 32 to 349526
Using max buffer size 1048576
Periods = 4
was set period_size = 262144
was set buffer_size = 1048576
 0 - Front Left
 1 - Front Right
Time per period = 3.278807
```

In case of issues, you could have a look to the PulseAudio log file.

*   Apple Silicon based: `cat /opt/homebrew/var/log/pulseaudio.log`
*   Intel based: `cat /usr/local/var/log/pulseaudio.log`

Check for lines starting with `E:`, like:

```text
E: [] socket-server.c: bind(): Address already in use
E: [] module.c: Failed to load module "module-esound-protocol-unix" (argument: ""): initialization failed.
```

## How to use these images

Please refer to [this section](README.md#how-to-use-these-images) of the documentation.

## Thanks

Thanks to [@mikejgray](https://github.com/mikejgray/) and [@rushic24](https://github.com/rushic24) for helping :clap::punch:.

## Support

*   [Matrix channel](https://matrix.to/#/#openvoiceos:matrix.org)
*   [Contribute to Open Voice OS](https://openvoiceos.github.io/community-docs/contributing/)
*   [Report bugs related to these Docker images](https://github.com/OpenVoiceOS/ovos-docker/issues)
