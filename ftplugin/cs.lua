-- Automatically format the document and sort usings on save
-- OrganizeImports defined as a command line argument in lspconfig.lua
vim.cmd[[
	autocmd BufWritePre *.cs lua vim.lsp.buf.formatting_sync()
]]

