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

from home folder

```sh
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/nix#mac-air
```


```sh
darwin-rebuild switch --flake ~/nix#mac-air
```

ln -s ~/dev/nixos/machines/mac-air ~/nix

system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
        '';

nix-homebrew.darwinModules.nix-homebrew
	      {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
	          user = "atle";
	          autoMigrate = true;
	        };
	      }