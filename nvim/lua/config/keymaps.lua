-- mods for keybindings
local kmap = vim.keymap

local function ob_new(note_type)
  return function()
    vim.ui.input({ prompt = "Title: " }, function(input)
      if not input or input == "" then
        return
      end

      local path = vim.fn.system({ "ob", "new", note_type, input, "--print-path", "--no-open" })
      if vim.v.shell_error ~= 0 then
        vim.notify(vim.trim(path), vim.log.levels.ERROR)
        return
      end

      vim.cmd("edit " .. vim.fn.fnameescape(vim.trim(path)))
    end)
  end
end

local function ob_current_path_cmd(subcommand)
  local current = vim.api.nvim_buf_get_name(0)
  if current == "" then
    vim.notify("No current file", vim.log.levels.WARN)
    return nil
  end

  local result = vim.fn.system({ "ob", subcommand, current, "--print-path", "--sync-mocs" })
  if vim.v.shell_error ~= 0 then
    vim.notify(vim.trim(result), vim.log.levels.ERROR)
    return nil
  end

  return vim.trim(result)
end

local obsidian_vault_dir = vim.g.obsidian_vault_dir or vim.fn.expand("~/Documents/Obsidian/Vile")

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
kmap.set("n", "<leader>oo", function()
  vim.cmd("cd " .. vim.fn.fnameescape(obsidian_vault_dir))
end, { desc = "Go to Obsidian vault" })
-- open today's daily note
kmap.set("n", "<leader>od", ":ObsidianToday<cr>")
kmap.set("n", "<leader>oc", ob_new("concept-note"), { desc = "Create concept note" })
kmap.set("n", "<leader>os", ob_new("study-session"), { desc = "Create study session" })
kmap.set("n", "<leader>of", ob_new("source-note"), { desc = "Create source note" })
kmap.set("n", "<leader>om", function()
  local result = vim.fn.system({ "ob", "sync-mocs" })
  if vim.v.shell_error ~= 0 then
    vim.notify(vim.trim(result), vim.log.levels.ERROR)
    return
  end
  vim.notify("MOCs rebuilt", vim.log.levels.INFO)
end, { desc = "Sync MOCs" })
kmap.set("n", "<leader>ox", function()
  local target = ob_current_path_cmd("classify")
  if not target then
    return
  end
  vim.cmd("edit " .. vim.fn.fnameescape(target))
  vim.notify("Note classified", vim.log.levels.INFO)
end, { desc = "Classify current note" })
-- convert note to template and remove leading white space
kmap.set("n", "<leader>on", ":ObsidianTemplate default<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
-- format obsidian title must have cursor on title
kmap.set("n", "<leader>otf", ":s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>")
-- move file in current buffer to zettelkasten folder
kmap.set(
  "n",
  "<leader>ok",
  function()
    local current = vim.api.nvim_buf_get_name(0)
    if current == "" then
      vim.notify("No current file", vim.log.levels.WARN)
      return
    end

    local target_dir = obsidian_vault_dir .. "/zettelkasten"
    vim.fn.mkdir(target_dir, "p")
    local result = vim.fn.system({ "mv", current, target_dir })
    if vim.v.shell_error ~= 0 then
      vim.notify(vim.trim(result), vim.log.levels.ERROR)
      return
    end

    vim.cmd("bd")
  end,
  { desc = "Move note to zettelkasten" }
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
