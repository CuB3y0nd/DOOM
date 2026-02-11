return {
  {
    "yetone/avante.nvim",
    opts = function(_, opts)
      opts.provider = "gemini-cli"
      opts.acp_providers = {
        ["gemini-cli"] = {
          command = "gemini",
          args = { "--experimental-acp", "-m", "gemini-3-flash-preview" },
          env = {
            NODE_NO_WARNINGS = "1",
            GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
            HTTP_PROXY = "http://127.0.0.1:2080",
            HTTPS_PROXY = "http://127.0.0.1:2080",
          },
        },
      }
    end,
    system_prompt = function()
      local hub = require("mcphub").get_hub_instance()
      return hub and hub:get_active_servers_prompt() or ""
    end,
    custom_tools = function()
      return {
        require("mcphub.extensions.avante").mcp_tool(),
      }
    end,
  },
}
