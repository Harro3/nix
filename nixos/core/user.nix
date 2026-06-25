{
  flake.nixosModules.core = { lib, ... }: {
    options.preferences = {
      user.name = lib.mkOption {
        type = lib.types.str;
        default = "harro";
      };
    };
  };
}
