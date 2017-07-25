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

call dein#add('tpope/vim-surround')
call dein#add('tpope/vim-commentary')
call dein#add('christoomey/vim-sort-motion')
call dein#add('christoomey/vim-system-copy')
call dein#add('michaeljsmith/vim-indent-object')
call dein#add('kana/vim-textobj-user')
call dein#add('kana/vim-textobj-entire')

" Colorschemes & Apprerances
call dein#add('morhetz/gruvbox')
call dein#add('mkitt/tabline.vim')
call dein#add('itchyny/lightline.vim')
call dein#add('ryanoasis/vim-devicons')
call dein#add('sunaku/vim-hicterm')
call dein#add('machakann/vim-highlightedyank')

" Syntax - python
call dein#add('davidhalter/jedi-vim', { 'on_ft': 'python' })
call dein#add('fisadev/vim-isort', { 'on_ft': 'python' })
call dein#add('tmhedberg/SimpylFold', {'on_ft': 'python'})
call dein#add('bps/vim-textobj-python')

" Syntax - js
call dein#add('Shutnik/jshint2.vim', { 'on_ft': 'javascript' })
call dein#add('elzr/vim-json', {'on_ft': 'json'})

" Syntax - html
call dein#add('valloric/MatchTagAlways', {'on_ft': 'html'})

" Syntax - css
call dein#add('ap/vim-css-color')

" Syntax - General
call dein#add('tpope/vim-sleuth')
call dein#add('nathanaelkane/vim-indent-guides')
call dein#add('khzaw/vim-conceal')
call dein#add('Raimondi/delimitMate', {'on_ft': [
    \ 'python', 'javascript', 'typescript', 'css', 'scss'
    \ ]})
call dein#add('sheerun/vim-polyglot')

" UI
call dein#add('Shougo/denite.nvim')
call dein#add('chemzqm/denite-git')
call dein#add('Shougo/unite-outline')
call dein#add('ujihisa/unite-colorscheme')
call dein#add('maralla/completor.vim')
" call dein#add('Shougo/deoplete.nvim')
" call dein#add('zchee/deoplete-jedi', { 'on_ft': 'python' })
call dein#add('Shougo/context_filetype.vim')
call dein#add('Shougo/echodoc.vim')

" Versioning control
call dein#add('tpope/vim-fugitive')
call dein#add('tpope/vim-git')
call dein#add('jreybert/vimagit')
call dein#add('junegunn/gv.vim')
call dein#add('mhinz/vim-signify')
call dein#add('solars/github-vim')
" call dein#add('jaxbot/github-issues.vim')
call dein#add('rhysd/github-complete.vim')
call dein#add('mattn/gist-vim')

call dein#add('w0rp/ale')
call dein#add('milkypostman/vim-togglelist')
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('edkolev/promptline.vim')
" call dein#add('zhaocai/GoldenView.Vim')
call dein#add('kopischke/vim-stay')
call dein#add('justincampbell/vim-eighties')

call dein#add('junegunn/vim-emoji')

call dein#add('majutsushi/tagbar')
call dein#add('christoomey/vim-tmux-navigator')

call dein#add('matze/vim-move')

" A solid language pack for Vim

call dein#add('gabesoft/vim-ags')
call dein#add('mhinz/vim-startify')
call dein#add('terryma/vim-expand-region')
call dein#add('guns/xterm-color-table.vim')

call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })
call dein#add('cloudhead/neovim-fuzzy')

call dein#add('vimlab/split-term.vim')
call dein#add('kassio/neoterm')
call dein#add('rbgrouleff/bclose.vim')
call dein#add('francoiscabrol/ranger.vim')


if dein#check_install()
    call dein#install()
endif

call dein#end()

