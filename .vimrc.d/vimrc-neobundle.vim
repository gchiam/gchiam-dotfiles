scriptencoding utf-8

" set tabstop=4 softtabstop=4 shiftwidth=4 :
"
" -----------------------------------------------------------------------------
"
" Copied from https://github.com/mhartington/dotfiles/blob/master/vimrc
"
" -----------------------------------------------------------------------------


"" Setup NeoBundle  -----------------------------------------------------------
" If vundle is not installed, do it first
if (!isdirectory(expand("$HOME/.vim/repos/github.com/Shougo/dein.vim")))
    call system(expand("mkdir -p $HOME/.vim/repos/github.com"))
    call system(expand("git clone https://github.com/Shougo/dein.vim $HOME/.vim/repos/github.com/Shougo/dein.vim"))
endif

" Required:
set runtimepath+=~/.vim/repos/github.com/Shougo/dein.vim/

" Required:
call dein#begin(expand('~/.vim'))
let pluginsExist = 0

" Let NeoBundle manage NeoBundle
" Required:
call dein#add('Shougo/dein.vim')
call dein#add('haya14busa/dein-command.vim')

" Colorschemes & Apprerances
call dein#add('morhetz/gruvbox')
call dein#add('jacoborus/tender.vim')
call dein#add('itchyny/lightline.vim')
call dein#add('shinchu/lightline-gruvbox.vim')
call dein#add('ryanoasis/vim-devicons')
call dein#add('machakann/vim-highlightedyank')
call dein#add('sunaku/vim-hicterm')

" Syntax - python
call dein#add('davidhalter/jedi-vim', { 'on_ft': 'python' })
call dein#add('fisadev/vim-isort', { 'on_ft': 'python' })
call dein#add('tmhedberg/SimpylFold', {'on_ft': 'python'})

" Syntac - js
call dein#add('Shutnik/jshint2.vim', { 'on_ft': 'javascript' })
call dein#add('elzr/vim-json', {'on_ft': 'json'})

" Syntax - tmux config
call dein#add('tmux-plugins/vim-tmux', {'on_ft': 'tmux'})

" Syntax - Dockerfile
call dein#add('ekalinin/Dockerfile.vim', {'on_ft': 'dockerfile'})

" Syntax - html
call dein#add('valloric/MatchTagAlways', {'on_ft': 'html'})

" Syntax - css
call dein#add('ap/vim-css-color')

" Syntax - Markdown
call dein#add('tpope/vim-markdown', {'on_ft': 'markdown'})

" Syntax - General
call dein#add('tpope/vim-sleuth')
call dein#add('nathanaelkane/vim-indent-guides')
call dein#add('khzaw/vim-conceal')
call dein#add('Raimondi/delimitMate', {'on_ft': [
    \ 'python', 'javascript', 'typescript', 'css', 'scss'
    \ ]})
call dein#add('sheerun/vim-polyglot')
call dein#add('scrooloose/nerdcommenter')

" UI
call dein#add('Shougo/unite.vim')
call dein#add('chemzqm/denite-git')
call dein#add('Shougo/unite-outline')
call dein#add('ujihisa/unite-colorscheme')

" Versioning control
call dein#add('tpope/vim-fugitive')
call dein#add('tpope/vim-git')
call dein#add('jreybert/vimagit')
call dein#add('junegunn/gv.vim')
call dein#add('mhinz/vim-signify')
call dein#add('solars/github-vim')
" call dein#add('chemzqm/vim-easygit')
call dein#add('jaxbot/github-issues.vim')
call dein#add('rhysd/github-complete.vim')
call dein#add('mattn/gist-vim')





call dein#add('w0rp/ale')
call dein#add('milkypostman/vim-togglelist')
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('edkolev/promptline.vim')
call dein#add('zhaocai/GoldenView.Vim')
call dein#add('kopischke/vim-stay')
call dein#add('romgrk/winteract.vim')
call dein#add('tpope/vim-vinegar')

call dein#add('junegunn/vim-emoji')

call dein#add('godlygeek/tabular')
call dein#add('majutsushi/tagbar')
call dein#add('christoomey/vim-tmux-navigator')
call dein#add('edkolev/tmuxline.vim')


call dein#add('matze/vim-move')

" A solid language pack for Vim

call dein#add('Lokaltog/vim-easymotion')
call dein#add('gabesoft/vim-ags')
call dein#add('tpope/vim-surround')
call dein#add('mhinz/vim-startify')
call dein#add('terryma/vim-expand-region')
" Plug 'kien/rainbow_parentheses.vim'
call dein#add('guns/xterm-color-table.vim')


call dein#add('roxma/nvim-completion-manager')
" call dein#add('Shougo/deoplete.nvim', { 'on_ft': 'python', 'do': 'UpdateRemotePlugins'})
" call dein#add('zchee/deoplete-jedi', { 'on_ft': 'python' })
call dein#add('Shougo/denite.nvim')
call dein#add('Shougo/context_filetype.vim')
call dein#add('Shougo/echodoc.vim')

call dein#add('junegunn/fzf.vim')
call dein#add('cloudhead/neovim-fuzzy')

call dein#add('vimlab/split-term.vim')
call dein#add('kassio/neoterm')

if dein#check_install()
    call dein#install()
endif

call dein#end()