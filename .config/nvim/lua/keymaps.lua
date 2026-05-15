-- keymaps.lua
-- Global keybindings and LSP buffer-local keybindings in one place.
-- LSP mappings are registered via LspAttach so they only apply to buffers
-- where a language server is active (preserves K, gd, etc. in help/Mason/terminal).

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

-- ── NvimTree ──────────────────────────────────────────────────────────────────
map("n", "<leader>t",  "<cmd>NvimTreeToggle<cr>",   { desc = "Toggle file tree" })
map("n", "<leader>tf", "<cmd>NvimTreeFocus<cr>",    { desc = "Focus file tree" })

-- ── Telescope ─────────────────────────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",   { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",     { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",   { desc = "Help tags" })

-- ── LSP (buffer-local, registered when a server attaches) ────────────────────
-- Scoped to the attached buffer so global keys like K (help tag) are not overridden
-- in non-code buffers (help pages, Mason UI, terminal, etc.).
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    map("n", "gd",         vim.lsp.buf.definition,   vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    map("n", "gr",         vim.lsp.buf.references,   vim.tbl_extend("force", opts, { desc = "Go to references" }))
    map("n", "K",          vim.lsp.buf.hover,         vim.tbl_extend("force", opts, { desc = "Hover docs" }))
    map("n", "<leader>ca", vim.lsp.buf.code_action,  vim.tbl_extend("force", opts, { desc = "Code action" }))
    map("n", "<leader>rn", vim.lsp.buf.rename,        vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    map("n", "[d",         vim.diagnostic.goto_prev,  vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    map("n", "]d",         vim.diagnostic.goto_next,  vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
    map("n", "<leader>e",  vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostic float" }))
  end,
})
