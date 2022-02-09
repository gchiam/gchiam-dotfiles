-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:

--
-- Core
require "plugins.plenary"

require "plugins.nvim-lspconfig"
require "plugins.nvim-compe"

--
-- color scheme
require "plugins.onenord"

--
-- UI
require "plugins.nvim-web-devicons"
require "plugins.lualine"
require "plugins.golden-ratio"
require "plugins.nvim-colorizer"
require "plugins.vim-conceal"
require "plugins.vim-emoji"
require "plugins.vim-highlightedyank"

--
-- IDE
require "plugins.nvim-treesitter"
require "plugins.telescope"
require "plugins.gitsigns"
-- require "plugins.semshi"
require "plugins.vim-commentary"
require "plugins.vim-sleuth"

require("user").flush()
