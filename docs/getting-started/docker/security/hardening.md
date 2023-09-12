# Basic OVOS hardening

In order to secure your Open Voice OS instance, few more step are **required** and few concepts must be understood.

## AppArmor

AppArmor and SELinux are examples of [Mandatory Access Control](https://en.wikipedia.org/wiki/Mandatory_access_control) *(MAC)* systems. These systems differ from other security controls which are generally called [Discretionary Access Control](https://en.wikipedia.org/wiki/Discretionary_access_control) *(DAC)* systems in that, generally, the user can't change their operation.

### Enable AppArmor

=== "Raspberry Pi OS"

    ```shell title="/boot/cmdline.txt"
    apparmor=1 security=apparmor
    ```

=== "Debian & Ubuntu"

    ```shell title="/etc/default/grub.d/apparmor.cfg"
    apparmor=1 security=apparmor
    ```

System must be rebooted to instruct the kernel to load AppArmor.

=== "Raspberry Pi OS"

    ```shell
    sudo aa-status

    ```

=== "Debian & Ubuntu"

    ```shell
    sudo aa-status
    ```

### AppArmor Docker profile

!!! warning "AppArmor and Podman support"

    AppArmor support for Podman is not yet fully functional[^1].

Docker applies the `docker-default` AppArmor profile to new containers. In Docker 1.13 and later this profile is created in `tmpfs` and then loaded into the kernel.

The container engine should now be aware of `apparmor` as available security option.

```shell
docker system info | grep -i apparmor
```

All the containers except `ovos_phal_admin` should now confined with the `docker-default` AppArmor profile

```shell
docker container list --quiet --all --filter "name=ovos" | xargs docker inspect --format "{{ .Name }}: AppArmorProfile={{ .AppArmorProfile }}"
/ovos_skill_volume: AppArmorProfile=docker-default
/ovos_skill_wikipedia: AppArmorProfile=docker-default
/ovos_skill_fallback_unknown: AppArmorProfile=docker-default
/ovos_skill_alerts: AppArmorProfile=docker-default
/ovos_skill_hello_world: AppArmorProfile=docker-default
/ovos_skill_weather: AppArmorProfile=docker-default
/ovos_skill_stop: AppArmorProfile=docker-default
/ovos_skill_date_time: AppArmorProfile=docker-default
/ovos_skill_personal: AppArmorProfile=docker-default
/ovos_listener: AppArmorProfile=docker-default
/ovos_audio: AppArmorProfile=docker-default
/ovos_core: AppArmorProfile=docker-default
/ovos_phal: AppArmorProfile=docker-default
/ovos_phal_admin: AppArmorProfile=unconfined
/ovos_messagebus: AppArmorProfile=docker-default
/ovos_cli: AppArmorProfile=docker-default
```

!!! note "`ovos_phal_admin` is not confined"

    The `ovos_phal_admin` container is not confined as it runs as a `privileged` container.

## Message bus

By default, the message bus is listening on `0.0.0.0` port `8181` because containers are created using the `--network host` option. This could be a security issue as an external device could connect to the message bus and send and/or read messages.

!!! info "Why using `--network host`?"

    Some Open Voice OS skills such as [Home Assistant](https://www.home-assistant.io/)or  [Sonos](https://www.sonos.com/) require access to your private network in order to communicate with your [IoT](https://en.wikipedia.org/wiki/Internet_of_things).

To prevent potential security issues, it is recommended to use a firewall on port `8181`.

`iptables` will be demonstrated as an example but if `firewalld` or `ufw` services are used, then make sure to be compliant with your distribution.

=== "Linux"

    ```shell
    sudo iptables -A INPUT -p tcp -s localhost --dport 8181 -j ACCEPT
    sudo iptables iptables -A INPUT -p tcp --dport 8181 -j DROP
    ```

This will allow connections to port `8181` **only** from localhost *(internal)*.

!!! warning "Keep your ports closed"

    Keep in mind to firewall any other ports which should not be exposed outside of the host by using the same [IPTables](https://en.wikipedia.org/wiki/Iptables) method.

If you really need to connect an external application to the message bus, we recommend to use [HiveMind](../../../about/glossary/terms.md#hivemind).

[^1]:
    [Enable rootless AppArmor](https://github.com/containers/podman/pull/19303)
