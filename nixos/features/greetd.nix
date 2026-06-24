{ self, ... }: {
  flake.nixosModules.greetd =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      services.greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --remember --remember-session --asterisks --time";
            user = config.preferences.user.name;
          };
          default_session = initial_session;
        };
      };
    };
}
