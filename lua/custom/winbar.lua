local M = {}

local disabled_filetypes = {
  dashboard = true,
  alpha = true,
  ministarter = true,
  snacks_dashboard = true,
  help = false,
}

function M.eval()
  -- disable for special buffers
  if vim.bo.buftype ~= "" then
    return ""
  end

  -- disable for specific filetypes
  if disabled_filetypes[vim.bo.filetype] then
    return ""
  end

  local parts = {}

  -- navic breadcrumbs
  local ok_navic, navic = pcall(require, "nvim-navic")
  if ok_navic and navic.is_available() then
    table.insert(parts, navic.get_location())
  end

  table.insert(parts, "%=")
  table.insert(parts, "%m ")
  table.insert(parts, "%f")

  return table.concat(parts)
end

return M
