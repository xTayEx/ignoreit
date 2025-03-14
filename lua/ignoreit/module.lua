---@class CustomModule
local M = {}

local Job = require("plenary.job")
local Async = require("plenary.async")
local AsyncUtils = require("plenary.async.util")
local nui_popup = require("nui.popup")
local nui_event = require("nui.utils.autocmd").event
---@return string
M.gen_gitignore = function(greeting)
  print(greeting)
  return greeting
end

M.show_available_lang = function()
  -- curl -sL https://www.toptal.com/developers/gitignore/api/\$@
  local gitignore_provider_url = "https://www.toptal.com/developers/gitignore/api/"
  local available_lang_list = ""
  local request_func = function()
    ---@diagnostic disable-next-line: missing-fields
    Job:new({
      command = "curl",
      args = { "-sL", gitignore_provider_url .. "list" },
      cwd = vim.fn.getcwd(),
      env = {},
      on_exit = function(result, exit_code)
        if exit_code ~= 0 then
          vim.notify("Error fetching available languages", vim.log.levels.ERROR)
          return
        end
        available_lang_list = vim.iter(result:result()):join("\n") or ""
      end,
    }):sync()
  end

  local popup_func = function()
    local popup = nui_popup({
      enter = true,
      focusable = true,
      border = {
        style = "rounded",
      },
      position = "50%",
      size = {
        width = "80%",
        height = "60%",
      },
    })

    popup:mount()
    popup:on(nui_event.BufLeave, function()
      popup:unmount()
    end)
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, vim.split(available_lang_list, "\n"))
  end

  Async.run(request_func, popup_func)
end

return M
