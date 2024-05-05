return {
  -- formatting
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        asm = { "asmfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        lua = { "stylua" },
        sh = { "shfmt" },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
        javascript = { { "prettierd", "prettier" } },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        rust = { "rustfmt" },
        ["_"] = { "trim_whitespace" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        rustfmt = { options = { default_edition = "2021" } },
      },
      format_on_save = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_fallback = true,
      },
    })
  end,
}
