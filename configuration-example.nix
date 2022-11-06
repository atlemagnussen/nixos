{ config, pkgs, ... }:
{
  imports = [ /home/atle/nixos-config/machines/atle-laptop ];
  system.stateVersion = "22.05";
}
