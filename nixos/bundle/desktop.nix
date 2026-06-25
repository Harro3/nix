{ self, ... }: {
  flake.nixosModules.desktop =
    {
      pkgs,
      config,
      ...
    }:
    let
      selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      programs.niri.enable = true;
      programs.niri.package = selfpkgs.niri;

      environment.systemPackages = [
        selfpkgs.kitty
      ];
    };
}
