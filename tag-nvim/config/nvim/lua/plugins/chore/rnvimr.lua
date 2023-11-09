return {
  "kevinhwang91/rnvimr",
  cmd = "RnvimrToggle",
  config = function()
    vim.g.rnvimr_draw_border = 1
    vim.g.rnvimr_pick_enable = 1
    vim.g.rnvimr_bw_enable = 1
  end,
  keys = {
    { "<M-o>", ":RnvimrToggle<CR>", desc = "ranger toggle" },
    { "<M-/>", ":RnvimrResize<CR>", desc = "ranger resize" },
  },
}
