{
  inputs,
  self,
  ...
}:
{
  perSystem = { pkgs, self', ... }: {
    packages.noctalia-shell = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;

      settings =
        let
          base = builtins.fromJSON (builtins.readFile ./noctalia.json);
        in
        base.settings
        // {
          wallpaper = base.settings.wallpaper // {
            directory = self'.packages.wallpaperDir;
          };
        };
    };
  };
}
