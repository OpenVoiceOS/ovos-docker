# Update Open Voice OS

!!! warning "Exact same command"

    In order to update the deployed stack *(services and volumes)*, you *must* use the exact same command that has been used during the initial stack deployment.

The easiest and quickest way to update an Open Voice OS stack already deployed by `docker compose` or `podman-compose` is, of course, to use `docker compose` or `podman-compose` as well. :relaxed: :muscle:

!!! note "Podman users :muscle:"

    If you are running Podman instead of Docker, replace `docker compose` with `podman-compose`.

!!! note "Compose file names"

    The file names below are examples. Use the compose files provided by your
    installer or your own bundle names. If you cloned `ovos-docker`, the bundles
    live under `compose/`.

=== "Raspberry Pi"

    ```shell
    docker compose --project-name ovos --file docker-compose.yml --file docker-compose.raspberrypi.yml --file docker-compose.skills.yml up --detach
    ```

=== "Linux"

    ```shell
    docker compose --project-name ovos --file docker-compose.yml --file docker-compose.skills.yml up --detach
    ```

=== "Mac OS"

    ```shell
    docker compose --project-name ovos --file docker-compose.macos.yml --file docker-compose.skills.yml --env-file .env up --detach
    ```

=== "Windows WSL2"

    ```shell
    docker compose --project-name ovos --file docker-compose.windows.yml --file docker-compose.skills.yml  up --detach
    ```

Because the `pull_policy` option of each service is set to `always`, every time that a new image is uploaded with the same tag `docker compose` or `podman-compose` will pull it and re-create the container based on this new image.

!!! tip "Change the version"

    If you want to change the image tag to deploy, update the [.env](./composition.md#environment-files) file with the right one. Channel [tags](./images.md#tags) are rebuilt automatically: when a commit lands on the `dev` branch of `ovos-docker`, when the channel's constraints in [ovos-releases](https://github.com/OpenVoiceOS/ovos-releases) change (checked hourly), and once a week regardless.

!!! tip "Registry pull budget"

    Every `up` with `pull_policy: always` asks the registry about each image; with a full stack that is about 35 requests, and Docker Hub allows 100 per hour for anonymous users. If you update several times in a row, `docker login` first or set `PULL_POLICY=missing` in `.env` and run `docker compose pull` explicitly when you want an update.
