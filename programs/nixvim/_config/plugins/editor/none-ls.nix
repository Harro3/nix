{
  keymaps = [
    {
      mode = "n";
      key = "<leader>fc";
      action = ":lua vim.lsp.buf.format()<CR>";
      options = {
        desc = "Format code";
      };
    }
  ];
  plugins.none-ls = {
    enable = true;

    sources.formatting = {
      alejandra.enable = true;
      stylua.enable = true;
      clang_format.enable = true;
      prettier.enable = true;
      cmake_format.enable = true;
      markdownlint.enable = true;
      nginx_beautifier.enable = true;
      nginx_beautifier.package = null;
      sqlfluff.enable = true;
      shfmt.enable = true;
    };

    settings.on_attach = ''
      function(client, bufnr)
              if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                  group = augroup,
                  buffer = bufnr,
                  callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
                    vim.lsp.buf.format({ async = false })
                  end,
                })
              end
              end

    '';
  };
}
