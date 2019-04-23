scriptencoding utf-8


let g:spacegray_use_italics = 1
let g:spacegray_low_contrast = 1

au ColorScheme spacegray highlight Normal guibg=None
au ColorScheme spacegray highlight ALEErrorSign guifg=#cc241d guibg=#111314
au ColorScheme spacegray highlight ALEWarningSign guifg=#d79921 guibg=#111314

" Copied from https://github.com/ajh17/Spacegray.vim/pull/13/files<Paste>
let s:yellow  = [ '#e8a96e', 0 ]
let s:red     = [ '#bf6162', 1 ]
let s:blue    = [ '#789aad', 2 ]
let s:green   = [ '#a1a464', 3 ]

let s:gray0 = [ '#111314', 4 ]
let s:gray1 = [ '#393d42', 5 ]
let s:gray2 = [ '#5d6269', 6 ]
let s:gray3 = [ '#b3b8c4', 7 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [ [ s:gray0, s:green ], [ s:gray3, s:gray2 ] ]
let s:p.normal.middle = [ [ s:gray3, s:gray1 ] ]
let s:p.normal.right = [ [ s:gray0, s:gray3 ], [ s:gray3, s:gray2 ] ]

let s:p.normal.error = [ [ s:gray0, s:red ] ]
let s:p.normal.warning = [ [ s:gray0, s:yellow ] ]

let s:p.inactive.left =  [ [ s:gray3, s:gray2 ], [ s:gray3, s:gray2 ] ]
let s:p.inactive.middle = [ [ s:gray3, s:gray1 ] ]
let s:p.inactive.right = [ [ s:gray0, s:gray3 ], [ s:gray3, s:gray2 ] ]

let s:p.insert.left = [ [ s:gray0, s:blue ], [ s:gray3, s:gray2 ] ]
let s:p.replace.left = [ [ s:gray0, s:red ], [ s:gray3, s:gray2 ] ]
let s:p.visual.left = [ [ s:gray0, s:yellow ], [ s:gray3, s:gray2 ] ]

let s:p.tabline.left = [ [ s:gray2, s:gray1] ]
let s:p.tabline.tabsel = [ [ s:gray3, s:gray2 ] ]
let s:p.tabline.middle = [ [ s:gray2, s:gray1] ]
let s:p.tabline.right = [ [ s:gray0, s:gray3 ] ]

let g:lightline#colorscheme#spacegray#palette = lightline#colorscheme#flatten(s:p)

let g:lightline_colorscheme = "spacegray"

colorscheme spacegray
