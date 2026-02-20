{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    nvim.lang.angular.enable = lib.mkEnableOption "Angular language";
  };

  config = lib.mkIf config.nvim.lang.angular.enable {
    home.packages = with pkgs; [
      nodejs_20
    ];

    programs.nixvim.plugins.lsp.servers.angularls = {
      enable = true;
    };
  };
}
