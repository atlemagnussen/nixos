{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

#   programs = {
#     home-manager.enable = true;
#   };

  home-manager.users.atle = { pkgs, ... }: {
    home.packages = [ pkgs.fortune ];
    programs.bash = {
      enable = true;
      initExtra = ''
          npm set prefix $HOME/.npm-packages
        '';
    };

    programs.git = {
      enable = true;
      userName  = "Atle Magnussen";
      userEmail = "atlemagnussen@gmail.com";
    };
  };
}