# Install the Open Voice OS GUI

!!! warning "Linux only"

    The GUI is currently only available on Linux operating system, not on Mac OS or Windows.

The Open Voice OS GUI supports two types of system execution:

  - Using [X](https://en.wikipedia.org/wiki/X_Window_System) or [Wayland](https://en.wikipedia.org/wiki/Wayland_(protocol)) display servers
  - Using [EGLFS](https://doc.qt.io/qt-6/embedded-linux.html#eglfs) which doesn't require any display server which is perfect for headless installation

When using EGLFS, the `DISPLAY` variable from the `.env` [composition environment file](../composition.md#environment-files) must be removed or commented as if present the X or Wayland display servers will be tried first and result in an `ovos_gui` container in error.

!!! question "Hardware accelerated on Raspberry Pi 4 and 5 only"

    Raspberry Pi 4 and 5 will leverage the GPU hardware acceleration which will provide a smoother experience.

    **If not running on a Raspberry Pi 4 or 5 then the CPU might be used to render the GUI which will result in a high CPU consumption and a poor exprience.**

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

## xhost and display servers

!!! tip

    You can skip this section if your are using EGLFS and go to [GUI services deployment](#gui-services-deployment).

In order to allow only the `ovos_gui` container to access to the X or Wayland display server, you will have to allow the container *(based on its hostname)* to connect to the display session.

```bash
export DISPLAY=":0"
xhost +local:ovos_gui
```

This command is not permanent, when your operating system will reboot you will have to run the command again. To make it permanent systemd should be leveraged as a user service.

=== "Raspberry Pi"

    ```shell
    mkdir -p ~/.config/systemd/user
    ```

=== "Linux"

    ```shell
    mkdir -p ~/.config/systemd/user
    ```

Create the `xhost.service` unit file into the `~/.config/systemd/user` directory.

```ini title="~/.config/systemd/user/xhost.service"
[Unit]
Description=Allow ovos_gui container to use X from user session

[Service]
Type=oneshot
Environment="DISPLAY=:0"
ExecStart=/usr/bin/xhost +local:ovos_gui
ExecStop=/usr/bin/xhost -local:ovos_gui
RemainAfterExit=yes
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=default.target
```

Enable and start the new `xhost.service` systemd service.

=== "Raspberry Pi"

    ```shell
    systemctl --user enable xhost.service
    systemctl --user start xhost.service
    ```

=== "Linux"

    ```shell
    systemctl --user enable xhost.service
    systemctl --user start xhost.service
    ```

The `xhost` command is part of the `x11-xserver-utils` package on Debian based distributions such as Raspberry Pi OS.

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
