-- plugins/telescope.lua
-- Fuzzy finder for files, grep, buffers, help tags.
-- telescope-fzf-native is compiled with make (gcc required — see packages.txt).
-- Keybindings: <leader>ff  find files  |  <leader>fg  grep  |  <leader>fb  buffers

return {
  {
    "nvim-telescope/telescope.nvim",
    event        = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required async utility library
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- compiled C extension for faster sorting; skipped gracefully if make is absent
        build = "make",
        cond  = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          -- Sort results with the best match at the top
          layout_strategy  = "horizontal",
          layout_config    = { prompt_position = "top" },
          sorting_strategy = "ascending",
          -- Don't search inside .git or node_modules
          file_ignore_patterns = { "%.git/", "node_modules/" },
        },
        pickers = {
          find_files = {
            hidden = true, -- include dotfiles in file search
          },
        },
      })

      -- Load the fzf extension (pcall so nvim starts even if make failed)
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
