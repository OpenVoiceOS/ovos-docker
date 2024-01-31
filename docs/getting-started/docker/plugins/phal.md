# PHAL plugins

The [Plugin based Hardware Abstraction Layer](../../../about/glossary/components.md#ovos-phal) plugins allow you to interact with system components such as [Wi-Fi](https://en.wikipedia.org/wiki/Wi-Fi), [GPIO](https://en.wikipedia.org/wiki/General-purpose_input/output), [NetworkManager](https://en.wikipedia.org/wiki/NetworkManager), etc... but not only.

!!! note

    The PHAL plugins are handled by the `ovos_phal` and `ovos_phal_admin` containers.

!!! danger "`ovos_phal_admin` is a privileged container"

    The `ovos_phal_admin` purpose is to run plugins that require accesses to some devices, files or services.

    Plugins installed in this container have to be enabled into `~/ovos/config/mycroft.conf` in order to get loaded, this acts as an extra layer of security.

The `ovos_phal` container comes with few pre-installed PHAL plugins such as:

- `ovos-PHAL-plugin-alsa` controls system volume with [ALSA](https://en.wikipedia.org/wiki/Advanced_Linux_Sound_Architecture)
- `ovos-PHAL-plugin-ipgeo` provides geolocation information via the message bus
- `ovos-PHAL-plugin-system` handles bus events to interact with the operating system

If the existing PHAL plugins are not enough then you can install yours by following the same principle as for the [STT plugins](./stt.md) by adding a `phal.list` or `phal_admin.list` files within the `~/ovos/config/` directory, this file acts as a Python `requirements.txt` file.

!!! warning "Plugins requirements"

    These plugins have to be compatible with the `pip install` method which requires a `setup.py` file.

When the `ovos_phal` or `ovos_phal_admin` containers start, they will look for these files and install the skpluginsills defined in there.

```ini title="~/ovos/config/phal.list or ~/ovos/config/phal_admin.list"
ovos-phal-plugin-ipgeo==0.0.1 # Specific plugin version on PyPi
ovos-PHAL-plugin-pulse # Latest plugin version on PyPi
git+https://github.com/OpenVoiceOS/ovos-PHAL-plugin-homeassistant.git@fix/whatever # Specific branch of a plugin on GitHub
```

The `ovos_phal` or `ovos_phal_admin` containers must be restarted if a change occurs in the `phal.list` or `phal_admin.lis` files.

=== "Docker"

    ```shell
    docker restart ovos_phal ovos_phal_admin
    ```

=== "Podman"

    ```shell
    podman restart ovos_phal ovos_phal_admin
    ```
