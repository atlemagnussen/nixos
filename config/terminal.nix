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
        style = "#2b51ab"; #6495ed cornflower bluye
      };
      username = {
        style_user = "#c41e3a"; #e74856
        style_root = "red";
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