" Color scheme
" =============
set t_Co=256
set background=dark

" tmux doesn't support true color, so need to install a patched version of tmux
" brew install https://raw.githubusercontent.com/choppsv1/homebrew-term24/master/tmux.rb
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" http://tilvim.com/2013/07/31/swapping-bg.html
map <Leader>bg :let &background = ( &background == "dark"? "light" : "dark" )<CR>

"
"let g:base16_shell_path="~/dotfiles/external/base16-shell"
"let base16colorspace=256
"colorscheme base16-tomorrow
"colorscheme PaperColor
"colorscheme hybrid_material

set colorcolumn=80

source ~/.vimrc.d/vimrc-gruvbox.vim

" Making background transparent
" https://www.reddit.com/r/neovim/comments/3v06lo/making_the_background_transparent/
highlight Normal guibg=none
au ColorScheme * highlight Normal ctermbg=none guibg=none

highlight Search ctermfg=232
highlight Visual ctermfg=15 ctermbg=24
autocmd ColorScheme * highlight Visual ctermfg=15 ctermbg=24

highlight CursorColumn ctermfg=7 guifg=white guibg=grey20
highlight DiffAdd cterm=none ctermbg=194 ctermfg=244
highlight DiffDelete cterm=none ctermbg=210 ctermfg=232
highlight DiffChange cterm=none ctermbg=229 ctermfg=232
highlight DiffText cterm=none ctermbg=3 ctermfg=232
