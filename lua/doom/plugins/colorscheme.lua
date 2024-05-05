return {
  -- catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        color_overrides = {
          mocha = {
            -- TODO: Adaptive terminal color
            base = "#1a1b26",
          },
        },
      })

      vim.cmd("colorscheme catppuccin-mocha")
    end,
  },
}
