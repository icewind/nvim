-- npm i -g typescript-language-server
return function(capabilities, on_attach)
  require("lspconfig").tsserver.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      -- Disable formatting. I'm using prettier for this
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      return on_attach(client, bufnr)
    end,
  })
end
