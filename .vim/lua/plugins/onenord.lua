use "rmehri01/onenord.nvim"

opt.termguicolors = true

require('onenord').setup({
  borders = true, -- Split window borders
  italics = {
    comments = true, -- Italic comments
    strings = true, -- Italic strings
    keywords = true, -- Italic keywords
    functions = false, -- Italic functions
    variables = false, -- Italic variables
  },
  disable = {
    background = false, -- Disable setting the background color
    cursorline = false, -- Disable the cursorline
    eob_lines = true, -- Hide the end-of-buffer lines
  },
  custom_highlights = {}, -- Overwrite default highlight groups
})

cmd([[
augroup MyOneNordColors
  autocmd ColorScheme onenord highlight Normal guibg=None
augroup END
]])
cmd("colorscheme onenord")
