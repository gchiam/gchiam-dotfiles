scriptencoding utf-8


let g:spacegray_use_italics = 1
let g:spacegray_low_contrast = 1

let g:lightline_colorscheme = 'base16_grayscale'

au ColorScheme spacegray highlight Normal guibg=None
au ColorScheme spacegray highlight ALEErrorSign guifg=#cc241d guibg=#111314
au ColorScheme spacegray highlight ALEWarningSign guifg=#d79921 guibg=#111314

colorscheme spacegray
