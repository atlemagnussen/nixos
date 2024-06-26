{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    gcc
    cmake
    python311Full
    python311Packages.pynvim
    omnisharp-roslyn
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        function! SourceIfExists(file)
          if filereadable(expand(a:file))
            exe 'source' a:file
          endif
        endfunction
        call SourceIfExists("~/.config/nvim/init.lua")
      '';
    };
  };
}
