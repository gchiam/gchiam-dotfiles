scriptencoding utf-8


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
"map <F7> <esc>:SyntasticCheck<CR>
"map <F8> <esc>:SyntasticToggleMode<CR>
