# nixos

configuration

## install on new machine

run command line installer and follow the [guide](https://nixos.org/manual/nixos/stable/index.html#sec-installation)

run `nixos-generate-config` and use the generated files as baseline

set `services.openssh.enable = true;` in `configuration.nix`

then install

add a user with password

add the user to group wheel
then you can go from SSH on another machine

## home-manager

See [documentation](https://nix-community.github.io/home-manager/index.html#idm140737328806976)

Must add channel and so on ...

## build

```sh
# just compile
nixos-rebuild build
# build and switch, then work after reboot
nixos-rebuild boot
# build and switch immediately
nixos-rebuild switch

```

[UpgradeLog](./UPGRADE-log.md)

## dist-upgrade
```sh
sudo nix-channel --list

sudo nix-channel --remove nixos
sudo nix-channel --add https://nixos.org/channels/nixos-24.11 nixos

sudo nix-channel --remove home-manager
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager

sudo nix-channel --update

sudo vim /etc/nixos/configuration.nix # set to latest version
sudo vim machines/atle-station/default.nix # set to latest version

nixos-rebuild boot

```
