-- plugins/lsp.lua
-- Full LSP stack:
--   mason              → installs LSP server binaries
--   mason-lspconfig    → bridges mason ↔ nvim-lspconfig
--   mason-tool-installer → auto-installs specific servers on startup
--   nvim-lspconfig     → configures each language client

return {
  -- ── Mason: server package manager ──────────────────────────────────────────
  {
    "williamboman/mason.nvim",
    opts = {
      ui = { border = "rounded" },
    },
  },

  -- ── mason-lspconfig: name mapping between mason and lspconfig ───────────────
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {},
  },

  -- ── mason-tool-installer: declarative server auto-install ───────────────────
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "pyright",               -- Python
        "r-languageserver",      -- R
        "lua-language-server",   -- Lua
        "bash-language-server",  -- Bash / Shell
        "clangd",                -- C / C++
        "html-lsp",              -- HTML
        "css-lsp",               -- CSS
      },
      auto_update  = false, -- don't silently update servers on every start
      run_on_start = true,  -- install missing servers on first launch
    },
  },

  -- ── nvim-lspconfig: configures each language client ─────────────────────────
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- needed here so capabilities include completion protocol
    },
    config = function()
      local lspconfig    = require("lspconfig")
      -- cmp_nvim_lsp extends base capabilities with the completion items the LSP
      -- server needs to send in order for nvim-cmp to receive and display them
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Python — static type checker + completions
      lspconfig.pyright.setup({ capabilities = capabilities })

      -- R — language server from CRAN
      lspconfig.r_language_server.setup({ capabilities = capabilities })

      -- Lua — must know about the `vim` global when editing nvim config
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics  = { globals = { "vim" } },   -- suppress "undefined global vim"
            workspace    = { checkThirdParty = false }, -- don't prompt about luassert etc.
            telemetry    = { enable = false },
          },
        },
      })

      -- Bash / Shell scripts
      lspconfig.bashls.setup({ capabilities = capabilities })

      -- C / C++ via clangd
      lspconfig.clangd.setup({ capabilities = capabilities })

      -- HTML
      lspconfig.html.setup({ capabilities = capabilities })

      -- CSS / SCSS / Less
      lspconfig.cssls.setup({ capabilities = capabilities })
    end,
  },
}
