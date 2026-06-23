{
  lib,
  inputs,
  ...
}: {
  imports = [
    ./options

    ./plugins/global

    ./plugins/languages
  ];

  programs.nixvim.enable = true;
  programs.nixvim.nixpkgs.source = inputs.nixpkgs;

  programs.nixvim.plugins.lsp.servers.ts_query_ls.package = null;

  nvim.plugins = {
    alpha.enable = lib.mkDefault true;
    autopairs.enable = lib.mkDefault true;
    clipboard-image.enable = lib.mkDefault true;
    cmp.enable = lib.mkDefault true;
    dap.enable = lib.mkDefault true;
    flash.enable = lib.mkDefault true;
    floaterm.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    image.enable = lib.mkDefault true;
    lsp.enable = lib.mkDefault true;
    lualine.enable = lib.mkDefault true;
    luasnip.enable = lib.mkDefault true;
    neo-tree.enable = lib.mkDefault true;
    neogen.enable = lib.mkDefault true;
    noice.enable = lib.mkDefault true;
    none-ls.enable = lib.mkDefault true;
    oil.enable = lib.mkDefault true;
    otter.enable = lib.mkDefault true;
    plenary.enable = lib.mkDefault true;
    surround.enable = lib.mkDefault true;
    telescope.enable = lib.mkDefault true;
    tmux-navigator.enable = lib.mkDefault true;
    treesitter.enable = lib.mkDefault true;
    which-key.enable = lib.mkDefault true;
  };
}
