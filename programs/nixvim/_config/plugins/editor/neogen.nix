{
      keymaps = [
        {
          mode = "n";
          key = "<leader>mc";
          action = ":lua require('neogen').generate()<CR>";
          options = {
            desc = "Make Comment";
            silent = true;
            noremap = true;
          };
        }
      ];
      plugins.neogen.enable = true;
    }
