-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local del = vim.keymap.del
local map = vim.keymap.set

-- resizing
del("n", "<C-Up>")
del("n", "<C-Down>")
del("n", "<C-Left>")
del("n", "<C-Right>")

map("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- floating terminal
del("n", "<leader>ft")
del("n", "<leader>fT")
del("n", "<c-/>")
del("n", "<c-_>")
del("t", "<C-/>")

-- map("n", "<c-t>", function()
--   LazyVim.terminal(nil, { cwd = LazyVim.root() })
-- end, { desc = "Terminal (Root Dir)" })
-- map("t", "<c-t>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- windows
map("n", "<leader>v", "<C-W>v", { desc = "Split Window Right", remap = true })

-- tabs
del("n", "<leader><tab>l")
del("n", "<leader><tab>o")
del("n", "<leader><tab>f")
del("n", "<leader><tab><tab>")
del("n", "<leader><tab>]")
del("n", "<leader><tab>d")
del("n", "<leader><tab>[")

-- diagnostic
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- buffer begone
map("n", "<leader>k", "<C-w>c", { desc = "Close Buffer" })

-- quick quickfixin
map("n", "<C-\\>", ":cnext<CR>zz", { silent = true })
map("n", "<C-]>", ":cprev<CR>zz", { silent = true })

-- Switchin
map("n", "<leader>n", "<C-^>")

-- Shut up copoilot
map("n", "<leader>uz", "<cmd>Copilot disable<cr>", { desc = "Disable Copilot" })
map("n", "<leader>ux", "<cmd>Copilot enable<cr>", { desc = "Enable Copilot" })
