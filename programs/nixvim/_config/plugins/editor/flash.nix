{
  keymaps = [
    {
      mode = "n";
      key = "<leader>s";
      action = '':lua require("flash").jump()<CR>'';
      options = {
        desc = "Open flask jump";
        silent = true;
      };
    }
  ];
  plugins.flash = {
    enable = true;
  };
}
