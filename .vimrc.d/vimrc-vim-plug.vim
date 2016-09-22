scriptencoding utf-8


call plug#begin('~/.vim/plugged')

Plug 'benekastah/neomake'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'Raimondi/delimitMate'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'edkolev/promptline.vim'
Plug 't9md/vim-choosewin'
Plug 'zhaocai/GoldenView.Vim'
Plug 'kopischke/vim-stay'
Plug 'romgrk/winteract.vim'

Plug 'junegunn/vim-emoji'

" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter'
Plug 'tmhedberg/SimpylFold'
Plug 'godlygeek/tabular'
Plug 'majutsushi/tagbar'
Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-git'
Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'

" A solid language pack for Vim
Plug 'sheerun/vim-polyglot'

" Loaded when Dockerfile is opened
Plug 'ekalinin/Dockerfile.vim'

Plug 'tmux-plugins/vim-tmux'

" Loaded when python file is opened
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'fisadev/vim-isort', { 'for': 'python' }

Plug 'Shutnik/jshint2.vim', { 'for': 'javascript' }

" For tmux.conf
Plug 'tmux-plugins/vim-tmux'

Plug 'Lokaltog/vim-easymotion'
Plug 'gabesoft/vim-ags'
Plug 'tpope/vim-surround'
Plug 'mhinz/vim-startify'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'terryma/vim-expand-region'
Plug 'khzaw/vim-conceal'
Plug 'junegunn/vim-plug'
Plug 'kien/rainbow_parentheses.vim'
Plug 'guns/xterm-color-table.vim'
Plug 'sunaku/vim-hicterm'

Plug 'morhetz/gruvbox'

Plug 'Shougo/deoplete.nvim', { 'for': 'python', 'do': 'UpdateRemotePlugins'}
Plug 'zchee/deoplete-jedi', { 'for': 'python' }
Plug 'Shougo/context_filetype.vim'
Plug 'Shougo/echodoc.vim'

Plug 'junegunn/fzf.vim'

Plug 'vimlab/split-term.vim'

call plug#end()
