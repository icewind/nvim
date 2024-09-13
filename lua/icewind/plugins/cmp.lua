return {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        -- Add kind icons into completion dropdown
        "onsails/lspkind-nvim",

        -- Get completions from the current buffer
        "hrsh7th/cmp-buffer",
    },
    config = function()
        vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
        local luasnip = require("luasnip")
        local cmp = require("cmp")
        cmp.setup({
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            ---@diagnostic disable-next-line: missing-fields
            formatting = {
                fields = { "kind", "abbr", "menu" },
                expandable_indicator = false,
                format = require("lspkind").cmp_format({
                    mode = "symbol",
                    maxwidth = 30,
                    before = function(_, item)
                        if item and item.menu and string.len(item.menu) >= 33 then
                            item.menu = string.sub(item.menu, 0, 30) .. "..."
                        end
                        return item
                    end,
                }),
            },
            mapping = {
                ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.close(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<S-CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }),
            },
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                -- Don't look at the current buffer for the word smaller than 5 chars
                { name = "buffer", keyword_length = 5 },
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            experimental = {
                ghost_text = {
                    hl_group = "CmpGhostText",
                },
            },
        })
    end,
}
