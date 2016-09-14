scriptencoding utf-8


"https://github.com/edkolev/promptline.vim
"
let g:promptline_theme = {
        \'a'      : [239, 4],
        \'b'      : [235, 12],
        \'c'      : [15, 245],
        \'x'      : [234, 5],
        \'y'      : [234, 3],
        \'z'      : [239, 14],
        \'warn'   : [239, 9]}

let g:promptline_preset = {
    \'a' : [ promptline#slices#host() ],
    \'b' : [ '$USER'],
    \'c' : [ promptline#slices#cwd() ],
    \'x' : [ promptline#slices#python_virtualenv() ],
    \'y' : [ promptline#slices#vcs_branch() ],
    \'z' : [ promptline#slices#git_status() ],
    \'warn' : [ promptline#slices#last_exit_code() ]}
