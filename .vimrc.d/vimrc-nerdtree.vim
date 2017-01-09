scriptencoding utf-8


" NerdTree
" ========
nnoremap <F5> :NERDTreeToggle<CR>
inoremap <F5> <C-O>:NERDTreeToggle<CR>
vnoremap <F5> :NERDTreeToggle<CR>

let NERDTreeIgnore = ['\.pyc$']

" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

