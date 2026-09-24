# A live ISO built from this flake, carrying the config and the (encrypted)
# secrets tree. Booting it replaces the whole "install NixOS, add channels, edit
# /etc/nixos, make a throwaway GitHub key, clone the repos" preamble: partition,
# mount, run `install-host <name>`.
#
#   nix build .#installer-iso
#   sudo dd if=result/iso/*.iso of=/dev/sdX bs=4M status=progress conv=fsync
{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.installer =
    {
      pkgs,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
      ];

      # The two things that would otherwise need a GitHub key. `secrets` is
      # sops-encrypted ciphertext; the private age key is never on the ISO, it
      # is pasted in at install time.
      environment.etc."nix-config".source = self;
      environment.etc."nix-secrets".source = inputs.secrets;

      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.install-host
        pkgs.git
        pkgs.vim

        # Partitioning tools the setup guide's recipes use.
        pkgs.cryptsetup
        pkgs.dosfstools
        pkgs.e2fsprogs
        pkgs.gptfdisk
        pkgs.parted
      ];

      # The installer profile enables ZFS, whose module warns that
      # `forceImportRoot` still defaults to true. `false` is the 26.11 default
      # and is the correct value here regardless: this ISO boots from squashfs
      # and never imports a root pool.
      boot.zfs.forceImportRoot = false;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Lets you drive the install from another machine instead of typing on the
      # new laptop's console.
      services.openssh.enable = true;
      users.users.root.openssh.authorizedKeys.keyFiles = [
        ../feature/secrets/id_ed25519.pub
      ];

      networking.networkmanager.enable = true;
      networking.wireless.enable = lib.mkForce false;

      # xz costs minutes of build time for an image that gets written to a USB
      # stick and thrown away.
      isoImage.squashfsCompression = "zstd -Xcompression-level 6";
    };

  perSystem = { system, ... }: {
    packages.installer-iso =
      (inputs.nixpkgs.lib.nixosSystem {
        modules = [
          self.nixosModules.installer
          { nixpkgs.hostPlatform = system; }
        ];
      }).config.system.build.isoImage;
  };
}
