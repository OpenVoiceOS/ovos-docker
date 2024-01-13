# Welcome

`ovos-docker` is one of the fastest ways to get started with Open Voice OS.

## Quickstart

A nice, simple and intuitive way to install Open Voice OS and/or HiveMind using Bash, Whiptail (Newt) and Ansible.

`curl`, `git` and `sudo` packages must be installed before running the installer.

```shell
sh -c "curl -s https://raw.githubusercontent.com/OpenVoiceOS/ovos-installer/main/installer.sh -o installer.sh && chmod +x installer.sh && sudo ./installer.sh && rm installer.sh"
```

Then follow the instructions displayed on screen then you will be all set :thumbsup: !

## Getting started

Want to give Open Voice OS a try? Open Voice OS is an open source software that runs where you want it to, whether it’s on your [own hardware](./about/why-use-ovos.md#multi-device-compatibility) or one of the dedicated [Mark 1](https://mycroft.ai/product/mycroft-mark-1/) or [Mark II](https://mycroft.ai/product/mark-ii/).

<div class="grid cards" markdown>

-   :material-docker:{ .xl .middle } **Docker**

    ---
  
    `arm64` :material-check-circle-outline:{ style="color: green" } `x86_64` :material-check-circle-outline:{ style="color: green" }

    Use container engine such as [Docker](https://www.docker.com/) or [Podman](https://podman.io/) and their `composer` to run a ^^complete^^, ^^secure^^, ^^isolated^^ and ^^"easy to update"^^ instance of Open Voice OS!

    [:octicons-arrow-right-24: Getting started with Docker](./getting-started/docker/index.md)

</div>
