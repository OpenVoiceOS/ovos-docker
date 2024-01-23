# Open Voice OS configuration

`~/ovos/config/mycroft.conf` configuration file is mounted into each containers as a `read-only` volume.

!!! tip "First I configure then I deploy"

    Before deploying the services and volumes, it is recommended to set the OVOS's configuration to make sure the services initial start has the correct settings such as the `lang` for example.

## Initial configuration

This configuration is very basic, it instructs the Open Voice OS instance to run in `English` as main language.

```json title="~/ovos/config/mycroft.conf"
{
  "play_wav_cmdline": "aplay %1",
  "lang": "en-us",
  "listener": {
    "VAD": {
      "module": "ovos-vad-plugin-silero"
    }
  }
}
```

## Configure the logging

By default, the Open Voice OS [services](../../../about/glossary/components.md) will write their logs into a file under `~/.local/state/mycroft` directory but since we are running containers, we can leverage the `docker logs` or `podman logs` commands.

The solution is to add these lines into the `~/ovos/config/mycroft.conf` file _(create the file if it does not exist)_, this will tell the services to redirect their logs to the container `stdout`.

```json title="~/ovos/config/mycroft.conf"
{
  "logs": {
    "path": "stdout"
  },
  "play_wav_cmdline": "aplay %1",
  "lang": "en-us",
  "listener": {
    "VAD": {
      "module": "ovos-vad-plugin-silero"
    }
  }
}
```

During debug session, it might be useful to retrieve information from the different component using the `ovos-logs` command, this command is looking for log files from the `~/.local/state/mycroft` directory. If needed, then remove the following lines from the `~/ovos/config/mycroft.conf` file.

```json title="~/ovos/config/mycroft.conf"
{
  "logs": {
    "path": "stdout"
  }
}
```

!!! note "Services already deployed"

    If the services have been already deployed and the `~/ovos/config/mycroft.conf` has changed, then you will have to restart the containers impacted by the change(s).

## Custom `.asoundrc` for ALSA

Sometime a custom `.asoundrc` file migth be required, a common example is when a voice [HAT](https://www.raspberrypi.com/news/introducing-raspberry-pi-hats/) _(Hardware Attached on Top)_ such as [Google AIY Voice Hat](https://aiyprojects.withgoogle.com/voice-v1/) is connected to a Raspberry Pi, a custom `.asoundrc` might be required to make it works with ALSA.

In order to pass this custom `.asoundrc` file to the containers, the file must be created within the `~/ovos/config/` directory and named `asoundrc` _(with no `.`)_.

!!! info "Only for the containers using sound"

    The custom `.asoundrc` file will be passed only to the containers who leverage the audio stack; `ovos_listener`, `ovos_phal`, `ovos_audio`, `ovos_core`.

```title="~/ovos/config/asoundrc"
# Configuration for Google AIY Voice Hat V1
options snd_rpi_googlemihat_soundcard index=0

pcm.softvol {
    type softvol
    slave.pcm dmix
    control {
        name Master
        card 0
    }
}

pcm.micboost {
    type route
    slave.pcm dsnoop
    ttable {
        0.0 30.0
        1.1 30.0
    }
}

pcm.!default {
    type asym
    playback.pcm "plug:softvol"
    capture.pcm "plug:micboost"
}

ctl.!default {
    type hw
    card 0
}
```

!!! note "Services already deployed"

    If the services have been already deployed and the `~/ovos/config/asoundrc` has changed, then you will have to restart the containers impacted by the change(s).
