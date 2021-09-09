scriptencoding utf-8

" vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:


" setup user.nvim - A simple Neovim package manager "
" https://github.com/faerryn/user.nvim
lua << EPF
  local user_packadd_path = "faerryn/user.nvim/default"
  local user_install_path = vim.fn.stdpath("data").."/site/pack/user/opt/"..user_packadd_path
  if vim.fn.isdirectory(user_install_path) == 0 then
    os.execute("git clone --quiet --depth 1 https://github.com/faerryn/user.nvim.git "..vim.fn.shellescape(user_install_path))
  end
  vim.api.nvim_command("packadd "..vim.fn.fnameescape(user_packadd_path))

  local user = require("user")
  user.setup()
  local use = user.use

  -- user.nvim can manage itself!
  use "faerryn/user.nvim"

  --
  -- color scheme
  --

  -- https://github.com/shaunsingh/nord.nvim
  use "shaunsingh/nord.nvim"
  vim.g.nord_borders = true
  vim.g.nord_contrast = true
  vim.g.nord_disable_background = true
  vim.g.nord_enable_sidebar_background = true
  vim.g.nord_italic = true
  vim.cmd[[au VimEnter * highlight Comment gui=italic]]
  require('nord').set()

  --
  -- UI
  --

  -- optional requirement of lualime.vim
  use 'kyazdani42/nvim-web-devicons'

  -- optional requirement of lualime.vim
  use 'ryanoasis/vim-devicons'

  -- lualine.vim
  use 'hoob3rt/lualine.nvim'
  require('lualine').setup {
  options = {
    theme = 'nord'
  }
}
EPF

" lua << EOF
"     local nvim_lsp = require'nvim_lsp'
" 
"     require'nvim_lsp'.dockerls.setup{}
"     require'nvim_lsp'.jdtls.setup{
"         root_dir = nvim_lsp.util.root_pattern(
"             '.git', 'pom.xml', 'build.xml', 'build.gradle'),
"         on_attach = function(...)
"             require'vim.lsp.log'.error('xxx on_attach: '..vim.inspect(...))
"         end,
"         on_exit = function(...)
"             require'vim.lsp.log'.error('xxx on_exit: '..vim.inspect(...))
"         end,
"     }
"     require'nvim_lsp'.jsonls.setup{}
"     require'nvim_lsp'.pyls.setup{}
"     require'nvim_lsp'.tsserver.setup{}
"     require'nvim_lsp'.yamlls.setup{}
" 
"     vim.lsp.callbacks['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
"     vim.lsp.callbacks['textDocument/references'] = require'lsputil.locations'.references_handler
"     vim.lsp.callbacks['textDocument/definition'] = require'lsputil.locations'.definition_handler
"     vim.lsp.callbacks['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
"     vim.lsp.callbacks['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
"     vim.lsp.callbacks['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
"     vim.lsp.callbacks['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
"     vim.lsp.callbacks['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
" EOF

" source ~/.vimrc.d/vimrc-general-options.vim
" source ~/.vimrc.d/vimrc-key-mappings.vim

" source ~/.vimrc.d/vimrc-python.vim
" source ~/.vimrc.d/vimrc-vimrc-files.vim
" source ~/.vimrc.d/vimrc-nerdtree.vim
" source ~/.vimrc.d/vimrc-split-term.vim
" 
" source ~/.vimrc.d/vimrc-copy-paste.vim
" 
" source ~/.vimrc.d/vimrc-line-number.vim
" 
" source ~/.vimrc.d/vimrc-deoplete.vim
" 
" source ~/.vimrc.d/vimrc-ctrlp.vim
" source ~/.vimrc.d/vimrc-fzf.vim
" 
" source ~/.vimrc.d/vimrc-ags.vim
" source ~/.vimrc.d/vimrc-tagbar.vim
" source ~/.vimrc.d/vimrc-expand-region.vim
" source ~/.vimrc.d/vimrc-vim-devicons.vim
" 
" source ~/.vimrc.d/vimrc-extra-whitespace.vim
" 
" source ~/.vimrc.d/vimrc-colorscheme.vim
" source ~/.vimrc.d/vimrc-lightline.vim
" 
" source ~/.vimrc.d/vimrc-denite.vim
