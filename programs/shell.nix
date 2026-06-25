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
    {
      packages.shell = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;

        package = pkgs.zsh;

        runtimeInputs = [

        ];

        env = {
          EDITOR = null;
        };
      };
    };
}
