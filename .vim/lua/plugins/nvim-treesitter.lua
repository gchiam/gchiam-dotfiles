use {
  "nvim-treesitter/nvim-treesitter",
    config = function()
      vim.cmd(":TSUpdate")
    end,
}

require("nvim-treesitter.configs").setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
