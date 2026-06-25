{ ... }:
let
  wallpapers = rec {
    black-hole = ./black-hole.png;
    catppuccin-mocha-logo-nix = ./catppuccin-mocha-logo-nix.png;
    fuji = ./fuji.jpeg;
    mountains = ./mountains.jpg;

    current = mountains;
  };
in
{
  flake.lib.wallpaper = wallpapers;

  perSystem = { pkgs, ... }: {
    packages.wallpaperDir = pkgs.runCommand "wallpaper-dir" { } ''
      mkdir -p $out
      ${builtins.concatStringsSep "\n" (
        builtins.map (name: "ln -s ${wallpapers.${name}} $out/${name}") (builtins.attrNames wallpapers)
      )}
    '';
  };
}
