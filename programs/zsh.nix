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
	# Zinit home var
	ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"

	# Install zinit if not installed
	if [ ! -d "$ZINIT_HOME" ]; then
		mkdir -p "$(dirname $ZINIT_HOME)"
		git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
	fi

	# load zinit
	source "''${ZINIT_HOME}/zinit.zsh"


	eval "$(${lib.getExe self'.packages.starship} init zsh)"
        '';
    };
  };
}
