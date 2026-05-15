-- plugins/colorscheme.lua
-- Catppuccin Macchiato with transparent background.
-- Opacity and blur are managed by Hyprland on the kitty window —
-- Neovim intentionally sets no background color.

return {
  "catppuccin/nvim",
  name     = "catppuccin",
  priority = 1000, -- load before all other plugins so colors are set first
  opts = {
    flavour                = "macchiato",
    transparent_background = true, -- removes Normal bg; Hyprland blur shows through
    integrations = {
      cmp             = true,
      gitsigns        = true,
      telescope       = { enabled = true },
      treesitter      = true,
      mason           = true,
      indent_blankline = { enabled = true },
      nvimtree        = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")

    -- Belt-and-suspenders: clear any bg that catppuccin might leave on floats
    vim.api.nvim_set_hl(0, "Normal",      { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC",    { bg = "none" })
  end,
}
