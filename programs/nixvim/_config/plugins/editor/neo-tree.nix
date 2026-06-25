{
      keymaps = [
        {
          mode = "n";
          key = "<C-n>";
          action = ":Neotree filesystem toggle left <CR>";
          options = {
            desc = "Toggle neotree";
            silent = true;
          };
        }
      ];
      plugins = {
        neo-tree.enable = true;
        nui.enable = true;
        web-devicons.enable = true;
      };
    }
