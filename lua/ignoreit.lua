-- main module file
local funcs = require("ignoreit.funcs")

---@class Config
---@field opt string Your config option
local config = {
  opt = "Hello!",
}

---@class MyModule
local M = {}

---@type Config
M.config = config

---@param args Config?
-- you can define your setup function here. Usually configurations can be merged, accepting outside params and
-- you can also put some validation here for those.
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.entry = function(opts)
  local args = opts.args:gsub("%s+", " ")
  local subcommand = vim.split(args, " ")
  if subcommand[1] == "list" then
    funcs.show_available_lang_telescope(M.config)
    return "good"
  else
    return funcs.gen_gitignore(M.config.opt)
  end
end

return M
