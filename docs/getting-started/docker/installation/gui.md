# Install the Open Voice OS GUI

!!! danger "The GUI images are no longer built"

    The `ovos-gui-shell` and `ovos-gui-original` images are no longer built or
    supported. The last published tags remain on the registries but receive no
    updates. This page stays for reference only.

!!! warning "For Linux eyes only"

    The GUI is currently available only on Linux operating system, not on Mac OS or Windows.

The Open Voice OS GUI supports two types of system execution:

- Using [X](https://en.wikipedia.org/wiki/X_Window_System) or [Wayland](<https://en.wikipedia.org/wiki/Wayland_(protocol)>) display servers
- Using [EGLFS](https://doc.qt.io/qt-6/embedded-linux.html#eglfs) which doesn't require any display server, which is perfect for headless installation

Open Voice OS ships two GUI images: `ovos-gui-shell` and `ovos-gui-original`. Pick
the one you want in your compose files.

When using EGLFS, the `DISPLAY` variable from the `.env` [composition environment file](../composition.md#environment-files) must be removed or commented. If present, the X or Wayland display servers will be tried first and the GUI container will error.

!!! question "Hardware accelerated on Raspberry Pi 4 and 5"

    Raspberry Pi 4 and 5 will leverage the GPU hardware acceleration which will provide a smoother experience.

    **If not running on a Raspberry Pi 4 or 5 then the CPU might be used to render the GUI which will result in a high CPU consumption and a poor user experience.**

## EGLFS on Raspberry Pi 5

The Raspberry Pi 5 board doesn't use `/dev/dri/card0` by default anymore for the GPU rendering. The solution to this issue is to create an EGLFS configuration referencing the right card to use.

```json title="~/ovos/config/ovos-eglfs.json"
{
  "device": "/dev/dri/card1",
  "hwcursor": false
}
```

The `QT_QPA_EGLFS_INTEGRATION` variable must be set to `eglfs_kms` and `QT_QPA_EGLFS_KMS_CONFIG` variable must be set to `/home/$OVOS_USER/.config/mycroft/ovos-eglfs.json` in the `.env` file.

Please check the [composition environment file](../composition.md#environment-files) section for more details.

## Configuration

The `ovos-gui-websocket` component must be configured in order to receive the QML files from the skill containers. Because of these file transfers, the `ovos-messagebus` component must be configured to allow bigger payload.

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
    "gui_file_host_path": "/home/ovos/.cache/ovos_gui_file_server"
  },
  "websocket": {
    "max_msg_size": 100
  }
}
```

## xhost and display servers

!!! tip

    You can skip this section if you are using EGLFS and go to [GUI services deployment](#gui-services-deployment).

In order to allow only the GUI container to access the X or Wayland display server, you will have to allow the container _(based on its hostname)_ to connect to the display session.

```bash
export DISPLAY=":0"
xhost +local:ovos_gui
```

Replace `ovos_gui` with your GUI container name if it differs.

This command is not permanent; when your operating system reboots you will have to run the command again. To make it permanent systemd should be leveraged as a user service.

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

    If you are running Podman instead of Docker, replace `docker compose` with `podman-compose`.

!!! note "Compose file names"

    The file names below are examples. Use the compose files provided by your
    installer or your own bundle names. If you cloned `ovos-docker`, the bundles
    live under `compose/`.

=== "Raspberry Pi"

    ```shell
    docker compose --project-name ovos --file docker-compose.yml --file docker-compose.raspberrypi.yml --file docker-compose.skills.yml --file docker-compose.gui.yml --file docker-compose.raspberrypi.gui.yml up --detach
    ```

=== "Linux"

    ```shell
    docker compose --project-name ovos --file docker-compose.yml --file docker-compose.skills.yml --file docker-compose.gui.yml up --detach
    ```
