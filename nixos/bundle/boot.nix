{ self, ... }: {
  flake.nixosModules.boot = { ... }: {
    imports = [
      self.nixosModules.grub
      self.nixosModules.greetd
    ];
  };
}
