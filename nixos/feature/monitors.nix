{ ... }: {
  flake.nixosModules.monitors =
    { pkgs, config, ... }:
    {
      environment.systemPackages = [ pkgs.nwg-displays ];

      # nwg-displays requires this directory to exist when running under niri
      systemd.tmpfiles.rules = [
        "d /home/${config.preferences.user.name}/.config/niri 0755 ${config.preferences.user.name} users -"
      ];

      systemd.user.services.kanshi = {
        description = "Kanshi dynamic display configuration";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.kanshi}/bin/kanshi";
          Restart = "on-failure";
        };
      };
    };
}
