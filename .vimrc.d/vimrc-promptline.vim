"https://github.com/edkolev/promptline.vim
"
let g:promptline_theme = {
        \'a'      : [0, 166],
        \'b'      : [0, 4],
        \'c'      : [0, 8],
        \'x'      : [0, 15],
        \'y'      : [0, 6],
        \'z'      : [0, 7],
        \'warn'   : [15, 1]}

let g:promptline_preset = {
    \'a' : [ promptline#slices#host() ],
    \'b' : [ '$USER'],
    \'c' : [ promptline#slices#cwd() ],
    \'x' : [ promptline#slices#python_virtualenv() ],
    \'y' : [ promptline#slices#vcs_branch() ],
    \'z' : [ promptline#slices#git_status() ],
    \'warn' : [ promptline#slices#last_exit_code() ]}
