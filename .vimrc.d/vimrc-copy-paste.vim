" Settings for Copy & Paste
" =========================

" ALWAYS use the clipboard for ALL operations
" https://neovim.io/doc/user/nvim_clipboard.html#nvim-clipboard
set clipboard+=unnamedplus  " Thank you Neovim


" http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
" Automatically jump to end of text you pasted:
" paste multiple lines multiple times with simple ppppp.
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]
