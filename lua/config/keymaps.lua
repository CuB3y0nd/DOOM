vim.keymap.set("n", "<leader>cP", function()
  local ok, conform = pcall(require, "conform")
  if not ok then
    vim.notify("conform.nvim not loaded.", vim.log.levels.WARN)
    return
  end

  local excluded = {
    dirs = { ".git/", "cmake/", "build/", "doc/", "man/" },
    files = {},
    exts = { [".md"] = true },
    patterns = { "^Makefile.*", "^CMakeLists.*" },
  }

  vim.ui.input({ prompt = "Format directory: ", default = ".", completion = "dir" }, function(input)
    if not input or input == "" then
      return
    end

    local target_dir = vim.fn.fnamemodify(input, ":p"):gsub("/$", "")
    if vim.fn.isdirectory(target_dir) == 0 then
      vim.notify("Invalid directory: " .. target_dir, vim.log.levels.ERROR)
      return
    end

    local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
    local is_git = (vim.v.shell_error == 0)
    local raw_files = {}

    if is_git then
      local cmd = string.format(
        "git -C %s ls-files --cached --others --exclude-standard %s",
        vim.fn.shellescape(root),
        vim.fn.shellescape(target_dir)
      )
      raw_files = vim.fn.systemlist(cmd)
      for i, f in ipairs(raw_files) do
        raw_files[i] = root .. "/" .. f
      end
    else
      local cmd = string.format("fd . %s --type f --color never --hidden", vim.fn.shellescape(target_dir))
      raw_files = vim.fn.systemlist(cmd)
    end

    local files_to_process = {}
    for _, file in ipairs(raw_files) do
      local filename = vim.fn.fnamemodify(file, ":t")
      local is_excluded = false

      for _, dir in ipairs(excluded.dirs) do
        if file:find(dir, 1, true) then
          is_excluded = true
          break
        end
      end

      if not is_excluded then
        if excluded.files[filename] then
          is_excluded = true
        elseif
          excluded.exts[vim.fn.fnamemodify(file, ":e")] or excluded.exts["." .. vim.fn.fnamemodify(file, ":e")]
        then
          is_excluded = true
        else
          for _, pat in ipairs(excluded.patterns) do
            if filename:match(pat) then
              is_excluded = true
              break
            end
          end
        end
      end

      if not is_excluded then
        table.insert(files_to_process, file)
      end
    end

    if #files_to_process == 0 then
      vim.notify("No files to process.", vim.log.levels.WARN)
      return
    end

    vim.notify(string.format("Batch formatting %d files...", #files_to_process), vim.log.levels.INFO)

    local modified_count = 0
    local total = #files_to_process

    -- Suppress all autocommands to prevent LSP noise and plugin errors during batch processing
    local old_ei = vim.opt.eventignore:get()
    vim.opt.eventignore = "all"

    for i, path in ipairs(files_to_process) do
      if vim.fn.filereadable(path) == 1 then
        -- Load file into a temporary buffer (robust handling of encodings/newlines)
        local bufnr = vim.fn.bufadd(path)
        vim.fn.bufload(bufnr)

        -- Ensure filetype is detected for conform.nvim
        if vim.bo[bufnr].filetype == "" then
          local ft = vim.filetype.match({ filename = path })
          if ft then
            vim.bo[bufnr].filetype = ft
          end
        end

        local success, formatted = pcall(conform.format, {
          bufnr = bufnr,
          async = false,
          lsp_fallback = false,
          quiet = true,
        })

        if success and formatted and vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("silent! write")
          end)
          modified_count = modified_count + 1
        end

        vim.api.nvim_buf_delete(bufnr, { force = true })
      end

      if i % 10 == 0 then
        vim.cmd("redraw")
      end
    end

    vim.opt.eventignore = old_ei
    vim.notify(string.format("Formatted %d/%d files.", modified_count, total), vim.log.levels.INFO)
  end)
end, { desc = "Batch format directory" })

