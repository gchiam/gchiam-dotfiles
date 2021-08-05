-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:

--
-- color scheme
--
require "plugins.nord-config"


--
-- UI
--

-- optional requirement of lualime.vim
use "kyazdani42/nvim-web-devicons"

-- optional requirement of lualime.vim
use "ryanoasis/vim-devicons"

-- lualine.vim
use "hoob3rt/lualine.nvim"
require("lualine").setup {
options = {
    theme = "nord"
  }
}
