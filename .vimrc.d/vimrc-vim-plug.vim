scriptencoding utf-8


call plug#begin('~/.vim/plugged')

Plug 'w0rp/ale'
Plug 'milkypostman/vim-togglelist'
Plug 'kien/ctrlp.vim'
Plug 'Raimondi/delimitMate'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'edkolev/promptline.vim'
Plug 't9md/vim-choosewin'
Plug 'zhaocai/GoldenView.Vim'
Plug 'kopischke/vim-stay'
Plug 'romgrk/winteract.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-vinegar'

Plug 'junegunn/vim-emoji'

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
Plug 'solars/github-vim'

Plug 'matze/vim-move'

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
" Plug 'kien/rainbow_parentheses.vim'
Plug 'guns/xterm-color-table.vim'
Plug 'sunaku/vim-hicterm'

Plug 'morhetz/gruvbox'

Plug 'roxma/nvim-completion-manager'
" Plug 'Shougo/deoplete.nvim', { 'for': 'python', 'do': 'UpdateRemotePlugins'}
" Plug 'zchee/deoplete-jedi', { 'for': 'python' }
Plug 'Shougo/denite.nvim'
Plug 'Shougo/context_filetype.vim'
Plug 'Shougo/echodoc.vim'
Plug 'chemzqm/vim-easygit'
Plug 'chemzqm/denite-git'

Plug 'junegunn/fzf.vim'
Plug 'cloudhead/neovim-fuzzy'

Plug 'vimlab/split-term.vim'
Plug 'kassio/neoterm'

call plug#end()
