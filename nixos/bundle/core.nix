{ self, ... }: {
  flake.nixosModules.core =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [self.nixosModules.user];
    };
}