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
        ];

        env = {
          EDITOR = null;
        };
      };
    };
}
