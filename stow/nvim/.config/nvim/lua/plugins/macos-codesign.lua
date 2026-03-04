-- macOS code signing workaround for linker-signed native libraries.
-- On macOS 26.3+ (Apple Silicon), the kernel rejects linker-signed .so/.dylib
-- files after they are replaced in-place by plugin updates, sending SIGKILL
-- to nvim. Re-signing with an ad-hoc signature fixes the page hash mismatch.
-- See: https://github.com/nvim-treesitter/nvim-treesitter/issues/8530

local function resign_parsers()
  if vim.fn.has("mac") == 0 then
    return
  end
  local data = vim.fn.stdpath("data")
  local dirs = {
    data .. "/lazy/nvim-treesitter/parser",
    data .. "/site/parser",
  }
  for _, dir in ipairs(dirs) do
    for _, f in ipairs(vim.fn.glob(dir .. "/*.so", false, true)) do
      vim.fn.system({ "codesign", "--force", "--sign", "-", f })
    end
  end
end

return {
  -- Re-sign treesitter parsers whenever TSUpdate fires (manual :TSUpdate runs
  -- and lazy plugin updates both trigger this event).
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = resign_parsers,
      })
    end,
  },

  -- Re-sign blink.cmp's Rust fuzzy-match library after lazy plugin updates.
  {
    "saghen/blink.cmp",
    build = function()
      if vim.fn.has("mac") == 0 then
        return
      end
      local lib = vim.fn.stdpath("data") .. "/lazy/blink.cmp/target/release/libblink_cmp_fuzzy.dylib"
      if vim.fn.filereadable(lib) == 1 then
        vim.fn.system({ "codesign", "--force", "--sign", "-", lib })
      end
    end,
  },
}
