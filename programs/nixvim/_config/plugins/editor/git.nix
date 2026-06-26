{
  keymaps = [
    {
      key = "<leader>lg";
      action = "<cmd>LazyGit<CR>";
      options.desc = "LazyGit";
    }
  ];

  plugins.fugitive.enable = true;
  plugins.gitsigns.enable = true;
  plugins.lazygit.enable = true;
}
