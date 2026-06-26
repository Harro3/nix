{ self, ... }: {
  flake.nixosModules.shell =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      users.users.${config.preferences.user.name}.shell =
        self.packages.${pkgs.stdenv.hostPlatform.system}.shell;
    };
}
