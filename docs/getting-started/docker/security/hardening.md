# Basic OVOS hardening

In order to secure your Open Voice OS instance, a few more steps are **required** and a few concepts must be understood.

## Container settings

The compose bundles already apply the container-level hardening that is safe
for every deployment:

| Setting                                  | Applies to                                                                                     | Effect                                                              |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| `init: true`                             | all services                                                                                   | a minimal PID 1 reaps child processes and forwards signals          |
| `cap_drop: [ALL]`                        | `ovos_messagebus`, `ovos_core`, `ovos_cli`, `ovos_gui_websocket`, every skill, HiveMind services | no Linux capability at all: these only talk to the message bus       |
| `security_opt: no-new-privileges:true`   | same services                                                                                  | no privilege escalation through setuid binaries                     |
| non-root user (`ovos`, UID 1000)         | all images except `ovos_phal_admin`                                                            | processes never run as root                                         |

`ovos_phal` and `ovos_phal_admin` (hardware access) and `ovos_listener`,
`ovos_audio` and `ovos_plugin_ggwave` (sound devices) keep the device access
they need.

## AppArmor

AppArmor and SELinux are examples of [Mandatory Access Control](https://en.wikipedia.org/wiki/Mandatory_access_control) _(MAC)_ systems. These systems differ from other security controls which are generally called [Discretionary Access Control](https://en.wikipedia.org/wiki/Discretionary_access_control) _(DAC)_ systems in that, generally, the user can't change their operation.

!!! note "AppArmor packages"

    AppArmor must be installed on your system before going further. Please refer to your Linux distribution documentation to install it.

### Enable AppArmor

=== "Raspberry Pi OS"

    ```shell title="/boot/cmdline.txt"
    apparmor=1 security=apparmor
    ```

=== "Debian & Ubuntu"

    ```shell title="/etc/default/grub.d/apparmor.cfg"
    apparmor=1 security=apparmor
    ```

The system must be rebooted to instruct the kernel to load AppArmor during the boot sequence. Once rebooted, check the AppArmor status using the `aa-status` command.

=== "Raspberry Pi OS"

    ```shell
    sudo aa-status

    ```

=== "Debian & Ubuntu"

    ```shell
    sudo aa-status
    ```

### AppArmor Docker profile

!!! warning "AppArmor and Podman support[^1]"

    AppArmor support for Podman is not yet fully functional.

Docker applies the `docker-default` AppArmor profile to new containers. In Docker 1.13 and later this profile is created in `tmpfs` and then loaded into the kernel.

The container engine should now be aware of `apparmor` as an available security option.

```shell
docker system info | grep -i apparmor
```

All the containers except `ovos_phal_admin` should now be confined with the `docker-default` AppArmor profile.

```shell
docker container list --quiet --all --filter "name=ovos" | xargs docker inspect --format "{{ .Name }}: AppArmorProfile={{ .AppArmorProfile }}"
/ovos_skill_wikipedia: AppArmorProfile=docker-default
/ovos_skill_weather: AppArmorProfile=docker-default
/ovos_skill_volume: AppArmorProfile=docker-default
/ovos_skill_date_time: AppArmorProfile=docker-default
/ovos_skill_personal: AppArmorProfile=docker-default
/ovos_skill_fallback_unknown: AppArmorProfile=docker-default
/ovos_skill_hello_world: AppArmorProfile=docker-default
/ovos_skill_alerts: AppArmorProfile=docker-default
/ovos_skill_ggwave: AppArmorProfile=docker-default
/ovos_skill_duckduckgo: AppArmorProfile=docker-default
/ovos_skill_wordnet: AppArmorProfile=docker-default
/ovos_listener: AppArmorProfile=docker-default
/ovos_audio: AppArmorProfile=docker-default
/ovos_core: AppArmorProfile=docker-default
/ovos_phal: AppArmorProfile=docker-default
/ovos_phal_admin: AppArmorProfile=unconfined
/ovos_messagebus: AppArmorProfile=docker-default
/ovos_cli: AppArmorProfile=docker-default
/ovos_plugin_ggwave: AppArmorProfile=docker-default
```

!!! note "`ovos_phal_admin` container is not confined"

    The `ovos_phal_admin` container is not confined as it runs as a `privileged` container.

## Message bus

By default, the message bus is listening on address `0.0.0.0` and port `8181` because the `ovos_messagebus` is created using the `--network host` option. This could be a security issue as an external device could connect to the message bus and send and/or read messages.

!!! info "Why using `--network host`?"

    Some Open Voice OS skills such as [Home Assistant](https://www.home-assistant.io/) or [Sonos](https://www.sonos.com/) require access to your private network in order to communicate with your [IoT](https://en.wikipedia.org/wiki/Internet_of_things) devices.

To prevent potential security issues, it is recommended to use a firewall on port `8181`.

`iptables` will be demonstrated as an example but if `firewalld` or `ufw` services are used, then make sure to be compliant with your distribution.

=== "Linux"

    ```shell
    sudo iptables -A INPUT -p tcp -s localhost --dport 8181 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 8181 -j DROP
    ```

This will allow connections to port `8181` **only** from localhost _(internal)_.

!!! warning "Keep your ports closed"

    Keep in mind to firewall any other ports which should not be exposed outside of the host by using the same [IPTables](https://en.wikipedia.org/wiki/Iptables) method.

If you really need to connect an external application to the message bus, we recommend to use [HiveMind](../../../about/glossary/terms.md#hivemind) to ensure a proper security exposure.

[^1]: [Enable rootless AppArmor for Podman](https://github.com/containers/podman/pull/19303)
