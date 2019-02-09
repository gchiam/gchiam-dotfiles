" Asynchronous Lint Engine - ALE
" https://github.com/w0rp/ale
"==============================================================================
scriptencoding utf-8


let g:ale_sign_column_always = 1
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']

highlight clear ALEErrorSign
highlight clear ALEWarningSign

let &runtimepath.=',~/.vim/bundle/ale'

let g:ale_sign_error='●'
let g:ale_sign_warning='●'

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_python_flake8_args='--ignore=W191,D203,D206,C0330,W0312'
let g:ale_python_flake8_options='--ignore=W191,D203,D206,C0330,W0312'

nmap <leader>k <Plug>(ale_previous_wrap)
nmap <leader>j <Plug>(ale_next_wrap)
nmap <c-m-k> <Plug>(ale_previous_wrap)
nmap <c-m-j> <Plug>(ale_next_wrap)
