local map = vim.keymap.set

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<CMD>resize +2<CR>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<CMD>resize -2<CR>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<CMD>vertical resize -2<CR>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<CMD>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-j>", "<CMD>m .+1<CR>==", { desc = "Move Down" })
map("n", "<A-k>", "<CMD>m .-2<CR>==", { desc = "Move Up" })
map("i", "<A-j>", "<ESC><CMD>m .+1<CR>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<ESC><CMD>m .-2<CR>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Up" })

-- buffers
map("n", "<S-h>", "<CMD>bprevious<CR>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<CMD>bnext<CR>", { desc = "Next Buffer" })
map("n", "[b", "<CMD>bprevious<CR>", { desc = "Prev Buffer" })
map("n", "]b", "<CMD>bnext<CR>", { desc = "Next Buffer" })
map("n", "<Leader>bb", "<CMD>e #<CR>", { desc = "Switch to Other Buffer" })
map("n", "<Leader>`", "<CMD>e #<CR>", { desc = "Switch to Other Buffer" })

-- Clear search with <ESC>
map({ "i", "n" }, "<ESC>", "<CMD>noh<CR><ESC>", { desc = "Escape and Clear hlsearch" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Terminal Mappings
map("t", "<ESC><ESC>", "<C-\\><C-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<CMD>wincmd h<CR>", { desc = "Go to Left Window" })
map("t", "<C-j>", "<CMD>wincmd j<CR>", { desc = "Go to Lower Window" })
map("t", "<C-k>", "<CMD>wincmd k<CR>", { desc = "Go to Upper Window" })
map("t", "<C-l>", "<CMD>wincmd l<CR>", { desc = "Go to Right Window" })
map("t", "<C-/>", "<CMD>close<CR>", { desc = "Hide Terminal" })
map("t", "<C-_>", "<CMD>close<CR>", { desc = "which_key_ignore" })

-- windows
map("n", "<Leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
map("n", "<Leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<Leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<Leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<Leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<Leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })

-- tabs
map("n", "<Leader><TAB>l", "<CMD>tablast<CR>", { desc = "Last Tab" })
map("n", "<Leader><TAB>f", "<CMD>tabfirst<CR>", { desc = "First Tab" })
map("n", "<Leader><TAB><TAB>", "<CMD>tabnew<CR>", { desc = "New Tab" })
map("n", "<Leader><TAB>]", "<CMD>tabnext<CR>", { desc = "Next Tab" })
map("n", "<Leader><TAB>d", "<CMD>tabclose<CR>", { desc = "Close Tab" })
map("n", "<Leader><TAB>[", "<CMD>tabprevious<CR>", { desc = "Previous Tab" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<Leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- keywordprg
map("n", "<Leader>K", "<CMD>norm! K<CR>", { desc = "Keywordprg" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- new file
map("n", "<Leader>fn", "<CMD>enew<CR>", { desc = "New File" })

-- lazy
map("n", "<Leader>l", "<CMD>Lazy<CR>", { desc = "Lazy" })

-- quit
map("n", "<Leader>qq", "<CMD>qa<CR>", { desc = "Quit All" })
