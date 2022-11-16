{ config, pkgs, lib, l, vars, ... }:
{
 
  programs = {
    ssh = {
      enable = true;
    };
    home-manager.enable = true;
  };
  home = {
    stateVersion = "22.05";
    username = "atle";
    homeDirectory = "/home/atle";
    sessionVariables = {
      NPM_PACKAGES = "$HOME/.npm-packages";
    };
    programs = {
      bash = {
        enable = true;
        initExtra = ''
          npm set prefix $HOME/.npm-packages
        '';
      };
    };
  };
}