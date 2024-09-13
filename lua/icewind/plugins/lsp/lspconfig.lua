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

-- Use specific language servers to format specific files
local lsp_formatters_map = {
    lua = "null-ls",
    -- These null-ls should use prettierd
    typescript = "null-ls",
    typescriptreact = "null-ls",
}

-- Avoid the conflict we will select an appropriate server for specified file types
local lsp_format = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            local buffer_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
            return lsp_formatters_map[buffer_type] == nil or lsp_formatters_map[buffer_type] == client.name
        end,
        bufnr = bufnr,
    })
end

-- Check if the method is supported by any of the attached LSPs
local supports = function(bufnr, action)
    action = action:find("/") and action or "textDocument/" .. action
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
        if client.supports_method(action) then
            return true
        end
    end
    return false
end

local on_attach = function(client, bufnr)
    local nmap = function(keys, func, desc, mode)
        if desc then
            desc = "LSP: " .. desc
        end
        vim.keymap.set(mode or "n", keys, func, { buffer = bufnr, desc = desc })
    end

    -- Code actions
    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "v", "n" })
    nmap("<leader>cA", function()
        vim.lsp.buf.code_action({
            context = {
                only = {
                    "source",
                },
                diagnostics = {},
            },
        })
    end, "Source [A]ction")

    -- Formatting
    nmap("<leader>cf", function()
        lsp_format(bufnr)
    end, "[C]ode [F]ormat")

    -- For visual mode there might be a separate range formatting action
    if supports(bufnr, "rangeFormatting") then
        nmap("<leader>cf", function()
            lsp_format(bufnr)
        end, "[C]ode [F]ormat [S]election", "v")
    end

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]definition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]definition")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]symbols")
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]symbols")

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

local language_servers = {
    lua_ls = {
        settings = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
    ltex = {
        filetypes = { "markdown", "org", "restructuredtext" },
    },
    marksman = {},
    pyright = {},
    gopls = {},
    rust_analyzer = {},
    tsserver = {
        init_options = {
            preferences = {
                disableSuggestions = true,
            },
        },
    },
    svelte = {},
    astro = {},
    tailwindcss = {},
    eslint = {},
    ruff = {},
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "nvimtools/none-ls.nvim",
        -- "davidmh/cspell.nvim",
        "jay-babu/mason-null-ls.nvim",
        "j-hui/fidget.nvim",
        "folke/neodev.nvim",
    },
    config = function()
        require("mason").setup()

        require("neodev").setup()

        require("fidget").setup()

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        local mason_lspconfig = require("mason-lspconfig")

        mason_lspconfig.setup({
            ensure_installed = vim.tbl_keys(language_servers),
        })

        mason_lspconfig.setup_handlers({
            function(server_name)
                require("lspconfig")[server_name].setup(vim.tbl_extend("keep", {
                    capabilities = capabilities,
                    on_attach = on_attach,
                }, language_servers[server_name]))
            end,
        })

        -- ---------------------------------------------------------------
        -- Manually configured language servers. Not managed by mason.nvim
        -- ---------------------------------------------------------------
        require("lspconfig").gdscript.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        local null_ls = require("null-ls")
        null_ls.setup({
            on_attach = on_attach,
        })

        ---@diagnostic disable-next-line: missing-fields
        require("mason-null-ls").setup({
            ensure_installed = { "stylua", "prettierd" },
            handlers = {
                prettierd = function()
                    null_ls.register(require("null-ls").builtins.formatting.prettierd.with({
                        filetypes = {
                            "javascript",
                            "javascriptreact",
                            "typescript",
                            "typescriptreact",
                            "vue",
                            "css",
                            "scss",
                            "less",
                            "html",
                            "json",
                            "jsonc",
                            "yaml",
                            "markdown",
                            "markdown.mdx",
                            "graphql",
                            "handlebars",
                            "astro",
                        },
                        condition = function(utils)
                            return utils.root_has_file("package.json")
                                or utils.root_has_file(".prettierrc")
                                or utils.root_has_file(".prettierrc.json")
                                or utils.root_has_file(".prettierrc.js")
                        end,
                    }))
                end,
            },
        })
    end,
}
