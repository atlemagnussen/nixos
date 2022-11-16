{ config, pkgs, ... }:
let
  keys = import ../misc/sshkeys.nix;
in
{
    time.timeZone = "Europe/Oslo";
    nixpkgs.config = {
      allowUnfree = true;
    };
    users.users.atle = {
      isNormalUser = true;
      home = "/home/atle";
      description = "Atle";
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = keys.trustedKeys;
    };
}
