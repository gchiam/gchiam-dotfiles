" IndentGuides
" ==========================
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2

" Highlight for IndentGuides
" ==========================
highlight IndentGuidesOdd ctermbg=235
highlight IndentGuidesEven ctermbg=237
autocmd ColorScheme * highlight IndentGuidesOdd ctermbg=235
autocmd ColorScheme * highlight IndentGuidesEven ctermbg=237
