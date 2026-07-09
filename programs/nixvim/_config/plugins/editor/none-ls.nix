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

  extraConfigLua = ''
    local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({ async = false, bufnr = args.buf })
            end,
          })
        end
      end,
    })
  '';

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
  };
}
