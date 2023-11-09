-- return {
--   "ldelossa/litee-calltree.nvim",
--   dependencies = {
--     "ldelossa/litee.nvim",
--   },
--
--   config = function()
--     local status_ok, litee_lib = pcall(require, "litee.lib")
--     if not status_ok then
--       vim.notify("litee_lib not found!")
--       return
--     end
--
--     local status_ok, litee_calltree = pcall(require, "litee.calltree")
--     if not status_ok then
--       vim.notify("litee_calltree not found!")
--       return
--     end
--     -- 确保 "litee.calltree" 成功加载后再进行设置
--     litee_lib.setup({
--       panel = {
--         orientation = "right",
--         panel_size = 50,
--       },
--     })
--
--     -- configure litee-calltree.nvim
--     -- commands: LTOpenToCalltree to open calltree
--     litee_calltree.setup({
--       -- NOTE: the plugin is in-progressing
--       on_open = "panel", -- panel | popout
--       hide_cursor = false,
--       keymaps = {
--         expakd = "o",
--         collapse = "zc",
--         collapse_all = "zM",
--         jump = "<CR>",
--         jump_split = "s",
--         jump_vsplit = "v",
--         jump_tab = "t",
--         hover = "i",
--         details = "d",
--         close = "X",
--         close_panel_pop_out = "<C-c>",
--         help = "?",
--         hide = "H",
--         switch = "S",
--         focus = "f",
--       },
--     })
--   end,
--
--   keys = {
--     { "<leader>ct", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>", desc = "calltree" },
--   },
-- }

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<leader>ct", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>", desc = "LiteeCalltree" }
    end,
  },
  {
    "ldelossa/litee-calltree.nvim",
    dependencies = {
      {
        "ldelossa/litee.nvim",
        config = function()
          require("litee.lib").setup({
            panel = {
              orientation = "right",
              panel_size = 30,
            },
          })
        end,
      },
    },
    config = function()
      require("litee.calltree").setup({
        -- hide_cursor = false,
        resolve_symbols = false,
      })
    end,
  },
}
