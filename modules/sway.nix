{ config, pkgs, ... }:
{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      alacritty  
      dmenu
    ];
  };

  environment = {
    etc = {
      "sway/config".source = ./dotfiles/sway/config;
    };
  };
}
