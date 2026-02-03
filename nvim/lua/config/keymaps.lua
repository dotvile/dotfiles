-- mods for keybindings
local kmap = vim.keymap

-- mod on normal mode
kmap.set("n", "<leader>bd", ":bd<cr>", { desc = "Close current buffer" })
kmap.set("n", "<leader>bb", ":b#<cr>", { desc = "Close current buffer" })
kmap.set("n", "<leader>s", ":%s#", { desc = "Open replace mode" })

-- mod on all modes
kmap.set("", "<leader>lk", ":WhichKey <cr>", { desc = "List keybindings" })
-- go
kmap.set("n", "<leader>god", ":go doc")
-- obsidian
-- navigate to vault
kmap.set("n", "<leader>oo", ":cd /Users/victor/Library/Mobile\\ Documents/iCloud~md~obsidian/Documents/Vile<cr>")
-- convert note to template and remove leading white space
kmap.set("n", "<leader>on", ":ObsidianTemplate default<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
-- format obsidian title must have cursor on title
kmap.set("n", "<leader>otf", ":s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>")
-- move file in current buffer to zettelkasten folder
kmap.set(
  "n",
  "<leader>ok",
  ":!mv '%:p' /Users/victor/Library/Mobile\\ Documents/iCloud~md~obsidian/Documents/Vile/zettelkasten<cr>:bd<cr>"
)
-- delete file in current buffer
kmap.set("n", "<leader>odd", ":!rm '%:p'<cr>:bd<cr>")
-- movement changes
kmap.set("", "s", "l", { desc = "Right" })
kmap.set("", "l", "s", { desc = "Delete [count] chars and start insert" })
kmap.set("", "L", "S", { desc = "Delete [count] chars and start insert" })
kmap.set("", "S", "L", { desc = "Last line of window" })
kmap.set("", "t", "j", { desc = "Down" })
kmap.set("", "T", "J", { desc = "Join [count] lines, 2 lines minimum" })
kmap.set("", "n", "k", { desc = "Up" })
kmap.set("", "m", "nzzzv", { desc = "Search and auto adjust to center" })
kmap.set("", "M", "Nzzzv", { desc = "Search back and auto adjust to center" })

-- save, quit, load opts
kmap.set("", "<leader>rr", ":source %<cr>", { desc = "Source the current file" })
kmap.set("", "<leader>w<leader>", ":w<cr>", { desc = "Save" })
kmap.set("", "<leader>wq<leader>", ":wq<cr>", { desc = "Save and quit" })
kmap.set("", "<leader>qq<leader>", ":q<cr>", { desc = "Quit" })
kmap.set("", "<leader>Q<leader>", ":q!<cr>", { desc = "Quit without save" })

-- window management
kmap.set("", "<C-h>", "<C-w>h", { desc = "Swap to left window" })
kmap.set("", "<C-t>", "<C-w>j", { desc = "Swap to bottom window" })
kmap.set("", "<C-n>", "<C-w>k", { desc = "Swap to top window" })
kmap.set("", "<C-s>", "<C-w>l", { desc = "Swap to right window" })
kmap.set("", "<C-w>m", "<C-w>s", { desc = "Split window" })
kmap.set("", "<C-d>", "<C-w>q", { desc = "Quit current window" })
