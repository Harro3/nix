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

	# Add plugins
	zinit light zsh-users/zsh-syntax-highlighting
	zinit light zsh-users/zsh-autosuggestions
	zinit light zsh-users/zsh-completions
	zinit light Aloxaf/fzf-tab

	# OMZ snippets
	zinit snippet OMZP::git
	zinit snippet OMZP::sudo
	zinit snippet OMZP::archlinux
	zinit snippet OMZP::command-not-found
	zinit snippet OMZP::docker-compose
	zinit snippet OMZP::fancy-ctrl-z

	# Load completions
	autoload -U compinit && compinit
	zinit cdreplay -q

	# Keybinds
	bindkey -e
	bindkey '^p' history-search-backward
	bindkey '^n' history-search-forward
	bindkey -r '^[x'

	# History
	HISTSIZE=5000
	HISTFILE=~/.zsh_history
	SAVEHIST=$HISTSIZE
	HISTDUP=erase
	setopt appendhistory
	setopt sharehistory
	setopt hist_ignore_space
	setopt hist_ignore_all_dups
	setopt hist_save_no_dups
	setopt hist_ignore_dups
	setopt hist_find_no_dups

	# Completion styling
	zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
	zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
	zstyle ':completion:*' menu no

	# Fzf tab styling
	zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa --icons --color=always $realpath'

	# Aliases
	alias l='${lib.getExe pkgs.eza} -lah --color=always --group-directories-first --icons'
	alias la='${lib.getExe pkgs.eza} -al --color=always --group-directories-first --icons'
	alias ll='${lib.getExe pkgs.eza} -l --color=always --group-directories-first --icons'
	alias ls='${lib.getExe pkgs.eza} --icons'
	alias vim='nvim'
	alias cs="vim ~/.cheatsheet.md"


	eval "$(${lib.getExe self'.packages.starship} init zsh)"
        '';
    };
  };
}
