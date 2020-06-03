scriptencoding utf-8


" Color scheme
" =============
set background=dark

set termguicolors

" http://tilvim.com/2013/07/31/swapping-bg.html
map <Leader>bg :let &background = ( &background == "dark"? "light" : "dark" )<CR>
" map <Leader>tb :highlight Normal guibg=None ctermbg=None<CR> :highlight NonText guibg=None ctermbg=None<CR>
"
set colorcolumn=80

if (!exists("$VIM_COLORSCHEME"))
    let $VIM_COLORSCHEME='nord'
endif
source ~/.vimrc.d/vimrc-colorscheme-$VIM_COLORSCHEME.vim
" source ~/.vimrc.d/vimrc-gruvbox.vim
" source ~/.vimrc.d/vimrc-srcery.vim

" highlight TermCursor ctermfg=red guifg=red
" highlight CursorLineNr ctermbg=None guibg=None
" augroup gruvbox
"    au ColorScheme gruvbox highlight CursorLineNr ctermbg=None guibg=None
" augroup END

" Making background transparent
" https://www.reddit.com/r/neovim/comments/3v06lo/making_the_background_transparent/
" highlight Normal guibg=None
" au ColorScheme * highlight Normal ctermbg=None guibg=None
