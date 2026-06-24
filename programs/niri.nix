{self, inputs, ...}: {
  perSystem = {pkgs, lib, system, ...}: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;

      settings = {
        input.keyboard = {
          xkb.layout = "us";
        };

        layout.gaps = 5;

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+Q".close-window = _: {};
        };
      };
    };
  };
}