return {
  {
    "catppuccin/nvim",
    opts = function(_, opts)
      opts.transparent_background = true
      opts.custom_highlights = function(colors)
        return {
          NormalFloat = { bg = "none" },
        }
      end
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = "catppuccin-macchiato"
    end,
  },
}
