local lang_list = require("ignoreit.lang_list")

vim.api.nvim_create_user_command("Gitignore", require("ignoreit").entry, {
  desc = "Create gitignore file",
  nargs = "*",
  complete = function(arg_lead, _, _)
    local out = {}
    for _, c in ipairs(lang_list.lang_list) do
      if vim.startswith(c, arg_lead) then
        table.insert(out, c)
      end
    end
    return out
  end,
})
