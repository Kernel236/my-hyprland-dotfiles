-- plugins/treesitter.lua
-- Syntax highlighting and indentation via tree-sitter grammars.
-- Parsers for all target languages are auto-installed on first launch.
-- `build = ":TSUpdate"` keeps parsers updated when the plugin is updated.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main  = "nvim-treesitter.configs", -- tells lazy which module to call setup() on
    opts  = {
      ensure_installed = {
        -- Target languages
        "r", "python", "lua", "bash", "c",
        "html", "css",
        -- Common support parsers (config files, docs, nvim itself)
        "javascript", "json", "yaml", "toml",
        "markdown", "markdown_inline",
        "vim", "vimdoc",
      },

      highlight = {
        enable = true,
        -- Disable vim's regex-based highlighting when tree-sitter is active
        -- (avoids double-highlighting and slowdowns in large files)
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true, -- use tree-sitter for auto-indentation (replaces smartindent)
      },

      auto_install = true, -- silently install any missing parser when opening a file
    },
  },
}
