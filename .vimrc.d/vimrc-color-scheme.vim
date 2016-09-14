scriptencoding utf-8


" Color scheme
" =============
set background=dark

" tmux doesn't support true color, so need to install a patched version of tmux
" brew install https://raw.githubusercontent.com/choppsv1/homebrew-term24/master/tmux.rb
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" http://tilvim.com/2013/07/31/swapping-bg.html
map <Leader>bg :let &background = ( &background == "dark"? "light" : "dark" )<CR>

"
set colorcolumn=80

source ~/.vimrc.d/vimrc-gruvbox.vim

highlight TermCursor ctermfg=red guifg=red

" Making background transparent
" https://www.reddit.com/r/neovim/comments/3v06lo/making_the_background_transparent/
" highlight Normal guibg=none
" au ColorScheme * highlight Normal ctermbg=none guibg=none
