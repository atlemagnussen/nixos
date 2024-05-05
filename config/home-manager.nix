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

      file = {
        syncMediaFiles = {
          executable = true;
          target = "bin/syncMediaFiles";
          text = ''
            #!${pkgs.bash}/bin/bash
            set -e
            echo "Sync books"
            rsync -vrcz -e 'ssh -p 2258' --progress atle@atle.guru:/mnt/md1/Media/Books /mnt/md1/Media
          '';
        };
      };

      stateVersion = "23.11";
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