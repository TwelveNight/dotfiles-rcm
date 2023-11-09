return {
  "p00f/nvim-ts-rainbow",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- 适用语言
      -- ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "java" },

      -- highlight = { enable = true },
      -- indent = { enable = true },

      -- 不同颜色分区的括号
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
      },
    })
  end,
}
