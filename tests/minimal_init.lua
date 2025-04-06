vim.env.LAZY_STDPATH = "/tmp/.nvim_minimal"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

local plugins = {
  {
    dir = ".",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "folke/snacks.nvim" },
    },
    opts = {
      picker_provider = "ui_select"
    }
  },
  { "nvim-lua/plenary.nvim" },
}

require("lazy.minit").setup({ spec = plugins })

vim.cmd("runtime plugin/plenary.vim")
require("plenary.busted")
