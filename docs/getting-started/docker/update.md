# Update Open Voice OS

!!! warning "Exact same command"

    In order to update the deployed stack, you *must* use the exact same command that has been used during the initial stack deployment.

The easiest and quickest way to update an Open Voice OS stack already deployed by `docker compose` or `podman-compose` is; of course to use `docker compose` or `podman-compose`. :relaxed: :muscle:

!!! note "Podman users :muscle:"

    If you are running Podman instead of Docker, replace `docker compose` with `podmand-compose`.

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

Because the `pull_policy` option of each service is set to `always`, everytime that a new image is uploaded with the same tag then `docker compose` or `podman-compose` will pull-it and re-create the container based on this new image.

!!! tip "Change the version"

    If you want to change the image's tag to deploy, update the [.env](./composition.md#environment-files) file with the right one. The `alpha` [tag](./images.md#tags) images are rebuilt every nights with the latest commits from the `dev` branch.
