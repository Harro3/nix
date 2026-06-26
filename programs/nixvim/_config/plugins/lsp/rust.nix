{
  keymaps = [
    {
      mode = "n";
      key = "<leader>rr";
      action = ":RustLsp run<CR>";
      options = {
        desc = "Rust Run";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>rl";
      action = ":RustLsp runnables<CR>";
      options = {
        desc = "Rust List runnables";
        silent = true;
      };
    }
  ];

  plugins.rustaceanvim = {
    enable = true;
    settings.server = {
      on_attach = ''
        function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end
        end
      '';
    };
  };
}
