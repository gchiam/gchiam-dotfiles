return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "weilbith/neotest-gradle",
  },
  opts = {
    adapters = {
      "neotest-gradle",
    },
    status = { virtual_text = true },
    output = { open_on_run = true },
    quickfix = {
      open = function()
        if LazyVim.has("trouble.nvim") then
          require("trouble").open({ mode = "quickfix", focus = false })
        else
          vim.cmd("copen")
        end
      end,
    },
  },
  config = function(_, opts)
    if LazyVim.has("trouble.nvim") then
      opts.consumers = {
        trouble = function(client)
          client.listeners.results = function(adapter_id, results, partial)
            if partial then
              return
            end
            local tree = assert(client:get_position(nil, { adapter = adapter_id }))

            local failed = 0
            for pos_id, result in pairs(results) do
              if result.status == "failed" and tree:get_key(pos_id) then
                failed = failed + 1
              end
            end
            vim.schedule(function()
              local trouble = require("trouble")
              if trouble.is_open() then
                trouble.refresh()
                if failed == 0 then
                  trouble.close()
                end
              end
            end)
            return {}
          end
        end,
      }
    end
    require("neotest").setup(opts)
  end,
  -- stylua: ignore
  keys = {
    { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
    { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
  },
}
