{
    viAlias = true;
    vimAlias = true;

    colorschemes.catppuccin.enable = true;

    globals = {
      mapleader = " ";
    };

    opts = {
      expandtab = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      number = true;
      relativenumber = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<c-k>";
        options.silent = true;
        action = ":wincmd k<CR>";
      }
      {
        mode = "n";
        key = "<c-j>";
        options.silent = true;
        action = ":wincmd j<CR>";
      }
      {
        mode = "n";
        key = "<c-h>";
        options.silent = true;
        action = ":wincmd h<CR>";
      }
      {
        mode = "n";
        key = "<c-l>";
        options.silent = true;
        action = ":wincmd l<CR>";
      }

      {
        mode = "n";
        key = "<leader>mx";
        action = "<cmd>!chmod +x %<CR>";
        options = {
          desc = "Make current file executable";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>cf";
        action = ''<cmd>let @+ = expand("%")<CR>'';
        options = {
          desc = "Copy file name";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>cp";
        action = ''<cmd>let @+ = expand("%:p")<CR>'';
        options = {
          desc = "Copy file path";
          silent = true;
        };
      }

      {
        mode = "v";
        key = "<";
        action = "<gv";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
      }
    ];
  }
