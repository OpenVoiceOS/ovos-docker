# Install the Open Voice OS GUI

!!! warning "Linux only"

    The GUI is currently only available on Linux operating system, not on Mac OS or Windows.

## Configuration

The `ovos-gui-messagebus` component must be configured in order to receive the QML files from the skill containers. Because of these file transfers, the `ovos-message-bus` component must be configured to allow bigger payload.

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
  "gui": {
    "extension": "ovos-gui-plugin-shell-companion",
    "idle_display_skill": "skill-ovos-homescreen.openvoiceos",
    "generic": {
      "homescreen_supported": true
    },
    "gui_file_host_path": "/home/ovos/.cache/gui_files"
  },
  "websocket": {
    "max_msg_size": 100
  }
}
```

## GUI services deployment

!!! note "Podman users :muscle:"

    If you are running Podman instead of Docker, replace `docker compose` with `podmand-compose`.

=== "Raspberry Pi"

    ```shell
    docker compose --project-name ovos --file docker-compose.yml --file docker-compose.raspberrypi.yml --file docker-compose.skills.yml --file docker-compose.gui.yml --file docker-compose.raspberrypi.gui.yml up --detach
    ```

=== "Linux"

    ```shell
    docker compose --project-name ovos --file docker-compose.yml --file docker-compose.skills.yml --file docker-compose.gui.yml up --detach
    ```

!!! question "Hardware accelerated on Raspberry Pi 4 only"

    Raspberry Pi 4 will leverage the GPU hardware acceleration which will provide a smoother experience.

    **If not running on a Raspberry Pi 4 then the CPU will be used to render the GUI which will result in a big CPU consumption and a poor exprience.**
