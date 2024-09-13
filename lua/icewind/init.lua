require("icewind.core.keymaps")

-- Initialize Lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        { import = "icewind.plugins" },
        { import = "icewind.plugins.lsp" },
        { import = "icewind.plugins.git" },
        { import = "icewind.plugins.colorschemes" },
    },
})

require("icewind.core.options")
require("icewind.core.autocommands")
