{ self, config, ... }: {
  flake.nixosModules.user =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      options.preferences = {
        user.name = lib.mkOption {
          type = lib.types.str;
          default = "harro";
        };
      };

      config = {
        users.users.${config.preferences.user.name} = {
          isNormalUser = true;
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
	};
      };
    };
}
