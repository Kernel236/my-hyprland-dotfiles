-- init.lua
-- Entry point: bootstraps lazy.nvim, loads core modules, then all plugins.

-- ── Bootstrap lazy.nvim ───────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "Warn" },
      { "\nPress any key to exit...", "ErrorMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ── Core modules (before plugins so keymaps/options are always set) ───────────
require("options")
require("keymaps")

-- ── Load all plugins from lua/plugins/ ───────────────────────────────────────
require("lazy").setup("plugins", {
  checker = { enabled = false },        -- no automatic update notifications
  change_detection = { notify = false }, -- no config-change notifications
})
