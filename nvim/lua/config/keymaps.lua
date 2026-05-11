-- mods for keybindings
local kmap = vim.keymap
local dotnet = require("functions.dotnet")
local float_term = require("functions.floating_terminal")
local vault_root = vim.fn.expand("~/Documents/vault")

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

local function run_dotnet_command(title, args)
  local ok, message = dotnet.run(args)
  local level = ok and vim.log.levels.INFO or vim.log.levels.ERROR
  vim.notify(message ~= "" and message or (ok and "Done" or "Command failed"), level, { title = title })
end

local function sqlearning_context()
  local current = vim.api.nvim_buf_get_name(0)
  if current == "" then
    return nil
  end

  local repo_root, exercise_rel = current:match("^(.*)/sqlearning/(lessons/.+)/[^/]+$")
  if not repo_root or not exercise_rel then
    return nil
  end

  return {
    repo_root = repo_root,
    exercise_rel = exercise_rel,
  }
end

local function run_sqlearning_test()
  local ctx = sqlearning_context()
  if not ctx then
    vim.notify("Open an sqlearning exercise file", vim.log.levels.WARN)
    return
  end

  float_term.run({
    "bash",
    "-lc",
    string.format("cd %q && ./bin/sqlearning test %q", ctx.repo_root .. "/sqlearning", ctx.exercise_rel),
  })
end

-- mod on normal mode
kmap.set("n", "<leader>bd", ":bd<cr>", { desc = "Close current buffer" })
kmap.set("n", "<leader>bb", ":b#<cr>", { desc = "Close current buffer" })
kmap.set("n", "<leader>s", ":%s#", { desc = "Open replace mode" })

-- mod on all modes
kmap.set("", "<leader>lk", ":WhichKey <cr>", { desc = "List keybindings" })
-- go
kmap.set("n", "<leader>god", ":go doc")
-- dotnet
kmap.set("n", "<leader>mr", ":DotnetRestore<cr>", { desc = "Dotnet restore" })
kmap.set("n", "<leader>mb", ":DotnetBuild<cr>", { desc = "Dotnet build" })
kmap.set("n", "<leader>mc", ":DotnetClean<cr>", { desc = "Dotnet clean" })
kmap.set("n", "<leader>tn", ":DotnetTestNearest<cr>", { desc = "Run nearest .NET test" })
kmap.set("n", "<leader>tf", ":DotnetTestFile<cr>", { desc = "Run tests in file" })
kmap.set("n", "<leader>td", ":DotnetTestDebugNearest<cr>", { desc = "Debug nearest .NET test" })
kmap.set("n", "<leader>ts", ":DotnetTestSummary<cr>", { desc = "Toggle test summary" })
kmap.set("n", "<leader>to", ":DotnetTestOutput<cr>", { desc = "Toggle test output" })
kmap.set("n", "<leader>tr", function()
  float_term.toggle_shell()
end, { desc = "Toggle floating terminal" })
kmap.set("n", "<leader>st", function()
  run_sqlearning_test()
end, { desc = "Test sqlearning exercise" })

vim.api.nvim_create_user_command("DotnetRoot", function()
  vim.notify(dotnet.root(), vim.log.levels.INFO, { title = "Dotnet root" })
end, {})

vim.api.nvim_create_user_command("FloatTerm", function()
  float_term.toggle_shell()
end, {})

vim.api.nvim_create_user_command("SqLearningTest", function()
  run_sqlearning_test()
end, {})

vim.api.nvim_create_user_command("DotnetRestore", function()
  local target = dotnet.target()
  if target then
    run_dotnet_command("Dotnet restore", { "restore", target })
  else
    run_dotnet_command("Dotnet restore", { "restore" })
  end
end, {})

vim.api.nvim_create_user_command("DotnetBuild", function()
  local target = dotnet.target()
  if target then
    run_dotnet_command("Dotnet build", { "build", target })
  else
    run_dotnet_command("Dotnet build", { "build" })
  end
end, {})

vim.api.nvim_create_user_command("DotnetClean", function()
  local target = dotnet.target()
  if target then
    run_dotnet_command("Dotnet clean", { "clean", target })
  else
    run_dotnet_command("Dotnet clean", { "clean" })
  end
end, {})

vim.api.nvim_create_user_command("DotnetTestNearest", function()
  require("neotest").run.run()
end, {})

vim.api.nvim_create_user_command("DotnetTestFile", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, {})

vim.api.nvim_create_user_command("DotnetTestDebugNearest", function()
  require("neotest").run.run({ strategy = "dap" })
end, {})

vim.api.nvim_create_user_command("DotnetTestSummary", function()
  require("neotest").summary.toggle()
end, {})

vim.api.nvim_create_user_command("DotnetTestOutput", function()
  require("neotest").output_panel.toggle()
end, {})
-- obsidian
-- navigate to vault
kmap.set("n", "<leader>oo", ":cd " .. vim.fn.fnameescape(vault_root) .. "<cr>")
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
  ":!mv '%:p' " .. vim.fn.fnameescape(vault_root .. "/zettelkasten") .. "<cr>:bd<cr>"
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
