-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
-- local noremap = true, silent = true = { noremap = true, silent = true }
-- back
keymap.set("i", "jk", "<Esc>")

-- move
keymap.set("i", "<C-j>", "<Down>", { noremap = true, silent = true, desc = "down" })
keymap.set("i", "<C-p>", "<Up>", { noremap = true, silent = true, desc = "up" })
keymap.set("i", "<C-h>", "<Left>", { noremap = true, silent = true, desc = "left" })
keymap.set("i", "<C-l>", "<Right>", { noremap = true, silent = true, desc = "right" })
keymap.set("i", "<C-e>", "<End>", { noremap = true, silent = true, desc = "end" })
keymap.set("i", "<C-a>", "<Home>", { noremap = true, silent = true, desc = "home" })

keymap.set("n", "L", "$", { desc = "home" })
keymap.set("n", "H", "^", { desc = "end" })

-- Redo
keymap.set("n", "U", "<C-r>", { noremap = true, silent = true, desc = "Redo" })

-- buffer
keymap.set("n", "tp", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
keymap.set("n", "tn", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap.set("n", "E", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
keymap.set("n", "R", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Move Lines
keymap.set("v", "<S-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
keymap.set("v", "<S-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- sniprun
keymap.set("n", "<leader>rr", ":%SnipRun<cr>", { noremap = true, silent = true, desc = "sniprun" })
keymap.set("v", "<leader>rr", ":%SnipRun<cr>", { noremap = true, silent = true, desc = "sniprun" })
keymap.set("n", "<leader>rc", "<cmd>SnipClose<cr>", { noremap = true, silent = true, desc = "snipclose" })
keymap.set("v", "<leader>rc", ":<cmd>SnipClose<cr>", { noremap = true, silent = true, desc = "snipclose" })

-- chatgpt
--keymap.set("n", "<leader>ge", "<cmd>ChatGPTEditWithInstructions<cr>")

-- set telescope keymaps
keymap.set(
  "n",
  "<leader>sx",
  require("telescope.builtin").resume,
  { noremap = true, silent = true, desc = "Resume Last Telescope Picker" }
)

keymap.set(
  { "n", "v" },
  "T",
  "<cmd>TranslateW --engines=bing<cr>",
  { noremap = true, silent = true, desc = "Translate Word" }
)

--debug
keymap.set("n", "<F9>", function()
  require("dap").run_last()
end, { noremap = true, silent = true, desc = "run last" })

keymap.set("n", "<F10>", function()
  require("dap").restart()
end, { noremap = true, silent = true, desc = "restart" })

keymap.set("n", "<F4>", function()
  require("dap").terminate()
end, { noremap = true, silent = true, desc = "terminate" })

keymap.set("n", "<F5>", function()
  require("dap").continue()
end, { noremap = true, silent = true, desc = "continue" })

keymap.set("n", "<F6>", function()
  require("dap").step_over()
end, { noremap = true, silent = true, desc = "step_over" })

keymap.set("n", "<F7>", function()
  require("dap").step_into()
end, { noremap = true, silent = true, desc = "step_into" })

keymap.set("n", "<F8>", function()
  require("dap").step_out()
end, { noremap = true, silent = true, desc = "step_out" })

-- lspsaga
keymap.set("n", "<leader>k", "<cmd>Lspsaga hover_doc<CR>", { noremap = true, silent = true, desc = "hover_doc" })
keymap.set(
  "n",
  "<leader>ci",
  "<cmd>:Lspsaga incoming_calls<cr>",
  { noremap = true, silent = true, desc = "incoming_calls" }
)
keymap.set(
  "n",
  "<leader>co",
  "<cmd>Lspsaga outgoing_calls<cr>",
  { noremap = true, silent = true, desc = "outgoing_calls" }
)
