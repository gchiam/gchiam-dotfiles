scriptencoding utf-8


"https://github.com/edkolev/promptline.vim
"
let g:promptline_theme = {
        \'a'      : [0, 11],
        \'b'      : [0, 3],
        \'c'      : [0, 7],
        \'x'      : [0, 6],
        \'y'      : [0, 10],
        \'z'      : [0, 2],
        \'warn'   : [0, 9]}

let g:promptline_preset = {
    \'a' : [ promptline#slices#host() ],
    \'b' : [ '$USER'],
    \'c' : [ promptline#slices#cwd() ],
    \'x' : [ promptline#slices#python_virtualenv() ],
    \'y' : [ promptline#slices#vcs_branch() ],
    \'z' : [ promptline#slices#git_status() ],
    \'warn' : [ promptline#slices#last_exit_code() ]}
