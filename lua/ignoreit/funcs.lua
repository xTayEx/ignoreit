local M = {}

local Job = require("plenary.job")
local Async = require("plenary.async")
local lang_list = require("ignoreit.lang_list")
local rooter = require("ignoreit.rooter")

-- import telescope related modules
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

M.fetch_and_set_lang_gitignore = function(lang, root_dir)
  -- curl -sL https://www.toptal.com/developers/gitignore/api/\$@
  local gitignore_provider_url = "https://www.toptal.com/developers/gitignore/api/"
  local gitignore_content = ""
  local request_func = function()
    ---@diagnostic disable-next-line: missing-fields
    Job:new({
      command = "curl",
      args = { "-sL", gitignore_provider_url .. lang },
      cwd = vim.fn.getcwd(),
      env = {},
      on_exit = function(result, exit_code)
        if exit_code ~= 0 then
          vim.notify("Error fetching gitignore for " .. lang, vim.log.levels.ERROR)
          return
        end
        gitignore_content = vim.iter(result:result()):join("\n") or ""
      end,
    }):sync()
  end

  local create_gitignore_file = function()
    local gitignore_file = io.open(root_dir .. "/.gitignore", "w")
    if gitignore_file == nil then
      vim.notify("Error creating .gitignore file", vim.log.levels.ERROR)
      return
    end
    gitignore_file:write(gitignore_content)
    gitignore_file:close()

    local cache_dir = vim.fn.stdpath("cache")
    ---@diagnostic disable-next-line: param-type-mismatch
    local gitignore_cache_dir = vim.fs.joinpath(cache_dir, lang .. ".gitignore")

    local cache_file = io.open(gitignore_cache_dir, "w")
    if cache_file == nil then
      vim.notify("Error creating cache file", vim.log.levels.ERROR)
      return
    end
    cache_file:write(gitignore_content)
    cache_file:close()
  end

  local cache_dir = vim.fn.stdpath("cache")
  ---@diagnostic disable-next-line: param-type-mismatch
  local gitignore_cache_path = vim.fs.joinpath(cache_dir, lang .. ".gitignore")
  if vim.fn.filereadable(gitignore_cache_path) == 0 then
    Async.run(request_func, create_gitignore_file)
  else
    local gitignore_cache_file = io.open(gitignore_cache_path, "r")
    if gitignore_cache_file == nil then
      vim.notify("Error reading cache file", vim.log.levels.ERROR)
      return
    end
    gitignore_content = gitignore_cache_file:read("a")
    gitignore_cache_file:close()

    local gitignore_file = io.open(root_dir .. "/.gitignore", "w")
    if gitignore_file == nil then
      vim.notify("Error creating .gitignore file", vim.log.levels.ERROR)
      return
    end
    vim.notify("Using cached gitignore for " .. lang, vim.log.levels.INFO)
    gitignore_file:write(gitignore_content)
    gitignore_file:close()
  end
end

local detect_root = function(rooter_method, opts)
  local root_dir = ""
  if rooter_method == "lsp" then
    root_dir = rooter.find_root_by_lsp()
  elseif rooter_method == "pattern" then
    root_dir = rooter.find_root_by_pattern(opts)
  else
    vim.notify("Invalid rooter method", vim.log.levels.ERROR)
    return nil
  end
  root_dir = root_dir or vim.fn.getcwd()
  return root_dir
end

---@return integer
M.generate_gitignore = function(lang, opts)
  local rooter_method = opts.rooter_method
  local root_dir = detect_root(rooter_method, opts)
  vim.notify("Root dir is " .. root_dir, vim.log.levels.INFO)
  M.fetch_and_set_lang_gitignore(lang, root_dir)

  return 0
end

---@return integer
M.generate_gitignore_interactively = function(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", require("telescope.themes").get_dropdown({}), opts)
  local rooter_method = opts.rooter_method
  local root_dir = detect_root(rooter_method, opts)
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
          local selected_lang = action_state.get_selected_entry()[1]
          M.fetch_and_set_lang_gitignore(selected_lang, root_dir)
        end)
        return true
      end,
    })
    :find()

  return 0
end

return M
