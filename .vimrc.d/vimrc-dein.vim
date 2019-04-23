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
call dein#add('sonph/onehalf', {'rtp': 'vim/'})
call dein#add('ajh17/Spacegray.vim')
call dein#add('mhartington/oceanic-next')
call dein#add('itchyny/lightline.vim')
call dein#add('ryanoasis/vim-devicons')
call dein#add('sunaku/vim-hicterm')
call dein#add('machakann/vim-highlightedyank')

" Syntax - python
call dein#add('raimon49/requirements.txt.vim')
call dein#add('vim-python/python-syntax', {'on_ft': 'python'})
call dein#add('kalekundert/vim-coiled-snake', {'on_ft': 'python'})
call dein#add('Konfekt/FastFold', {'on_ft': 'python'})
call dein#add('jeetsukumaran/vim-pythonsense', {'on_ft': 'python'})


" Syntax - General
call dein#add('sheerun/vim-polyglot')
call dein#add('tpope/vim-sleuth')
call dein#add('khzaw/vim-conceal')

" UI
call dein#add('scrooloose/nerdtree')
call dein#add('Xuyuanp/nerdtree-git-plugin')
call dein#add('tiagofumo/vim-nerdtree-syntax-highlight')
call dein#add('Shougo/denite.nvim')
call dein#add('chemzqm/denite-git')
call dein#add('Shougo/unite-outline')
call dein#add('neoclide/coc.nvim', {'merge':0, 'build': './install.sh nightly'})
call dein#add('Shougo/context_filetype.vim')
call dein#add('Shougo/echodoc.vim')

" Versioning control
call dein#add('tpope/vim-fugitive')
call dein#add('mhinz/vim-signify')

call dein#add('milkypostman/vim-togglelist')
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('kopischke/vim-stay')

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

call dein#add('vimlab/split-term.vim')


if dein#check_install()
    call dein#install()
endif

call dein#end()
