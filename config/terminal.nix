{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      # add_newline = false;

      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };

      # package.disabled = true;

      hostname = {
        ssh_only = false;
        style = "blue";
      };
      username = {
        style = "#c41e3a";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
  ];
}