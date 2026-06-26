{
  plugins.telescope = {
    enable = true;

    extensions.ui-select = {
      enable = true;
    };

    keymaps = {
      "<leader>ff" = {
        action = "find_files";
        options = {
          desc = "Find Files";
        };
      };
      "<leader>fg" = {
        action = "live_grep";
        options = {
          desc = "Live Grep";
        };
      };
      "<leader>fb" = {
        action = "buffers";
        options = {
          desc = "Find Buffers";
        };
      };
    };
  };
}
