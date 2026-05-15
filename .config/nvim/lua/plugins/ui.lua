-- plugins/ui.lua
-- Status line and indentation guides.
--   lualine         → bottom status bar with catppuccin theme
--   indent-blankline → vertical lines on indent levels

return {
  -- ── Status line ─────────────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme              = "catppuccin-mocha", -- matches the colorscheme
        globalstatus       = true,         -- one statusline for all windows
        -- Powerline-style separators (require a Nerd Font — already in packages.txt)
        section_separators = { left = "", right = "" },
        component_separators = "|",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } }, -- 1 = relative path
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ── Indentation guides ───────────────────────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",  -- v3 API: the module is `ibl`, not `indent_blankline`
    opts = {
      indent = {
        char = "│", -- thin vertical bar; catppuccin colors it via the IblIndent hl group
      },
      scope = {
        enabled = true, -- highlight the current indent scope differently
      },
    },
  },
}
