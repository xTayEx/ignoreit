local funcs = require("ignoreit.funcs")

---@class Config
---@field opt string
local config = {
  root_patterns = {},
  rooter_method = "pattern",
}

local M = {}

---@type Config
M.config = config

---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.entry = function(opts)
  local args = opts.args:gsub("%s+", " ")
  local args_table = vim.split(args, " ", { trimempty = true })
  assert(#args_table <= 1, "At most one argument is allowed")
  if #args_table == 0 then
    return funcs.generate_gitignore_interactively(M.config)
  else
    local lang = args_table[1]
    return funcs.generate_gitignore(lang, M.config)
  end
end

return M
