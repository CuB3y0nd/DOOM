return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.window = {
        position = "right",
        width = 30,
      }

      opts.default_component_configs = {
        indent = {
          with_expanders = false,
        },
      }

      opts.filesystem = {
        filtered_items = {
          visible = true,
        },
      }
    end,
  },
}
