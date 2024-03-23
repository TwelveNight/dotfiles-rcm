-- ~/.config/nvim/lua/plugins/cmp.lua
return {
  {
    "nvim-cmp",
    opts = function(_, opts)
      opts.formatting.format = function(_, item)
        local icons = require("lazyvim.config").icons.kinds
        if icons[item.kind] then
          item.kind = icons[item.kind] .. item.kind
        end
        item.menu = nil
        return item
      end
    end,
  },
}
