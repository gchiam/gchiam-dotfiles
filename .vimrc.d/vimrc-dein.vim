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
" call dein#add('Shougo/dein.vim')
" call dein#add('haya14busa/dein-command.vim')

call dein#add('tpope/vim-surround')
call dein#add('christoomey/vim-sort-motion')
call dein#add('michaeljsmith/vim-indent-object')
call dein#add('kana/vim-textobj-user')
call dein#add('kana/vim-textobj-entire')

" Syntax - python

call dein#add('terryma/vim-expand-region')
call dein#add('guns/xterm-color-table.vim')

if dein#check_install()
    call dein#install()
endif

call dein#end()
