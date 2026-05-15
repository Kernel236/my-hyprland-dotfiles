-- plugins/completion.lua
-- Completion engine: nvim-cmp with LSP, buffer, path, and snippet sources.
-- Snippet engine: LuaSnip + friendly-snippets (VSCode-style snippet collection).

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- load only when entering insert mode (faster startup)
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",          -- LSP completions
      "hrsh7th/cmp-buffer",            -- words from open buffers
      "hrsh7th/cmp-path",              -- filesystem paths
      "L3MON4D3/LuaSnip",             -- snippet engine
      "saadparwaiz1/cmp_luasnip",      -- LuaSnip → cmp bridge
      "rafamadriz/friendly-snippets",  -- curated snippet collection for many languages
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      -- Load VSCode-format snippets from friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          -- LuaSnip expands snippet items from the LSP
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
          ["<C-d>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),  -- force open completion menu
          ["<CR>"]      = cmp.mapping.confirm({ select = true }), -- confirm top item

          -- Tab: cycle through items or jump through snippet placeholders
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources(
          -- Primary sources (shown first, ranked higher)
          {
            { name = "nvim_lsp" },
            { name = "luasnip" },
          },
          -- Fallback sources (shown when primary sources have no results)
          {
            { name = "buffer" },
            { name = "path" },
          }
        ),
      })
    end,
  },
}
