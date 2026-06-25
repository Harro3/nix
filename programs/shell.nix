{
  self,
  inputs,
  lib,
  ...
}:
{
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    let selfpkgs = self'.packages;
    in
    {
      packages.shell = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;

        package = pkgs.zsh;

        runtimeInputs = [
          pkgs.git

          selfpkgs.nh
        ];

        env = {
          EDITOR = null;
        };
      };
    };
}
