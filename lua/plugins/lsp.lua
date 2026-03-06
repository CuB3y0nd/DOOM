return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {
        "stylua",
        "shfmt",
        "clang-format",
        "ruff",
      }
    end,
  },
}
