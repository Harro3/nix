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
      imports = [
        self.nixosModules.bluetooth
        self.nixosModules.pipewire
        self.nixosModules.wayland
      ];
      config = {
        programs.niri.enable = true;
        programs.niri.package = selfpkgs.niri;

        environment.systemPackages = [
          selfpkgs.kitty
        ];
      };
    };
}
