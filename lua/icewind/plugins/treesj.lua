return {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
    config = function()
        local instance = require("treesj")
        instance.setup({
            use_default_keymaps = false,
        })
        vim.keymap.set("n", "<leader>bp", instance.split)
        vim.keymap.set("n", "<leader>jp", instance.join)
    end,
}
