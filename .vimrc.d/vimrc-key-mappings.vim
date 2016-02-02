let mapleader = "\<Space>" " rebind <Leader> key
nnoremap . <NOP>

" disable formatting when pasting large chunks of code
set pastetoggle=<F2>


" Open and Save
" =============
nnoremap <Leader>o :CtrlP<CR>
noremap <Leader>w :update<CR>
vnoremap <Leader>w <C-C>:update<CR>


" Quick quit command
" ==================
noremap <Leader>q <esc>:quit<CR>
noremap <Leader>Q <esc>:quit!<CR>


" Bind nohl
" =========
noremap <Leader>h :nohl<CR>


" easier formatting of paragraphs
" ===============================
vmap Q gq
nmap Q gqap


" Movement
" ========
" bind Ctrl+<movement> keys to move around the windows, instead of using
" Ctrl+w + <movement>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h


" Resize pane
" ==========
if bufwinnr(1)
    map + <C-W>>
    map - <C-W><
endif


" Tab
" ===
map <Leader>t <esc>:tabnew<CR>
map <Leader>, <esc>:tabprevious<CR>
map <Leader>. <esc>:tabnext<CR>
vnoremap <Leader>s :sort<CR>

map <Leader>[ <esc>:lprevious<CR>
map <Leader>] <esc>:lnext<CR>


" Window spliting
" ==============
nmap <leader>\| :vs<CR>
nmap <leader>\ :vs<CR>
nmap <leader>- :split<CR>


" Custom mappings
" ===============
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation
map <Leader>a ggVG  " select all


" Current line & column mappings
" ==============================
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
set cursorline cursorcolumn


" Line wrapping
" =============
nnoremap <Leader>W :set wrap!<CR>


" center the cursor vertically
" ============================
nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>


" Diff mappings
" =============
nmap <Leader><Leader>d <esc>:diffthis<CR> <esc>:set nocursorline nocursorcolumn<CR>
nmap <Leader><Leader>D <esc>:diffoff<CR> <esc>:set cursorline cursorcolumn<CR>
