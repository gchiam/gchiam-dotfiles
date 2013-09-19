" based on https://github.com/mbrochh/mbrochh-dotfiles/blob/master/.vimrc"

set encoding=utf-8
autocmd! bufwritepost .vimrc source %

set history=700
set undolevels=700


set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab
" disable formatting when pasting large chunks of code
set pastetoggle=<F2>

set hlsearch
set incsearch
set ignorecase
set smartcase

set nowrap " don't automatically wrap on load
set tw=79  " width of document (used by gd)
set fo-=t  " don't automatically wrap text when typing


filetype off
filetype plugin indent on
syntax on
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS


" Pathogen load
" https://github.com/klen/python-mode#using-pathogen-recomended
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on


let g:html_indent_inctags = "html,body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"


" General option
" ===============
let mapleader = "," " rebind <Leader> key
set wildmode=list:longest " make TAB behave like in a shell
set autoread " reload file when changes happen in other editors
set tags=./tags


set mouse=a
set bs=2 " make backspace behave like normal again
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*


" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile


" make yank copy to the global system clipboard
"set clipboard=unnamed "windows
set clipboard=unnamedplus

" Map Ctrl+C to copy to syste, clipboard
vmap <C-c> "+y

" Improving code completion
set completeopt=longest,menuone


" Quicksave command
noremap <Leader>w :update<CR>
vnoremap <Leader>w <C-C>:update<CR>
inoremap <Leader>w <C-O>:update<CR>


" Quick quit command
noremap <Leader>e :quit<CR>


" Bind nohl
noremap <Leader>h :nohl<CR>


"
" Movement
" =========
" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>
vnoremap <Leader>s :sort<CR>


" Custom mappings
" ================
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation
map <Leader>a ggVG  " select all


" Fixing the copy & paste madness
" ================================
vmap <C-y> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
nmap <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
imap <C-v> <Esc><C-v>a


" Show trailing whitespace
" =========================
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/
map <Leader>x :%s/\s\+$//


" Color scheme
" =============
set t_Co=256
color wombat256mod


set colorcolumn=80
highlight ColorColumn ctermbg=233
map <Leader>v :source ~/.vimrc



