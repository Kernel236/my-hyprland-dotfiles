-- options.lua
-- Global Neovim options. All plugin-specific options live in their own file.

local opt = vim.opt

-- ── Line numbers ──────────────────────────────────────────────────────────────
opt.number         = true   -- show absolute line number on current line
opt.relativenumber = true    -- show relative numbers on all other lines

-- ── Indentation ───────────────────────────────────────────────────────────────
opt.tabstop    = 2     -- a tab counts as 2 spaces
opt.shiftwidth = 2     -- >> and << shift by 2
opt.expandtab  = true  -- insert spaces instead of tab chars
opt.smartindent = true -- auto-indent new lines based on syntax

-- ── Appearance ────────────────────────────────────────────────────────────────
opt.termguicolors = true      -- enable 24-bit RGB colors (required by catppuccin)
opt.signcolumn    = "yes"     -- always show the sign column (prevents layout shift)
opt.cursorline    = true      -- highlight the line the cursor is on
opt.scrolloff     = 8         -- keep 8 lines visible above/below the cursor
opt.sidescrolloff = 8         -- keep 8 columns visible left/right of the cursor
opt.wrap          = false     -- don't soft-wrap long lines

-- ── Search ────────────────────────────────────────────────────────────────────
opt.ignorecase = true  -- case-insensitive search...
opt.smartcase  = true  -- ...unless the query contains uppercase
opt.hlsearch   = false -- don't keep matches highlighted after searching
opt.incsearch  = true  -- show matches as you type

-- ── File handling ─────────────────────────────────────────────────────────────
opt.swapfile = false  -- no swap files (we use undofile instead)
opt.backup   = false  -- no backup files
opt.undofile = true   -- persistent undo history across sessions

-- ── Splits ────────────────────────────────────────────────────────────────────
opt.splitright = true  -- vertical splits open to the right
opt.splitbelow = true  -- horizontal splits open below

-- ── Clipboard ────────────────────────────────────────────────────────────────
opt.clipboard = "unnamedplus"  -- use the system clipboard for all yank/paste ops

-- ── Performance ───────────────────────────────────────────────────────────────
opt.updatetime = 250   -- faster CursorHold events (used by LSP hover/diagnostics)
opt.timeoutlen = 300   -- ms to wait for a mapped key sequence to complete
