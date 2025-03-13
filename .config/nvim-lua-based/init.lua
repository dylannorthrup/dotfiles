-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Install lspconfig
local lspconfig = require('lspconfig')

lspconfig.helm_ls.setup {
  settings = {
    ['helm-ls'] = {
--      yamlls = {
--        path = "yaml-language-server",
--      }
    }
  }
}

local homeDir = os.getenv("HOME")
vim.cmd("source " .. homeDir .. "/.config/nvim/lua/config/init.vim")
