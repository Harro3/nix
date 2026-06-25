{
  inputs,
  self,
  lib,
  ...
}: {
  perSystem = {pkgs, self', ...}: {
    packages.zsh = inputs.wrapper-modules.wrappers.zsh.wrap {
      inherit pkgs;

      zshrc.content = ''
          eval "$(${lib.getExe pkgs.starship} init zsh)"
        '';
    };
  };
}