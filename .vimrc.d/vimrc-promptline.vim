"https://github.com/edkolev/promptline.vim
"
let g:promptline_theme = {
        \'a'      : [239, 4],
        \'b'      : [241, 12],
        \'c'      : [239, 245],
        \'x'      : [239, 243],
        \'y'      : [239, 6],
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
