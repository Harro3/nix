{
  keymaps = [
    {
      mode = "n";
      key = "<leader>s";
      action = '':lua require("flash").jump()<CR>'';
    }
  ];
  plugins.flash = {
    enable = true;
  };
}
