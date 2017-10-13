scriptencoding utf-8

" References:
" https://bluz71.github.io/2017/06/28/current-treats-future-wants-of-neovim.html
" -----------------------------------------------------------------------------
"
"
" Make escape work in the Neovim terminal.
tnoremap <Esc> <C-\><C-n>

" Make navigation into and out of Neovim terminal splits nicer.
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l

augroup termgroup
    " I like relative numbering when in normal mode.
    autocmd TermOpen * setlocal conceallevel=0 colorcolumn=0 relativenumber

    " Prefer Neovim terminal insert mode to normal mode.
    autocmd BufEnter term://* startinsert

    " auto close buffer
    autocmd TermClose * bd!
augroup END
