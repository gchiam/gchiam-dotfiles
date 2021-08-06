-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:

local opt = vim.opt

-- General option
-- ===============
opt.wildmode = "list:longest"  -- make TAB behave like in a shell
opt.autoread = true  -- reload file when changes happen in other editors
-- opt.tags=./tags

opt.encoding = "utf-8"  -- The encoding displayed.
opt.fileencoding = "utf-8"  -- The encoding written to file.<F37>

opt.syntax = "on"

vim.g.html_indent_inctags = "html,body,head,tbody"
vim.g.html_indent_script1 = "inc"
vim.g.html_indent_style1 = "inc"

opt.mouse = "a"
opt.backspace = "2"  -- make backspace behave like normal again
opt.timeoutlen = 500
opt.wildignore:append("*.a")
opt.wildignore:append("*.class")
opt.wildignore:append("*.gif")
opt.wildignore:append("*.jpg")
opt.wildignore:append("*.la")
opt.wildignore:append("*.mo")
opt.wildignore:append("*.o")
opt.wildignore:append("*.obj")
opt.wildignore:append("*.png")
opt.wildignore:append("*.pyc")
opt.wildignore:append("*.so")
opt.wildignore:append("*.swp")
opt.wildignore:append("*.tags")
opt.wildignore:append("*.xpm")
opt.wildignore:append("*/coverage/*")
opt.wildignore:append("*_build/*")
opt.wildignore:append(".git")
opt.wildignore:append(".svn")
opt.wildignore:append("CVS")
opt.wildignore:append("tags")

--
-- Disable stupid backup and swap files - they trigger too many events
-- for file system watchers
opt.backup = false
opt.writebackup = false
opt.swapfile = false

opt.history = 700
opt.undolevels = 700

opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split"
opt.ignorecase = true
opt.smartcase = true

-- set fillchars=vert:⏐

opt.hidden = true  -- required by vim-ctrlspace

-- Better display for messages
opt.cmdheight = 2

-- Will have bad experience for diagnostic messages when it's default 4000.
opt.updatetime = 300

opt.wrap = false  -- don't automatically wrap on load
opt.textwidth = 79  -- width of document (used by gd)
-- opt.formatoptions.t = false  -- don't automatically wrap text when typing


-- set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor


-- vim.cmd "source ~/.vimrc.d/vimrc-tabs.vim"
-- vim.cmd "source ~/.vimrc.d/vimrc-terminal.vim"

