-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local cmp_enabled = true
vim.keymap.set("n", "<leader>cc", function()
  local ok, cmp = pcall(require, "cmp")
  if not ok then
    vim.notify("nvim-cmp not loaded", vim.log.levels.WARN)
    return
  end

  cmp_enabled = not cmp_enabled
  cmp.setup({
    enabled = function()
      return cmp_enabled
    end,
  })

  vim.notify("Completion " .. (cmp_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, { desc = "Toggle nvim-cmp" })

local lsp_enabled = true
vim.keymap.set("n", "<leader>cL", function()
  lsp_enabled = not lsp_enabled

  if lsp_enabled then
    pcall(vim.api.nvim_create_augroup, "nvim.lsp.enable", { clear = false })
    vim.cmd("LspStart")
    vim.cmd("doautocmd FileType")
    vim.notify("LSP started")
  else
    for _, client in ipairs(vim.lsp.get_clients()) do
      vim.lsp.stop_client(client.id, true)
    end
    vim.notify("LSP stopped")
  end
end, { desc = "Toggle all LSP clients" })
