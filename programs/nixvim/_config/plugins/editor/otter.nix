{config, lib, ...}: let   languages = ["c" "bash" "sh"]; in{plugins.otter = {
        enable = true;
      };

      keymaps = [
        {
          mode = "n";
          action = ":lua require('otter').activate(${lib.nixvim.toLuaObject languages}, true, true, nil)<CR>";
          key = "<leader>oa";
          options = {
            desc = "Otter Activate";
            silent = true;
          };
        }
      ];
    }
