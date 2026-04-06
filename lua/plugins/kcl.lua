-- KCL language support
-- Requires: kcl-language-server pre-installed (/usr/local/bin/kcl-language-server)

---@type LazySpec
return {
  -- Filetype detection: .k → kcl
  -- Uses astrocore (highest priority, overrides built-in Vim "kwt" mapping for .k)
  {
    "AstroNvim/astrocore",
    opts = {
      filetypes = {
        extension = { k = "kcl" },
      },
    },
  },

  -- Syntax highlighting and code folding for KCL files
  {
    "kcl-lang/kcl.nvim",
    ft = "kcl",
  },

  -- LSP: enable kcl-language-server for kcl filetype
  -- lspconfig ships a native vim.lsp.Config at lsp/kcl.lua (auto-discovered via runtimepath)
  -- astrolsp calls vim.lsp.enable("kcl") which auto-starts the server on kcl buffers
  -- "servers" uses opts_extend so it merges with other plugin specs, not replaces
  {
    "AstroNvim/astrolsp",
    opts = {
      servers = { "kcl" },
    },
  },
}
