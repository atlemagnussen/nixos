{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  home-manager.users.atle = { pkgs, ... }: {
    home.packages = [ pkgs.fortune  pkgs.httpie ];
    programs.bash.enable = true;
    };
}