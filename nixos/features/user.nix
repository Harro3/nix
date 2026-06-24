{ self, ... }: {
  flake.nixosModules.user =
    {
      pkgs,
      config,
      ...
    }:
    {
      users.users.${config.preferences.user.name} = {
        isNormalUser = true;
        description = "${config.preferences.user.name}'s account";
        extraGroups = [
          "wheel"
          "networkmanager"
        ];

        password = "password";
      };
    };
}
