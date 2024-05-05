return {
  -- LSP Server
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "asm_lsp",
          "bashls",
          "clangd",
          "dockerls",
          "tsserver",
          "lua_ls",
          "pyright",
          "rust_analyzer",
        },
      })
    end,
  },

  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      lspconfig.asm_lsp.setup({ capabilities = capabilities })
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.clangd.setup({ capabilities = capabilities })
      lspconfig.dockerls.setup({ capabilities = capabilities })
      lspconfig.tsserver.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.rust_analyzer.setup({ capabilities = capabilities })
    end,
    keys = {
      { "<Leader>cl", "<CMD>LspInfo<CR>", desc = "LSP Info" },
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gi", vim.lsp.buf.implementation, desc = "Goto Implementation" },
      { "gr", vim.lsp.buf.references, desc = "References" },
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
      { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
      { "<Leader>ca", vim.lsp.buf.code_action, mode = "n", desc = "Code Action" },
      { "<Leader>ca", vim.lsp.buf.code_action, mode = "v", desc = "Code Action" },
    },
  },
}
