{
      keymaps = [
        {
          mode = "n";
          key = "-";
          action = ":lua require('oil').open()<CR>";
          options = {
            desc = "Open parent directory";
            silent = true;
          };
        }
      ];
      plugins.oil = {
        enable = true;
      };
    }
