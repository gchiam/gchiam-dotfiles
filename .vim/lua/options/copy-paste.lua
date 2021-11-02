-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:


-- Settings for Copy & Paste
-- =========================

-- ALWAYS use the clipboard for ALL operations
-- https://neovim.io/doc/user/nvim_clipboard.html#nvim-clipboard
opt.clipboard:append("unnamedplus")  -- Thank you Neovim


-- http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
-- Automatically jump to end of text you pasted:
-- paste multiple lines multiple times with simple ppppp.
vmap('<silent>y', 'y`]')
vmap('<silent>p', 'p`]')
nmap('<silent>p', 'p`]')
