-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:


require "package-manager.user"

require "plugins"

vim.cmd "source ~/.vimrc.d/vimrc-general-options.vim"
vim.cmd "source ~/.vimrc.d/vimrc-key-mappings.vim"


-- lua << EOF
--     local nvim_lsp = require"nvim_lsp"
-- 
--     require"nvim_lsp".dockerls.setup{}
--     require"nvim_lsp".jdtls.setup{
--         root_dir = nvim_lsp.util.root_pattern(
--             ".git", "pom.xml", "build.xml", "build.gradle"),
--         on_attach = function(...)
--             require"vim.lsp.log".error("xxx on_attach: "..vim.inspect(...))
--         end,
--         on_exit = function(...)
--             require"vim.lsp.log".error("xxx on_exit: "..vim.inspect(...))
--         end,
--     }
--     require"nvim_lsp".jsonls.setup{}
--     require"nvim_lsp".pyls.setup{}
--     require"nvim_lsp".tsserver.setup{}
--     require"nvim_lsp".yamlls.setup{}
-- 
--     vim.lsp.callbacks["textDocument/codeAction"] = require"lsputil.codeAction".code_action_handler
--     vim.lsp.callbacks["textDocument/references"] = require"lsputil.locations".references_handler
--     vim.lsp.callbacks["textDocument/definition"] = require"lsputil.locations".definition_handler
--     vim.lsp.callbacks["textDocument/declaration"] = require"lsputil.locations".declaration_handler
--     vim.lsp.callbacks["textDocument/typeDefinition"] = require"lsputil.locations".typeDefinition_handler
--     vim.lsp.callbacks["textDocument/implementation"] = require"lsputil.locations".implementation_handler
--     vim.lsp.callbacks["textDocument/documentSymbol"] = require"lsputil.symbols".document_handler
--     vim.lsp.callbacks["workspace/symbol"] = require"lsputil.symbols".workspace_handler
-- EOF


-- source ~/.vimrc.d/vimrc-python.vim
-- source ~/.vimrc.d/vimrc-vimrc-files.vim
-- source ~/.vimrc.d/vimrc-nerdtree.vim
-- source ~/.vimrc.d/vimrc-split-term.vim
-- 
-- source ~/.vimrc.d/vimrc-copy-paste.vim
-- 
-- source ~/.vimrc.d/vimrc-line-number.vim
-- 
-- source ~/.vimrc.d/vimrc-deoplete.vim
-- 
-- source ~/.vimrc.d/vimrc-ctrlp.vim
-- source ~/.vimrc.d/vimrc-fzf.vim
-- 
-- source ~/.vimrc.d/vimrc-ags.vim
-- source ~/.vimrc.d/vimrc-tagbar.vim
-- source ~/.vimrc.d/vimrc-expand-region.vim
-- source ~/.vimrc.d/vimrc-vim-devicons.vim
-- 
-- source ~/.vimrc.d/vimrc-extra-whitespace.vim
-- 
-- source ~/.vimrc.d/vimrc-colorscheme.vim
-- source ~/.vimrc.d/vimrc-lightline.vim
-- 
-- source ~/.vimrc.d/vimrc-denite.vim
