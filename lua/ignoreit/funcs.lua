---@class CustomModule
local M = {}

local Job = require("plenary.job")
local Async = require("plenary.async")
local nui_popup = require("nui.popup")
local nui_event = require("nui.utils.autocmd").event
local lang_list = require("ignoreit.lang_list")

-- import telescope related modules
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

---@return string
M.gen_gitignore = function(greeting)
  print(greeting)
  return greeting
end

M.show_available_lang_telescope = function(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", require("telescope.themes").get_dropdown({}), opts)
  pickers
    .new(opts, {
      prompt_title = "Available Languages",
      finder = finders.new_table({
        results = lang_list.lang_list,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.notify("Selected: " .. selection[1], vim.log.levels.INFO)
          -- print(vim.inspect(selection))
          -- vim.api.nvim_put({ selection[1] }, "", false, true)
        end)
        return true
      end,
    })
    :find()

  -- print(lang_list.lang_list[1])
end

M.fetch_available_lang = function()
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
