{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    gcc
    cmake
    python39Full
    python39Packages.pynvim
    vimPlugins.vim-packer
    nodePackages.typescript-language-server
    omnisharp-roslyn
    #pkgs.sumneko-lua-language-server
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
        call SourceIfExists("~/.config/nvim/init.vim")
      '';
    };
  };
}
