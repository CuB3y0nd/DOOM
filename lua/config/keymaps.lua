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

vim.keymap.set("n", "<leader>cP", function()
  local ok, conform = pcall(require, "conform")
  if not ok then
    vim.notify("conform.nvim not loaded.", vim.log.levels.WARN)
    return
  end

  vim.ui.input({ prompt = "Format directory: ", default = ".", completion = "dir" }, function(input)
    if not input or input == "" then
      return
    end

    local root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
    local is_git = (vim.v.shell_error == 0)

    local files = {}
    if is_git then
      local git_files = vim.fn.systemlist("git ls-files --full-name " .. input)
      for _, f in ipairs(git_files) do
        table.insert(files, root .. "/" .. f)
      end
    else
      local target_dir = vim.fn.fnamemodify(input, ":p"):gsub("/$", "")
      files = vim.fn.split(vim.fn.system("find " .. target_dir .. " -type f"), "\n")
    end

    if #files == 0 then
      vim.notify("No file found: " .. input, vim.log.levels.WARN)
      return
    end

    vim.notify("Formatting " .. #files .. " files...", vim.log.levels.INFO)

    local count = 0
    for _, full_path in ipairs(files) do
      if vim.fn.filereadable(full_path) == 1 then
        local bufnr = vim.fn.bufnr(full_path)
        local loaded = (bufnr ~= -1)
        if not loaded then
          bufnr = vim.fn.bufadd(full_path)
          vim.fn.bufload(bufnr)
        end

        vim.api.nvim_buf_call(bufnr, function()
          if vim.bo.filetype == "" then
            vim.cmd("filetype detect")
          end

          local ok_fmt = pcall(conform.format, { bufnr = bufnr, async = false, lsp_fallback = true })
          if ok_fmt then
            vim.cmd("silent! write")
            count = count + 1
          end
        end)

        if not loaded then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      end
    end

    vim.notify("Successfully formatted " .. count .. " files.", vim.log.levels.INFO)
  end)
end, { desc = "Format directory" })
