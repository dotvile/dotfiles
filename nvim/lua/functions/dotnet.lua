local M = {}

local function buffer_path()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return vim.fn.getcwd()
  end

  return name
end

local function start_dir(start)
  local path = start or buffer_path()
  if vim.fn.isdirectory(path) == 1 then
    return path
  end

  return vim.fs.dirname(path)
end

local function first_found(patterns, start)
  local found = vim.fs.find(patterns, { path = start_dir(start), upward = true })
  return found[1]
end

local function latest_path(paths)
  local best_path
  local best_mtime = -1

  for _, path in ipairs(paths) do
    local stat = vim.loop.fs_stat(path)
    local mtime = stat and stat.mtime and stat.mtime.sec or -1
    if mtime > best_mtime then
      best_path = path
      best_mtime = mtime
    end
  end

  return best_path
end

local function preferred_dll(paths)
  local best = {}
  local fallback = {}

  for _, path in ipairs(paths) do
    local lower = path:lower()
    if not lower:match("[/\\]tests?[/\\]") and not lower:match("tests?%.dll$") then
      table.insert(best, path)
    else
      table.insert(fallback, path)
    end
  end

  return latest_path(best) or latest_path(fallback)
end

function M.csproj(start)
  return first_found({ "*.csproj" }, start)
end

function M.sln(start)
  return first_found({ "*.sln" }, start)
end

function M.target(start)
  return M.csproj(start) or M.sln(start)
end

function M.root(start)
  local target = M.target(start)
  if target then
    return vim.fs.dirname(target)
  end

  return start_dir(start)
end

function M.run(args, cwd)
  local proc = vim.system(vim.list_extend({ "dotnet" }, args), { cwd = cwd or M.root() , text = true }):wait()
  if proc.code ~= 0 then
    local message = vim.trim((proc.stderr or "") .. "\n" .. (proc.stdout or ""))
    if message == "" then
      message = "dotnet command failed"
    end
    return false, message
  end

  return true, vim.trim(proc.stdout or "")
end

function M.build(start)
  local target = M.target(start)
  local cwd = target and vim.fs.dirname(target) or M.root(start)
  local args = target and { "build", target } or { "build" }
  return M.run(args, cwd)
end

function M.find_debug_dll(start)
  local target = M.csproj(start)
  local root = target and vim.fs.dirname(target) or M.root(start)
  local candidates

  if target then
    local project_name = vim.fn.fnamemodify(target, ":t:r")
    candidates = vim.fn.globpath(root, "bin/Debug/**/" .. project_name .. ".dll", false, true)
  end

  if not candidates or #candidates == 0 then
    candidates = vim.fn.globpath(root, "**/bin/Debug/**/*.dll", false, true)
  end

  return preferred_dll(candidates)
end

function M.build_and_find_dll(start)
  local ok, message = M.build(start)
  if not ok then
    return nil, message
  end

  local dll = M.find_debug_dll(start)
  if not dll then
    return nil, "No debug DLL found"
  end

  return dll, nil
end

return M
