local M = {}

local state = {
  buf = nil,
  win = nil,
}

local function attach_terminal_mappings(buf)
  local opts = { buffer = buf, silent = true, nowait = true }

  vim.keymap.set({ "t" }, "<Esc>", function()
    require("functions.floating_terminal").close()
  end, opts)
  vim.keymap.set({ "t" }, "<C-q>", function()
    require("functions.floating_terminal").close()
  end, opts)
  vim.keymap.set({ "t" }, "<C-\\><C-n>", function()
    vim.cmd("stopinsert")
  end, opts)
end

local function centered_float_opts()
  local cols = vim.o.columns
  local lines = vim.o.lines
  local width = math.floor(cols * 0.88)
  local height = math.floor(lines * 0.82)
  local row = math.floor((lines - height) / 2 - 1)
  local col = math.floor((cols - width) / 2)

  return {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    width = width,
    height = height,
    row = row,
    col = col,
  }
end

local function ensure_buf()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    return state.buf
  end

  state.buf = vim.api.nvim_create_buf(false, true)
  vim.bo[state.buf].bufhidden = "hide"
  vim.bo[state.buf].swapfile = false
  vim.bo[state.buf].filetype = "terminal"
  attach_terminal_mappings(state.buf)
  return state.buf
end

local function open_window()
  local buf = ensure_buf()

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_set_current_win(state.win)
    return state.win, buf
  end

  state.win = vim.api.nvim_open_win(buf, true, centered_float_opts())
  vim.wo[state.win].winblend = 5
  vim.wo[state.win].number = false
  vim.wo[state.win].relativenumber = false
  vim.wo[state.win].signcolumn = "no"
  return state.win, buf
end

local function ensure_job()
  local buf = ensure_buf()
  if vim.bo[buf].buftype == "terminal" and vim.b[buf].terminal_job_id then
    return buf
  end

  vim.b[buf].floating_terminal_auto_close = true
  vim.api.nvim_buf_call(buf, function()
    vim.fn.termopen(vim.o.shell, {
      cwd = vim.loop.cwd(),
      on_exit = function()
        if vim.b[buf].floating_terminal_auto_close then
          vim.schedule(function()
            require("functions.floating_terminal").close()
          end)
        end
      end,
    })
  end)

  local group = vim.api.nvim_create_augroup("floating-terminal-" .. buf, { clear = true })
  vim.api.nvim_create_autocmd("TermClose", {
    group = group,
    buffer = buf,
    callback = function()
      if vim.b[buf].floating_terminal_auto_close then
        vim.schedule(function()
          require("functions.floating_terminal").close()
        end)
      end
    end,
  })
  return buf
end

function M.toggle_shell()
  local win, buf = open_window()
  ensure_job()
  vim.api.nvim_set_current_win(win)
  vim.cmd("startinsert")
  return buf
end

function M.run(cmd)
  local win, buf = open_window()
  vim.b[buf].floating_terminal_auto_close = false
  vim.api.nvim_buf_call(buf, function()
    vim.fn.termopen(cmd, {
      cwd = vim.loop.cwd(),
      on_exit = function()
        vim.schedule(function()
          if state.win and vim.api.nvim_win_is_valid(state.win) then
            vim.api.nvim_win_set_cursor(state.win, { vim.api.nvim_buf_line_count(buf), 0 })
          end
        end)
      end,
    })
  end)
  vim.api.nvim_set_current_win(win)
  vim.cmd("startinsert")
end

function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
end

return M
