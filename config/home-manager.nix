{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

#   programs = {
#     home-manager.enable = true;
#   };
# home-manager.users.atle.home.stateVersion'
  home-manager.users.atle = { pkgs, ... }: {
    home = {
      packages = with pkgs; [
        fortune
        zip
        unzip
      ];
      
      sessionVariables = {
        NPM_PACKAGES = "$HOME/.npm-packages";
        PATH = "$PATH:$HOME/bin:$NPM_PACKAGES/bin";
      };

      stateVersion = "23.05";
    };
    programs.bash = {
      enable = true;
      initExtra = ''
          npm set prefix $NPM_PACKAGES
        '';
    };

    programs.git = {
      enable = true;
      userName  = "Atle Magnussen";
      userEmail = "atlemagnussen@gmail.com";
    };
  };
}