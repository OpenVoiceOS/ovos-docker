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
  },
  "sounds": {
    "start_listening": "/home/ovos/.venv/lib/python3.11/site-packages/ovos_dinkum_listener/res/snd/start_listening.wav"
  }
}
```

## Configure the logging

By default, the Open Voice OS [services](../../../about/glossary/components.md) will write their logs into a file under `~/.local` directory, these files are not rotated or compressed which could lead to a disk space issue.

The solution is to add these lines into the `~/ovos/config/mycroft.conf` file *(create the file if it does not exist)*, this will tell the services to redirect their logs to the container `stdout`.

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
  },
  "sounds": {
    "start_listening": "/home/ovos/.venv/lib/python3.11/site-packages/ovos_audio/res/snd/start_listening.wav"
  }
}
```

!!! note "Services already deployed"

    If the services have been already deployed and the `~/ovos/config/mycroft.conf` has changed, then you will have to restart the containers impacted by the change(s).
