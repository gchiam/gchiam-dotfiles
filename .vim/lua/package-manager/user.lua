-- vim: set tabstop=2 softtabstop=2 shiftwidth=2 expandtab:

-- https://github.com/faerryn/user.nvim

local user_packadd_path = "faerryn/user.nvim/default"
local user_install_path = vim.fn.stdpath("data").."/site/pack/user/opt/"..user_packadd_path
if vim.fn.isdirectory(user_install_path) == 0 then
  os.execute("git clone --quiet --depth 1 https://github.com/faerryn/user.nvim.git "..vim.fn.shellescape(user_install_path))
end

vim.api.nvim_command("packadd "..vim.fn.fnameescape(user_packadd_path))

local user = require("user")
user.setup()
use = user.use

-- user.nvim can manage itself!
use "faerryn/user.nvim"
