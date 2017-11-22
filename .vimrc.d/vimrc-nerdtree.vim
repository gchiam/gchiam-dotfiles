" Settings for NERDTRee
"
" https://github.com/scrooloose/nerdtree
" ======================================
"
map <F7> :NERDTreeToggle<CR>


" Open a NERDTree automatically when vim starts up if no files were specified?
" -----------------------------------------------------------------------------
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"
"
" Open NERDTree automatically when vim starts up on opening a directory?
" -----------------------------------------------------------------------------
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif


" Close vim if the only window left open is a NERDTree?
" -----------------------------------------------------------------------------
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
