return {
    "sainnhe/everforest",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.everforest_background = "medium"
        vim.g.everforest_better_performance = 1
        vim.g.everforest_disable_italic_comment = 1
    end,
}
