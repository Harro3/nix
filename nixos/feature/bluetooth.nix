{inputs, self, ...}: {
  flake.nixosModules.bluetooth = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
      bluez
      blueman
    ];
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    systemd.services.unblock-bluetooth = {
      description = "Unblock bluetooth via rfkill";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
        type = "oneshot";
      };
    };

    systemd.services.unblock-bluetooth.enable = true;
    boot.kernelParams = ["bluetooth.enable=1"];
  };
}
