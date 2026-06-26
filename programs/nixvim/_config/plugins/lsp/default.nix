{...}: {
  imports = [
    ./rust.nix
    ./tex.nix
  ];

  plugins.render-markdown.enable = true;
  plugins.markdown-preview.enable = true;

  plugins.lsp.servers = {
  bashls.enable = true;
  clangd.enable  = true;
  dockerls.enable = true;
  docker_compose_language_service.enable = true;
  cssls.enable = true;
  html.enable = true;
  jsonls.enable = true;
  marksman.enable = true;
  nil_ls.enable = true;
  pyright.enable = true;
  ruff.enable = true;
  lemminx.enable = true;
  yamlls.enable = true;
  };
}
