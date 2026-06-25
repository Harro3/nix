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
      modules = [(inputs.import-tree ./_config)];
    };
    in
    {
      checks.default = configuration.config.build.test;
      packages.nixvim = configuration.config.build.package;
    };
}
