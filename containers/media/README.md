# media

use root version as it is easier to map to own user

podman kube play media-root.yaml 

## podman manually

```sh
podman run --name myjellyfin \
 --publish 8096:8096/tcp \
 --user $(id -u):$(id -g) \
 --userns keep-id \
 --volume media-config-jellyfin-volume:/config:Z \
 --volume media-cache-volume:/cache:z \
 --volume media-data-volume:/media:z \
 docker.io/jellyfin/jellyfin:latest

```

or
--mount type=bind,source=/path/to/media,destination=/media,ro=true,relabel=private \