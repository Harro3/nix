{ inputs, ... }: {
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    let
      selfpkgs = self'.packages;
    in
    {
      packages.shell = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;

        package = selfpkgs.zsh;

        runtimeInputs = [
          selfpkgs.nixvim
          selfpkgs.tmux
          selfpkgs.sesh

          pkgs.glab
          pkgs.git
          pkgs.file
          pkgs.unzip
          pkgs.zip
          pkgs.p7zip
          pkgs.wget
          pkgs.killall
          pkgs.sshfs
          pkgs.fzf
          pkgs.htop
          pkgs.btop
          pkgs.eza
          pkgs.fd
          pkgs.zoxide
          pkgs.dust
          pkgs.ripgrep
          pkgs.fastfetch
          pkgs.tree-sitter
          pkgs.imagemagick
          pkgs.imv
          pkgs.ffmpeg-full
          pkgs.lazygit
          pkgs.yazi
          pkgs.zathura
          pkgs.jq

          pkgs.bash-language-server
          pkgs.shellcheck
          pkgs.gcc
          pkgs.black
        ];

        env = {
          EDITOR = null;
        };
      };
    };
}
