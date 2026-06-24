{
  inputs,
  self,
  ...
}:
{
  perSystem = { pkgs, ... }: {
    packages.noctalia-shell = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;

      settings =
        let
          base = builtins.fromJSON (builtins.readFile ./noctalia.json);
          wallpapers = pkgs.runCommand "noctalia-wallpapers" { } ''
            mkdir -p $out
            cp ${self.wallpaper} $out/
          '';
        in
        base.settings
        // {
          wallpaper = base.settings.wallpaper // {
            directory = wallpapers;
          };
        };
    };
  };
}
