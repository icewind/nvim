return function(capabilities, on_attach)
  require("lspconfig").gdscript.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end
