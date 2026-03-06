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

  local excluded_patterns = {
    dirs = {
      ".git/",
      "test/",
      "cmake/",
      "m4/",
      "tools/",
      "html/",
      "doc/",
      "man/",
    },
    files = {},
    exts = { [".md"] = true, [".txt"] = true },
    patterns = { "^Makefile.*" },
  }

  vim.ui.input({ prompt = "Format directory: ", default = ".", completion = "dir" }, function(input)
    if not input or input == "" then
      return
    end

    local root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
    local is_git = (vim.v.shell_error == 0)
    local raw_files = is_git and vim.fn.systemlist("git ls-files --full-name " .. input) or {}

    if not is_git then
      local target_dir = vim.fn.fnamemodify(input, ":p"):gsub("/$", "")
      raw_files = vim.fn.split(vim.fn.system("find " .. target_dir .. " -type f"), "\n")
    else
      for i, f in ipairs(raw_files) do
        raw_files[i] = root .. "/" .. f
      end
    end

    local files_to_format = {}
    local formatters_by_ft = conform.formatters_by_ft or {}

    for _, file in ipairs(raw_files) do
      local filename = vim.fn.fnamemodify(file, ":t")
      local is_excluded = excluded_patterns.files[filename]

      if not is_excluded then
        for _, dir in ipairs(excluded_patterns.dirs) do
          if file:find(dir, 1, true) then
            is_excluded = true
            break
          end
        end
      end

      if not is_excluded then
        for ext in pairs(excluded_patterns.exts) do
          if file:sub(-#ext) == ext then
            is_excluded = true
            break
          end
        end
      end

      if not is_excluded then
        for _, pat in ipairs(excluded_patterns.patterns) do
          if filename:match(pat) then
            is_excluded = true
            break
          end
        end
      end

      if not is_excluded then
        local ft = vim.filetype.match({ filename = file })
        if ft and (formatters_by_ft[ft] or formatters_by_ft["*"] or formatters_by_ft["_"]) then
          table.insert(files_to_format, file)
        end
      end
    end

    if #files_to_format == 0 then
      vim.notify("No formatable files found.", vim.log.levels.WARN)
      return
    end

    local count = 0
    local total = #files_to_format
    vim.notify(string.format("Formatting %d files...", total), vim.log.levels.INFO)

    for i, path in ipairs(files_to_format) do
      if vim.fn.filereadable(path) == 1 then
        local bufnr = vim.fn.bufnr(path)
        local was_loaded = (bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr))
        if not was_loaded then
          bufnr = vim.fn.bufadd(path)
          vim.fn.bufload(bufnr)
        end

        vim.api.nvim_buf_call(bufnr, function()
          local ok_fmt = pcall(conform.format, { bufnr = bufnr, async = false, lsp_fallback = true })
          if ok_fmt and vim.api.nvim_buf_get_option(bufnr, "modified") then
            vim.cmd("silent! write")
            count = count + 1
          end
        end)

        if not was_loaded then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      end

      if i % 10 == 0 then
        vim.cmd("redraw")
      end
    end

    vim.notify(string.format("Done! Formatted %d/%d files.", count, total), vim.log.levels.INFO)
  end)
end, { desc = "Format directory" })
