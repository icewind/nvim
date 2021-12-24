-- Automatically format lua files on save
vim.cmd([[
	autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync()
]])
