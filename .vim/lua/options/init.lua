-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:


vim.cmd "source ~/.vimrc.d/vimrc-key-mappings.vim"

require "options.general"
require "options.copy-paste"
require "options.line-number"
require "options.extra-whitespace"
require "options.tabs"

vim.cmd "source ~/.vimrc.d/vimrc-python.vim"
vim.cmd "source ~/.vimrc.d/vimrc-ruby.vim"
