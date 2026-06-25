{inputs, self, ...}: {
  flake.nixosModules.fonts = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
    nerdfix
  ];
  fonts.fontconfig.enable = true;

  fonts.packages = with pkgs; [
    fira-code
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.symbols-only
    ];
  };
}
