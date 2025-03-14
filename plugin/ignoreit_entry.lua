vim.api.nvim_create_user_command(
  "Gitignore",
  require("ignoreit").entry,
  { desc = "Create gitignore file", nargs = "*" }
)
