return {
  -- "p00f/nvim-ts-rainbow",
  -- config = function()
  --   require("nvim-treesitter.configs").setup({
  --     -- 适用语言
  --     -- ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "java" },
  --
  --     -- highlight = { enable = true },
  --     -- indent = { enable = true },
  --
  --     -- 不同颜色分区的括号
  --     rainbow = {
  --       enable = true,
  --       extended_mode = true,
  --       max_file_lines = nil,
  --     },
  --   })
  -- end,
  "HiPhish/rainbow-delimiters.nvim",
  config = function()
    local rainbow_delimiters = require("rainbow-delimiters")
    strategy = {
      [""] = rainbow_delimiters.strategy["global"],
      vim = rainbow_delimiters.strategy["local"],
    }
    query = {
      [""] = "rainbow-delimiters",
      lua = "rainbow-blocks",
    }
    priority = {
      [""] = 110,
      lua = 210,
    }
    highlight = {
      "RainbowDelimiterRed",
      "RainbowDelimiterYellow",
      "RainbowDelimiterBlue",
      "RainbowDelimiterOrange",
      "RainbowDelimiterGreen",
      "RainbowDelimiterViolet",
      "RainbowDelimiterCyan",
    }
  end,
}
