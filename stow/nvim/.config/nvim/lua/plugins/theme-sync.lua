return {
  {
    "LazyVim/LazyVim",
    opts = function()
      local state_file = "/tmp/catppuccin_flavor"

      local function sync_theme()
        local f = io.open(state_file, "r")
        if f then
          local flavor = f:read("*all"):gsub("%s+", "")
          f:close()
          if flavor == "frappe" or flavor == "mocha" or flavor == "macchiato" then
            vim.o.background = "dark"
          elseif flavor == "latte" then
            vim.o.background = "light"
          end
        end
      end

      -- Initial sync
      sync_theme()

      -- Watch for changes using libuv
      local w = vim.loop.new_fs_event()
      local function watch()
        w:start(
          state_file,
          {},
          vim.schedule_wrap(function(err)
            if err then
              return
            end
            sync_theme()
          end)
        )
      end

      watch()
    end,
  },
}
