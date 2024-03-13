return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
      table.insert(opts.sources, { name = "natdat" })
      table.insert(opts.sources, { name = "dictionary", keyword_length = 2 })
      -- vim.api.nvim_set_hl(0, "PopMenu", { bg = "#1F2335", blend = 0 })
      local cmp = require("cmp")
      local win_opt = {
        col_offset = 0,
        side_padding = 1,
        winhighlight = "Normal:PopMenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      }
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<C-t>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      })
      opts.window = {
        completion = cmp.config.window.bordered(win_opt),
        documentation = cmp.config.window.bordered(win_opt),
      }
      opts.experimental = {
        ghost_text = true,
      }
    end,
  },
}
