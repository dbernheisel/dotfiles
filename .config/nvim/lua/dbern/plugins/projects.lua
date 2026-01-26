local M = {}

-- Configuration: Add your project folders here
M.projects = {
  { name = "DateTimePicker", path = "~/date_time_parser" },
  { name = "PhantomMCP", path = "~/phantom_mcp" },
  { name = "RunCom", path = "~/runcom" },
  { name = "Grove", path = "~/grove" },
  { name = "Bash", path = "~/bash" },
  { name = "Safe Ecto Migrations", path = "~/safe-ecto-migrations" },
  { name = "Shh", path = "~/shh" },
  { name = "elixirstream.dev", path = "~/elixirstream" },
  { name = "neovim config", path = "~/.config/nvim" },
  { name = "tvlabs", path = "~/platform/*" },
}

-- Check if a folder is hidden (starts with .)
local function is_hidden(name)
  return name:match("^%.") ~= nil
end

-- Expand a project entry that may contain a glob pattern
local function expand_project(project_config)
  local expanded = {}

  -- Check if path contains a glob pattern
  if project_config.path:match("%*") then
    -- Extract the parent directory from the glob pattern
    local parent_path = project_config.path:gsub("/%*$", "")
    parent_path = vim.fn.expand(parent_path)

    -- Use fs_scandir to list all entries in the directory
    local handle = vim.uv.fs_scandir(parent_path)
    if not handle then
      return expanded
    end

    local count = 0
    while true do
      local name, type = vim.uv.fs_scandir_next(handle)
      if not name then break end

      -- Only process directories that are not hidden
      if type == "directory" and not is_hidden(name) then
        local full_path = parent_path .. "/" .. name
        table.insert(expanded, {
          name = project_config.name .. "/" .. name,
          path = full_path,
        })
        count = count + 1
      end
    end
  else
    -- Regular path, just use it directly
    local path = vim.fn.expand(project_config.path)
    table.insert(expanded, {
      name = project_config.name,
      path = path,
    })
  end

  return expanded
end

-- Get all available projects (expanding globs)
local function get_all_projects()
  local all_projects = {}

  for _, project_config in ipairs(M.projects) do
    local expanded = expand_project(project_config)
    for _, project in ipairs(expanded) do
      table.insert(all_projects, project)
    end
  end

  -- Sort projects alphabetically by name
  table.sort(all_projects, function(a, b)
    return a.name < b.name
  end)

  return all_projects
end

-- Switch to a project
local function switch_project(project)
  vim.cmd("cd " .. vim.fn.fnameescape(project.path))
  vim.notify("Switched to project: " .. project.name .. "\nPath: " .. project.path, vim.log.levels.INFO)
end

-- Open project picker
M.pick_project = function()
  if not Snacks then
    vim.notify("Snacks.nvim is not loaded", vim.log.levels.ERROR)
    return
  end

  -- Get all expanded projects
  local all_projects = get_all_projects()

  if #all_projects == 0 then
    vim.notify("No projects found! Check your M.projects configuration.", vim.log.levels.WARN)
    return
  end

  -- Prepare items for picker
  local items = {}
  for _, project in ipairs(all_projects) do
    local path = vim.fn.fnamemodify(project.path, ":~")
    local readme_path = project.path .. "/README.md"

    local item = {
      text = project.name,
      path = path,
      full_path = project.path,
    }

    -- Only set preview field if README exists
    local fd, err = vim.uv.fs_open(readme_path, "r", 444)
    if not err and fd then
      local stat, stat_err = vim.uv.fs_fstat(fd)
      if not stat_err and stat and stat.type == "file" then
        local data, read_err = vim.uv.fs_read(fd, 10000)
        if not read_err and data then
          item.preview = { ft = "markdown", text = read_err or data }
        end
      end
    end

    if not item.preview then
      item.preview = { ft = "markdown", text = "No README.md" }
    end

    table.insert(items, item)
  end

  -- Use Snacks.picker.pick with items directly
  Snacks.picker.pick({
    items = items,
    prompt = "Open Project> ",
    format = function(item, _picker)
      -- Return array of {text, highlight_group} pairs
      return {
        { item.text, "Normal" },
        { " ", "Normal" },
        { item.path, "Comment" },
      }
    end,
    preview = "preview",
    confirm = function(picker, item)
      if item then
        switch_project({ name = item.text, path = item.full_path })
        picker:close()
      end
    end,
  })
end

return M
