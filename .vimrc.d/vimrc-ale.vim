" Asynchronous Lint Engine - ALE
" https://github.com/w0rp/ale
"==============================================================================
scriptencoding utf-8

let &runtimepath.=',~/.vim/bundle/ale'

let g:ale_sign_error='⚡︎'
let g:ale_sign_warning='⚑'

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

nmap <leader>k <Plug>(ale_previous_wrap)
nmap <leader>j <Plug>(ale_next_wrap)
nmap <c-m-k> <Plug>(ale_previous_wrap)
nmap <c-m-j> <Plug>(ale_next_wrap)