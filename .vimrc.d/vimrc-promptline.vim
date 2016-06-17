"https://github.com/edkolev/promptline.vim
"
let g:promptline_theme = {
        \'a'      : [241, 166],
        \'b'      : [241, 4],
        \'c'      : [7, 245],
        \'x'      : [7, 243],
        \'y'      : [243, 6],
        \'z'      : [243, 14],
        \'warn'   : [15, 1]}

let g:promptline_preset = {
    \'a' : [ promptline#slices#host() ],
    \'b' : [ '$USER'],
    \'c' : [ promptline#slices#cwd() ],
    \'x' : [ promptline#slices#python_virtualenv() ],
    \'y' : [ promptline#slices#vcs_branch() ],
    \'z' : [ promptline#slices#git_status() ],
    \'warn' : [ promptline#slices#last_exit_code() ]}
