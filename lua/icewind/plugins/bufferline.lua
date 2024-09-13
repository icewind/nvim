return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    version = "*",
    opts = {
        options = {
            show_close_icon = false,
            show_buffer_close_icons = false,
        },
        highlights = {
            fill = {
                bg = "#313C41",
                fg = "#7a8478",
            },
        },
    },
}
