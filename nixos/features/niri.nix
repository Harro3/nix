{self, inputs, ...}: {
  flake.nixosModules.niri = { pkgs, lib, ...}: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.system}.niri;
    };
  };

}