let
  wallpapers = {
    black-hole = ./black-hole.png;
    catppuccin-mocha-logo-nix = ./catppuccin-mocha-logo-nix.png;
    fuji = ./fuji.jpeg;
    mountains = ./mountains.jpg;
  };

  current = wallpapers.mountains;
in
{
  flake.lib.wallpaper = wallpapers // {
    inherit current;
  };

  perSystem = { pkgs, ... }: {
    packages.wallpaperDir = pkgs.runCommand "wallpaper-dir" { } ''
      mkdir -p $out
      ${builtins.concatStringsSep "\n" (
        builtins.map (
          name:
          let
            path = wallpapers.${name};
          in
          "ln -s ${path} $out/${builtins.baseNameOf (toString path)}"
        ) (builtins.attrNames wallpapers)
      )}
    '';
  };
}
