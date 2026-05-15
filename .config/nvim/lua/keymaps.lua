-- keymaps.lua
-- Global keybindings. LSP and Telescope shortcuts are here too so they're
-- visible in one place; they activate even before those plugins load.

local map = vim.keymap.set

-- ── Leader key ────────────────────────────────────────────────────────────────
vim.g.mapleader      = " "   -- Space as leader (must be set before lazy)
vim.g.maplocalleader = "\\"  -- backslash as local leader

-- ── Window navigation ─────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })

-- ── Buffer navigation ─────────────────────────────────────────────────────────
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", ":bnext<CR>",     { desc = "Next buffer" })

-- ── Misc ──────────────────────────────────────────────────────────────────────
map("n", "<Esc>",      ":nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>w",  ":write<CR>",      { desc = "Save file" })
map("n", "<leader>q",  ":quit<CR>",       { desc = "Quit" })

-- Wrapped-line-aware j/k (moves by visual line, not logical line)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up" })

-- Stay in visual mode after indenting
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- ── Telescope ─────────────────────────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",   { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",     { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",   { desc = "Help tags" })

-- ── LSP (active when a server attaches to the current buffer) ─────────────────
map("n", "gd",         vim.lsp.buf.definition,  { desc = "Go to definition" })
map("n", "gr",         vim.lsp.buf.references,  { desc = "Go to references" })
map("n", "K",          vim.lsp.buf.hover,        { desc = "Hover docs" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>rn", vim.lsp.buf.rename,       { desc = "Rename symbol" })
map("n", "[d",         vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d",         vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>e",  vim.diagnostic.open_float, { desc = "Show diagnostic float" })
