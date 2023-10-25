# Open Voice OS running on Windows with WSL2 and Docker

*   [Open Voice OS running on Windows with WSL2 and Docker](#open-voice-os-running-on-windows-with-wsl2-and-docker)
  *   [Limitations](#limitations)
  *   [Requirements](#requirements)
    *   [Docker](#docker)
    *   [PulseAudio](#pulseaudio)
  *   [How to use these images](#how-to-use-these-images)
  *   [Thanks](#thanks)
  *   [Support](#support)

## Limitations

Because Open Voice OS was designed to run on Linux operating system, some limitations exist on Windows.

*   Open Voice OS GUI is not available
*   DBus is not yet supported which prevent the use of MPRIS via the `ovos_audio` container
*   Some plugins with PHAL will/could be limited to what WSL2 supports

## Requirements

### Docker

Docker Desktop is required in order to provide the container engine to WSL2. For more information about Docker Desktop, please visit <https://www.docker.com/products/docker-desktop>.

Once installed and started, run the following command to ensure that Docker engine is up and running.

```bash
docker system info
```

*Docker Desktop doesn't start by default when Windows boots up. You must have Docker Desktop running in Windows before WSL2 can use Docker.*

### PulseAudio

PulseAudio is available via WSLG, which runs in a separate VM. You must be on a recent version of WSL2 that provides WSLG.

You may need to install `pulseaudio` in your WSL environment. With Ubuntu, for example:

```bash
sudo apt install -y pulseaudio
```

The ultimate test will be to run a Docker container and waiting for the sounds to be played.

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

## How to use these images

Please refer to [this section](README.md#how-to-use-these-images) of the documentation.

## Thanks

Thanks to [@mikejgray](https://github.com/mikejgray/) and community member Ben for helping :clap::punch:.

## Support

*   [Matrix channel](https://matrix.to/#/#openvoiceos:matrix.org)
*   [Contribute to Open Voice OS](https://openvoiceos.github.io/community-docs/contributing/)
*   [Report bugs related to these Docker images](https://github.com/OpenVoiceOS/ovos-docker/issues)
