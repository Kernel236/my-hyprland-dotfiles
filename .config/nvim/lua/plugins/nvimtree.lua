-- plugins/nvimtree.lua
-- File explorer with icons. Requires a Nerd Font (JetBrainsMono / FiraCode — already installed).
-- Toggle: <leader>t   Focus without closing: <leader>tf
-- netrw is disabled in options.lua (nvim-tree replaces it).

return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- file type icons
    config = function()
      require("nvim-tree").setup({
        -- Show git status indicators on files and folders
        git = { enable = true },

        renderer = {
          -- Show icons for files, folders, and git status
          icons = {
            show = {
              file        = true,
              folder      = true,
              folder_arrow = true,
              git         = true,
            },
          },
          -- Highlight files by git status (requires catppuccin integration)
          highlight_git = true,
        },

        -- Close the tree automatically when opening a file
        actions = {
          open_file = {
            quit_on_open = false, -- keep tree open after opening a file
            window_picker = { enable = true },
          },
        },

        -- Filters: show dotfiles, hide .git directory
        filters = {
          dotfiles = false, -- show dotfiles (e.g. .env, .gitignore)
          custom   = { "^.git$" },
        },

        view = {
          width = 35,
          side  = "left",
        },
      })
    end,
  },
}
