# The generated file lives in _generated/ because importTree skips underscore
# directories -- raw nixos-generate-config output is a NixOS module, not a
# flake-parts one, so it cannot be picked up directly.
{
  flake.nixosModules.hostMODULE = import ./_generated/hardware-configuration.nix;
}
