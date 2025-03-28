# media

## podman manually

```sh
podman run --name myjellyfin \
 --publish 8096:8096/tcp \
 --user $(id -u):$(id -g) \
 --userns keep-id \
 --volume media-cache-volume:/cache:Z \
 --volume media-config-volume:/config:Z \
 --volume media-data-volume:/media:Z \
 docker.io/jellyfin/jellyfin:latest

```

or
--mount type=bind,source=/path/to/media,destination=/media,ro=true,relabel=private \