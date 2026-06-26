{
  lib,
  config,
  pkgs,
  ...
}: {
      plugins.vimtex = {
        enable = true;
        settings = {
          view_method = "zathura_simple";
        };
        texlivePackage = pkgs.texlive.combined.scheme-full;
      };

      plugins.lsp.servers.texlab.enable = true;
    }
