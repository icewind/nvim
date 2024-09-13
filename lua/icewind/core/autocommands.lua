-- Mostly taken from lazyvim config

local function augroup(name)
    return vim.api.nvim_create_augroup("my_autocommands_" .. name, { clear = true })
end

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("last_loc"),
    callback = function()
        local exclude = { "gitcommit" }
        local buf = vim.api.nvim_get_current_buf()
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
            return
        end
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Highlight on yank!
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = augroup("resize_splits"),
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Add database to completion sources for sql files
vim.cmd(
    [[autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({sources={{name='vim-dadbod-completion'}}})]]
)

-- close some filetypes with just <q>
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = augroup("auto_create_dir"),
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    desc = "Disable semantic highlight in lua files",
    group = augroup("grey_out_lua_annotations"),
    callback = function(opts)
        -- In case it is @meta file meaning there are only type annotations,
        -- it is ok to keep the highlight
        if vim.bo[opts.buf].filetype ~= "lua" or opts.match:sub(-6) == ".d.lua" then
            return
        end
        vim.api.nvim_create_autocmd("LspTokenUpdate", {
            callback = function(args)
                local token = args.data.token
                local starts_with = vim.api.nvim_buf_get_text(args.buf, token.line, 0, token.line, 2, {})[1]
                -- Check if this line is started from a comment
                if starts_with ~= "--" then
                    return
                end
                vim.lsp.semantic_tokens.highlight_token(token, args.buf, args.data.client_id, "Comment")
            end,
        })
    end,
})
