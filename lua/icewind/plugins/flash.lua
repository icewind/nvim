return {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
        modes = {
            char = {
                enabled = false,
            },
            search = {
                enabled = false,
            },
        },
    },

    keys = {
        {
            "s",
            mode = { "n", "v" },
            function()
                require("flash").jump({ search = { forward = true, wrap = false, multi_window = false } })
            end,
            desc = "Flash",
        },
        {
            "S",
            mode = { "n", "v" },
            function()
                require("flash").jump({ search = { forward = false, wrap = false, multi_window = false } })
            end,
            desc = "Flash",
        },
    },
}
