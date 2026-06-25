{
    keymaps = [
      {
        mode = "n";
        key = "<leader>y";
        action = ''"+y'';
        options = {
          desc = "Yank into clipboard";
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<leader>y";
        action = ''"+y'';
        options = {
          desc = "Yank into clipboard";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>Y";
        action = ''"+Y'';
        options = {
          desc = "Yank into clipboard";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>p";
        action = ''"+p'';
        options = {
          desc = "Paste clipboard";
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<leader>p";
        action = ''"+p'';
        options = {
          desc = "Paste clipboard";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>P";
        action = ''"+P'';
        options = {
          desc = "Paste clipboard";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>d";
        action = ''"+d'';
        options = {
          desc = "Delete into clipboard";
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<leader>d";
        action = ''"+d'';
        options = {
          desc = "Delete into clipboard";
          silent = true;
        };
      }
    ];
}
