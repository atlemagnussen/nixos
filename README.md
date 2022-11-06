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

