
" based on https://github.com/mbrochh/mbrochh-dotfiles/blob/master/.vimrc"
" ========================================================================
"
" set tabstop=4 softtabstop=4 shiftwidth=4 :

set encoding=utf-8
autocmd! bufwritepost .vimrc source %

filetype off
" Change pathogen#incubate() to pathogen#infect('bundle/{}')
" call pathogen#incubate()
call pathogen#infect('bundle/{}')
call pathogen#helptags()

filetype plugin indent on
syntax on
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

let g:html_indent_inctags = "html,body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"


" General option
" ===============
let mapleader = "," " rebind <Leader> key
nnoremap . <NOP>
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
set clipboard=unnamed


" Improving code completion
set completeopt=longest,menuone


" found here: http://stackoverflow.com/a/2170800/70778
function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<C-N>"
        elseif a:action == 'k'
            return "\<C-P>"
        endif
    endif
    return a:action
endfunction
inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>


" Quicksave command
noremap <Leader>w :update<CR>
vnoremap <Leader>w <C-C>:update<CR>
inoremap <Leader>w <C-O>:update<CR>


" Quick quit command
noremap <Leader>q <esc>:quit<CR>


" Bind nohl
noremap <Leader>h :nohl<CR>

set history=700
set undolevels=700


set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

au BufRead,BufNewFile *.rb,*.rhtml,*.proto set tabstop=2 shiftwidth=2 softtabstop=2
au BufRead,BufNewFile *.js,*.html,*.proto set tabstop=2 shiftwidth=2 softtabstop=2


" disable formatting when pasting large chunks of code
set pastetoggle=<F2>

set hlsearch
set incsearch
set ignorecase
set smartcase

set nowrap " don't automatically wrap on load
set tw=79  " width of document (used by gd)
set fo-=t  " don't automatically wrap text when typing

" Awesome line number magic
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber number
  endif
  set invnumber
  if(&number == 1)
    set number relativenumber
  endif
endfunc

nnoremap <Leader>l :set relativenumber!<cr>
nnoremap <Leader>L :call NumberToggle()<cr>
:au FocusLost * set norelativenumber number
:au FocusGained * set relativenumber number
autocmd InsertEnter * set norelativenumber number
autocmd InsertLeave * set relativenumber number
set number relativenumber

" center the cursor vertically
:nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>


" easier formatting of paragraphs
vmap Q gq
nmap Q gqap


" Settings for vim-flake8
" ====================
"autocmd BufWritePost *.py call Flake8()
"

" Settings for Powerline
" ======================
let g:Powerline_colorscheme = 'base16'


" Settings for Airline
" ====================
let g:airline_theme = 'hybrid'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 1
let g:airline_powerline_fonts = 1


" Settings for tmuxline
" =====================
let g:tmuxline_preset = 'tmux'


" Settings for Syntastic
" ======================
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_python_checkers = ['flake8', 'pylint']
let g:syntastic_auto_loc_list = 1
let g:syntastic_enable_signs = 1
let g:syntastic_style_error_symbol = '☓❱'
let g:syntastic_style_warning_symbol = '⚐❭'
let g:syntastic_error_symbol = '😑 '
let g:syntastic_warning_symbol = '😭 '
map <F7> <esc>:SyntasticCheck<CR>
map <F8> <esc>:SyntasticToggleMode<CR>


" Settings for JSHint
" ===================
map <F12> <esc>:JSHintUpdate<CR>


" Settings for jedi-vim
" =====================
let g:jedi#usages_command = "<leader>n"
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0


map <Leader>B Oimport ipdb as _xxPDB; _xxPDB.set_trace();  # BREAKPOINT<C-c>
map <Leader>b Oimport pudb as _xxPDB; _xxPDB.set_trace();  # BREAKPOINT<C-c>
map <Leader><c-b> Oimport pdb as _xxPDB; _xxPDB.set_trace();  # BREAKPOINT<C-c>


" Settings for powerline
" ===========================
set laststatus=2 " Always display the statusline in all windows
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)


" Settings for vim-markdown
" ==========================
" let g:vim_markdown_folding_disabled=1
let g:vim_markdown_initial_foldlevel=1


" Settings for ctrlp
" ===================
let g:ctrlp_max_height = 30

" Settings for vim-easymotion
" ===========================

let g:EasyMotion_do_mapping = 1 " Disable default mappings

map <Leader>m <Plug>(easymotion-prefix)

" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" nmap s <Plug>(easymotion-s)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-s2)

" Turn on case sensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)


" key bindings for Tabular plugin
" ===============================
nmap <Leader>t= :Tabularize /=<CR>
vmap <Leader>t= :Tabularize /=<CR>
nmap <Leader>t: :Tabularize /:\zs<CR>
vmap <Leader>t: :Tabularize /:\zs<CR>
nmap <Leader>t\| :Tabularize /\|<CR>
vmap <Leader>t\| :Tabularize /\|<CR>


" Movement
" =========
" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

if bufwinnr(1)
    map + <C-W>>
    map - <C-W><
endif

map <Leader>t <esc>:tabnew<CR>
map <Leader>, <esc>:tabprevious<CR>
map <Leader>. <esc>:tabnext<CR>
vnoremap <Leader>s :sort<CR>

map <Leader>[ <esc>:lprevious<CR>
map <Leader>] <esc>:lnext<CR>

" Window spliting
" ==============
nmap <leader>\| :vs<CR>
nmap <leader>- :split<CR>


" Custom mappings
" ===============
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation
map <Leader>a ggVG  " select all


" Current line & column mappings
" ==============================
nmap <Leader>c <esc>:set cursorline! cursorcolumn!<CR>
set cursorline cursorcolumn

" Fixing the copy & paste madness
" ================================
vmap <C-y> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
nmap <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
imap <C-v> <Esc><C-v>a


" Color scheme
" =============
set t_Co=256
"color wombat256mod
"color lucius
"LuciusDarkLowContrast
set background=dark
"let g:solarized_termtrans=1
"let g:solarized_termcolors=256
"colorscheme solarized
"
let base16colorspace=256
"colorscheme base16-railscasts
colorscheme base16-eighties


set colorcolumn=80
autocmd ColorScheme * highlight ColorColumn ctermbg=235 ctermfg=7
autocmd ColorScheme * highlight SignColumn ctermbg=10
autocmd ColorScheme * highlight SpellBad ctermfg=7 ctermbg=1
"set the showmatch highlight
highlight MatchParen cterm=none ctermbg=238 ctermfg=5
"set the linenumber highlight
highlight LineNr ctermfg=241
"keep the original fg color at cursor column
highlight CursorColumn ctermfg=7
highlight DiffAdd cterm=none ctermbg=2 ctermfg=18
highlight DiffDelete cterm=none ctermbg=1 ctermfg=18
highlight DiffChange cterm=none ctermbg=249 ctermfg=18
highlight DiffText cterm=none ctermbg=6 ctermfg=18

" Show trailing whitespace
" =========================
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
"au InsertLeave * match ExtraWhitespace /\s\+$/
map <Leader>x :%s/\s\+$//


" reload .vimrc file
" =========================
map <Leader>v :source ~/.vimrc<CR>


