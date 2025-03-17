local lang_list = require("ignoreit.lang_list")

vim.api.nvim_create_user_command("Gitignore", require("ignoreit").entry, {
  desc = "Create gitignore file",
  nargs = "*",
  complete = function()
    return lang_list.lang_list
  end,
})
