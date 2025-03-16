local setup_plugin = function(plugins)
  for _, plugin in ipairs(plugins) do
    local plugin_dir = "/tmp/" .. vim.split(plugin, "/")[2]
    local is_not_a_directory = vim.fn.isdirectory(plugin_dir) == 0
    if is_not_a_directory then
      vim.fn.system({ "git", "clone", "https://github.com/" .. plugin, plugin_dir })
    end
    vim.opt.rtp:append(plugin_dir)
  end
end

setup_plugin({
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  "nvim-telescope/telescope.nvim"
})

vim.opt.rtp:append(".")

vim.cmd("runtime plugin/plenary.vim")
require("plenary.busted")
