-- Development of lua plugins and neovim configuration files
-- The language server itself is installed using Homebrew
-- brew install lua-language-server
local runtime_path = vim.split(package.path, ";")
local library = {}
local global_includes = {}

-- TODO: Refactor all this crap to normal config

if string.find(vim.fn.getcwd():lower(), "nvim") then
  -- Setup the environment for plugin development
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")
  global_includes = { "vim" }

  -- TODO: Check if I need to exclude some plugins and adjust this table
  library = vim.api.nvim_get_runtime_file("", true)
elseif string.find(vim.fn.getcwd():lower(), "/games/") then
  -- Settings for a defold game engine
  library = {
    "/${3rd}/Defold/library",
  }
else
  -- Usual lua application/module
  table.insert(runtime_path, "?.lua")
  table.insert(runtime_path, "?/init.lua")
  library = {
    "/usr/local/bin/lua",
  }
end

return function(capabilities, on_attach)
  require("lspconfig").sumneko_lua.setup({
    cmd = { "/usr/local/Cellar/lua-language-server/3.6.4/bin/lua-language-server" },
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "lua" },
    rootPatterns = ".git/",
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = runtime_path,
        },
        diagnostics = {
          globals = global_includes,
        },
        workspace = {
          library = library,
          useGitIgnore = true,
        },
        telemetry = {
          enable = false,
        },
        completion = {
          showWord = "Disable",
        },
      },
    },
  })
end
