return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        window = {
          mappings = {
            ["."] = "toggle_hidden",
            ["H"] = "set_root",
          },
        },
      },
      window = {
        mappings = {
          ["l"] = "open",
          ["o"] = "open",
          ["h"] = "close_node",
        },
      },
    },
  },
}
