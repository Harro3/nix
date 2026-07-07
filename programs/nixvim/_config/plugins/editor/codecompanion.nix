{
  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<C-a>";
      action = "<cmd>CodeCompanionActions<CR>";
      options = {
        desc = "Open code companion actions";
        silent = true;
        noremap = true;
      };
    }

    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>a";
      action = "<cmd>CodeCompanionChat Toggle<CR>";
      options = {
        desc = "Toggle code companion chat";
        silent = true;
        noremap = true;
      };
    }

    {
      mode = "v";
      key = "ga";
      action = "<cmd>CodeCompanionChat Add<CR>";
      options = {
        desc = "Add selection to chat";
        silent = true;
        noremap = true;
      };
    }
  ];

  plugins.codecompanion = {
    enable = true;

    settings = {
      interactions = {
        chat = {
          adapter = "claude_code";
        };

        inline = {
          adapter = "claude_code";
        };

        cmd = {
          adapter = "claude_code";
        };

        background = {
          adapter = "claude_code";
        };

        cli = {
          agent = "claude_code";
          agents = {
            claude_code = {
              cmd = "claude";
              args = { };
              description = "Claude Code CLI";
              provider = "terminal";
            };
          };
        };
      };
    };
  };
}

