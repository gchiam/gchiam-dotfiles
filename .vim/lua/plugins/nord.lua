-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:

-- https://github.com/shaunsingh/nord.nvim

use "shaunsingh/nord.nvim"

vim.g.nord_borders = true
vim.g.nord_contrast = true
vim.g.nord_disable_background = true
vim.g.nord_enable_sidebar_background = true
vim.g.nord_italic = true
vim.cmd[[au VimEnter * highlight Comment gui=italic]]
require("nord").set()
