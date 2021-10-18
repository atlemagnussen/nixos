{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #needed for treesitter (needs a c compiler)
    gcc
  ];
  environment.variables.EDITOR = "nvim";
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
  };
}
