# Open Voice OS running on Mac OS with Docker

## Limitations

Because Open Voice OS was designed to run on Linux operating system, some limitations exist on Mac OS.

- Open Voice OS GUI is not available
- DBus is not yet supported which prevent the use of MPRIS via the `ovos_audio` container
- Some plugins with PHAL will/could be limited to what Mac OS supports

## Requirements

### Brew

In order to run Open Voice OS on Mac OS, some component such as PulseAudio or DBus are required. Because these components come from the Linux ecosystem, `brew` package manager will be a requirement to install them.

For more information about Homebrew and how to install it, please read the [documentation](https://brew.sh/).

Once install, run the following command to ensure that Homebrew is correctly installed.

```bash
brew doctor
```

### Docker

Docker Desktop is required in order to provide the container engine. For more information about Docker Desktop, please visit <https://www.docker.com/products/docker-desktop>.

Once installed and started, run the following command to ensure that Docker engine is up and running.

```bash
docker system info
```

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

Once the `default.pa` file is edited, start the service.

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
