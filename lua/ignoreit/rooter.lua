local M = {}
function M.find_root_by_lsp()
  -- Get lsp client for current buffer
  -- Returns nil or string
  local clients = vim.lsp.get_clients()
  if next(clients) == nil then
    return nil
  end
  return clients[1].config.root_dir
end

function M.find_root_by_pattern(opts)
  local default_root_patterns = {
    ".git",
    ".clang-format",
    "pyproject.toml",
    "setup.py",
  }
  local root_patterns = vim.list_extend(opts.root_patterns or {}, default_root_patterns)
  local root_dir = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
  return root_dir
end

return M
