{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    hostmodules.greetd.enable = lib.mkEnableOption "Greetd";
  };

  config = lib.mkIf config.hostmodules.greetd.enable {
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = ''${pkgs.tuigreet}/bin/tuigreet --remember --remember-session --asterisks --time'';
          user = "harro";
        };
        default_session = initial_session;
      };
    };
  };
}
