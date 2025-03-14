-- main module file
local module = require("ignoreit.module")

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
    module.show_available_lang()
    return "good"
  else
    return module.gen_gitignore(M.config.opt)
  end
end

return M
