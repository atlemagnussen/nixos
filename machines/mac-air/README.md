# NIX MacOS

Install

```sh
sh <(curl -L https://nixos.org/nix/install)
```

Test Nix

```sh
nix-shell -p neofetch --run neofetch
```


```sh
mkdir nix
cd nix
nix flake init -t nix-darwin --extra-experimental-features "nix-command flakes"
```

to activate from home folder

```sh
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/nix#mac-air
```

to update

```sh
darwin-rebuild switch --flake ~/nix#mac-air
darwin-rebuild build --flake ~/nix#mac-air
```

# make hard links
ln ~/dev/nixos/machines/mac-air/flake.nix ~/nix/flake.nix