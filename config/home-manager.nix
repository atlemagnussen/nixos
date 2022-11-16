{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

#   programs = {
#     home-manager.enable = true;
#   };

  home-manager.users.atle = { pkgs, ... }: {
    home.packages = [ pkgs.fortune ];
    programs.bash.enable = true;
  };
}