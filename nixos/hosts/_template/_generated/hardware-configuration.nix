# Placeholder. `install-host` overwrites this with the output of
# `nixos-generate-config --root /mnt`, detected from the disk you mounted.
{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
