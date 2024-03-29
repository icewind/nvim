-- LSP Configuration
require("mason").setup()

-- Improve lua development
require("neodev").setup()

-- Turn on LSP status information
require("fidget").setup()

-- Attach LSP to autocompletion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Use specific language servers to format specific files
local lsp_formatters_map = {
	lua = "null-ls",
	-- These null-ls should use prettierd
	typescript = "null-ls",
	typescriptreact = "null-ls",
}

-- to avoid the conflict we will select an appropriate server for specified file types
local lsp_format = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			local buffer_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
			return lsp_formatters_map[buffer_type] == nil or lsp_formatters_map[buffer_type] == client.name
		end,
		bufnr = bufnr,
	})
end

local on_attach = function(client, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		lsp_format(bufnr)
	end, { desc = "Format current buffer with LSP" })

	local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })

	-- And automatically format on save
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				lsp_format(bufnr)
			end,
		})
	end
end -- on_attach

-- If some server requires more settings, load them only from a different file
local language_servers = {
	lua_ls = {
		workspace = { checkThirdParty = false },
		telemetry = { enable = false },
	},
	ltex = {},
	marksman = {},
	pyright = {},
	gopls = {},
	rust_analyzer = {},
	tsserver = {},
	prismals = {},
}

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(language_servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { [server_name] = language_servers[server_name] },
		})
	end,
})

-- ---------------------------------------------------------------
-- Manually configured language servers. Not managed by mason.nvim
-- ---------------------------------------------------------------
require("lspconfig").gdscript.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- ---------------------------------------------------------------
-- Integrate mason and null-ls to automatically install all the tools
-- ---------------------------------------------------------------
require("null-ls").setup()
require("mason-null-ls").setup({
	ensure_installed = { "stylua", "prettierd", "eslint_d", "cspell" },
	automatic_setup = true,
	handlers = {},
})

-- ---------------------------------------------------------------
-- General LSP-related settings
-- ---------------------------------------------------------------
-- Custom diagnostics signs. Requires one of the nerd-fonts
local signs = {
	Error = "ﰸ",
	Warn = "",
	Hint = "",
	Info = "",
}

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
end

-- make popups more aestetic
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})
