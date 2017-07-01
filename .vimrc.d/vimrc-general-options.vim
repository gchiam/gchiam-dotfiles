scriptencoding utf-8


" General option
" ===============
set wildmode=list:longest  " make TAB behave like in a shell
set autoread  " reload file when changes happen in other editors
set tags=./tags

if &encoding !=# 'utf-8'
    set encoding=utf-8  " The encoding displayed.
endif
set fileencoding=utf-8  " The encoding written to file.<F37>

filetype off
filetype plugin indent on
syntax on

let g:html_indent_inctags = "html,body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

set mouse=a
set bs=2 " make backspace behave like normal again
set timeoutlen=500
set wildignore+=*.a
set wildignore+=*.class
set wildignore+=*.gif
set wildignore+=*.jpg
set wildignore+=*.la
set wildignore+=*.mo
set wildignore+=*.o
set wildignore+=*.obj
set wildignore+=*.png
set wildignore+=*.pyc
set wildignore+=*.so
set wildignore+=*.swp
set wildignore+=*.tags
set wildignore+=*.xpm
set wildignore+=*/coverage/*
set wildignore+=*_build/*
set wildignore+=.git
set wildignore+=.svn
set wildignore+=CVS
set wildignore+=tags

"
" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile

set history=700
set undolevels=700

set hlsearch
set incsearch
set inccommand=split
set ignorecase
set smartcase

" set fillchars=vert:⏐

set hidden " required by vim-ctrlspace

set nowrap " don't automatically wrap on load
set tw=79  " width of document (used by gd)
set fo-=t  " don't automatically wrap text when typing


set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor


source ~/.vimrc.d/vimrc-tabs.vim
source ~/.vimrc.d/vimrc-terminal.vim
