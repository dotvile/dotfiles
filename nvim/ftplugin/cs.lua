-- nvim 0.9+ has built-in editorconfig support. The project's .editorconfig sets
-- end_of_line = crlf for *.cs files, which makes nvim set fileformat=dos and
-- write CRLF on every save, causing spurious git diffs (repo stores LF).
-- vim.schedule defers until after editorconfig has applied its settings,
-- so this override wins.
vim.schedule(function()
  if vim.bo.filetype == "cs" then
    vim.opt_local.fileformat = "unix"
  end
end)
