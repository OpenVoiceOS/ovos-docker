# Welcome!

OVOS Docker is one of the fastest ways to get started with OVOS.

## Quickstart

A nice, simple and intuitive way to install Open Voice OS and/or HiveMind using Bash, Whiptail (Newt) and Ansible.

`curl`, `git` and `sudo` packages must be installed before running the installer.

```shell
sh -c "curl -s https://raw.githubusercontent.com/OpenVoiceOS/ovos-installer/main/installer.sh -o installer.sh && chmod +x installer.sh && sudo ./installer.sh"
```

Then follow the instructions display on screen.

### Automated install

The installer supports a non-interactive *(automated)* process of installation by using a scenario file, this file must be created under the `~/.config/ovos-installer/` directory and should be named `scenario.yaml`.

Here is an example of a scenario to install Open Voice OS within Docker containers on a Raspberry Pi 4B with default skills and GUI support.

```shell
mkdir -p ~/.config/ovos-installer
cat <<EOF > ~/.config/ovos-installer/scenario.yaml
---
uninstall: false
method: containers
channel: development
profile: ovos
features:
  skills: true
  gui: true
rapsberry_pi_tuning: true
share_telemetry: true
EOF
```

## Getting started

Want to give Open Voice OS a try? Open Voice OS is an open source software that runs where you want it to, whether it’s on your [own hardware](./about/why-use-ovos.md#multi-device-compatibility) or one of the dedicated [Mark 1](https://mycroft.ai/product/mycroft-mark-1/) or [Mark II](https://mycroft.ai/product/mark-ii/).

<div class="grid cards" markdown>

- :material-docker:{ .xl .middle } __Docker__

    `arm64` :material-check-circle-outline:{ style="color: green" } `x86_64` :material-check-circle-outline:{ style="color: green" }

    Use container engine such as [Docker](https://www.docker.com/) or [Podman](https://podman.io/) and their `composer` to run a ^^complete^^, ^^secure^^, ^^isolated^^ and ^^"easy to update"^^ instance of Open Voice OS!

    [:octicons-arrow-right-24: Getting started with Docker](./getting-started/docker/index.md)

</div>
