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
        style = "#5f87ff"; #2b51ab color picker #5f87ff termincal color 69  #6495ed cornflower bluy according to web
      };
      username = {
        style_user = "#c41e3a"; #e74856
        style_root = "red";
      };
    };
  };
  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
    screen
    silver-searcher
    fzf
    ripgrep
    bat
    fd
    monero-cli
    tmux
    ncdu
    mongosh
    bridge-utils
    smartmontools
    parted
    lm_sensors
  ];
}