{ pkgs, ... }: {
  plugins.vimtex = {
    enable = true;
    settings = {
      view_method = "zathura_simple";
    };
    texlivePackage = pkgs.texliveFull;
  };

  plugins.lsp.servers.texlab.enable = true;
}
