{ config, pkgs, ... }:
{
  imports = [ /home/atle/nixos-config/machines/atle-laptop ];
  system.stateVersion = "21.05";
}
