return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "ruff" },
      }
      opts.formatters = {
        ["clang-format"] = {
          prepend_args = { "-style={IndentWidth: 2, BasedOnStyle: LLVM}" },
        },
      }
    end,
  },
}

