scriptencoding utf-8

let g:mapleader = "\<Space>" " rebind <Leader> key
nnoremap . <NOP>

" disable formatting when pasting large chunks of code
set pastetoggle=<F2>


" Open and Save
" =============
noremap <Leader>w :update<CR>
vnoremap <Leader>w <C-C>:update<CR>


" Quick quit command
" ==================
noremap <Leader>q <esc>:quit<CR>
noremap <Leader>Q <esc>:quitall<CR>


" Bind nohl
" =========
noremap <Leader>h :nohl<CR>


" easier formatting of paragraphs
" ===============================
vmap Q gq
nmap Q gqap


" Use tab and shift-tab to cycle through windows.
" http://howivim.com/2016/andy-stewart/
nnoremap <Tab> <C-W>w
nnoremap <S-Tab> <C-W>W


" Movement
" ========
" bind Ctrl+<movement> keys to move around the windows, instead of using
" Ctrl+w + <movement>
" Ctrl+h doesn't work under iTerm2 by default
" See https://github.com/neovim/neovim/issues/2048#issuecomment-98307896
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Move to begining of line
nmap 0 ^
nmap , ^
" Move to end of line
nmap . $

" switch between tabs with Meta+1, Meta+2,...
map <M-1> 1gt
map <M-2> 2gt
map <M-3> 3gt
map <M-4> 4gt
map <M-5> 5gt
map <M-6> 6gt
map <M-7> 7gt
map <M-8> 8gt
map <M-9> 9gt


" Resize pane
" ==========
if bufwinnr(1)
    map + <C-W>>
    map - <C-W><
    map <M-+> 5<C-W>>
    map <M--> 5<C-W><
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
" set cursorline cursorcolumn


" center the cursor vertically
" ============================
nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>


" Diff mappings
" =============
nmap <Leader><Leader>d <esc>:diffthis<CR> <esc>:set nocursorline nocursorcolumn<CR>
nmap <Leader><Leader>D <esc>:diffoff<CR> <esc>:set cursorline cursorcolumn<CR>


" Shift-hjkl for split resizing
" http://www.vimbits.com/bits/562
" =====--------------------------

" Tmux-like window resizing
function! IsEdgeWindowSelected(direction)
    let l:curwindow = winnr()
    exec 'wincmd '.a:direction
    let l:result = l:curwindow == winnr()

    if (!l:result)
        " Go back to the previous window
        exec l:curwindow.'wincmd w'
    endif

    return l:result
endfunction

function! GetAction(direction)
    let l:keys = ['h', 'j', 'k', 'l']
    let l:actions = ['vertical resize -', 'resize +', 'resize -', 'vertical resize +']
    return get(l:actions, index(l:keys, a:direction))
endfunction

function! GetOpposite(direction)
    let l:keys = ['h', 'j', 'k', 'l']
    let l:opposites = ['l', 'k', 'j', 'h']
    return get(l:opposites, index(l:keys, a:direction))
endfunction

function! TmuxResize(direction, amount)
    " v >
    if (a:direction ==# 'j' || a:direction ==# 'l')
        if IsEdgeWindowSelected(a:direction)
            let l:opposite = GetOpposite(a:direction)
            let l:curwindow = winnr()
            exec 'wincmd '.l:opposite
            let l:action = GetAction(a:direction)
            exec l:action.a:amount
            exec l:curwindow.'wincmd w'
            return
        endif
    " < ^
    elseif (a:direction ==# 'h' || a:direction ==# 'k')
        let l:opposite = GetOpposite(a:direction)
        if IsEdgeWindowSelected(l:opposite)
            let l:curwindow = winnr()
            exec 'wincmd '.a:direction
            let l:action = GetAction(a:direction)
            exec l:action.a:amount
            exec l:curwindow.'wincmd w'
            return
        endif
    endif

    let l:action = GetAction(a:direction)
    exec l:action.a:amount
endfunction

" Map to Ctrl+hjkl to resize panes
nnoremap <M-S-h> :call TmuxResize('h', 1)<CR>
nnoremap <M-S-j> :call TmuxResize('j', 1)<CR>
nnoremap <M-S-k> :call TmuxResize('k', 1)<CR>
nnoremap <M-S-l> :call TmuxResize('l', 1)<CR>
