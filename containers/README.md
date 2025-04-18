# Set up sonarr and BitTorrent downloader

https://wiki.servarr.com/docker-guide

https://hotio.dev/containers/sonarr/

```sh
less /etc/passwd
useradd -m -g media media
useradd -m -g media sonarr
useradd -m -g media readarr
useradd -m -g media torrents
useradd -m -g media usenet
```

```sh
docker compose pull
docker compose up -d
```

use podman kube play instead of docker-compose

works
docker run --rm -it --device=nvidia.com/gpu=all ubuntu:latest nvidia-smi

sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable


nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz -p docker-compose

nix-shell -I nixpkgs=channel:nixpkgs-unstable -p docker-compose


https://certbot.eff.org/instructions?ws=nginx&os=pip&commit=%3E


sudo certbot certonly --manual --preferred-challenges dns

sudo openssl x509 -in /etc/letsencrypt/live/atle.guru/fullchain.pem


podman network create --ipv6 --subnet fda9:9699:faa:cda6::/64 podman_ipv6

fd00::/80 podman_ipv6


fda9:9699:faa:cda6::21