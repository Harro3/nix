{
  inputs,
  self,
  pkgs,
  ...
}:
{
  perSystem =
    {
      pkgs,
      lib,
      system,
      self',
      ...
    }:
    let configuration = inputs.nixvim.lib.evalNixvim {
      system = pkgs.stdenv.hostPlatform.system;
      modules = [./config];
    };
    in
    {
      packages.nixvim = configuration.config.build.package;
    };
}