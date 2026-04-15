local M = {}

local timer = nil
local focus_bin = vim.fn.expand("~/.local/bin/focus")
local notify_opts = { id = "focus", title = "Focus", style = "fancy", timeout = 10000 }

local function fetch_and_notify()
  vim.system(
    { focus_bin, "--list" },
    { text = true },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 or not result.stdout or result.stdout == "" then
        vim.notify("Focus: Are you working on what you should be?", vim.log.levels.WARN, notify_opts)
        return
      end

      local ok, issues = pcall(vim.json.decode, result.stdout)
      if not ok or #issues == 0 then
        return
      end

      -- Find in-progress (started) issues
      local in_progress = {}
      local todo = {}
      for _, issue in ipairs(issues) do
        if issue.state_type == "started" then
          table.insert(in_progress, issue)
        elseif issue.state_type == "unstarted" then
          table.insert(todo, issue)
        end
      end

      if #in_progress > 0 then
        local lines = { "Focus: In progress" }
        for _, issue in ipairs(in_progress) do
          table.insert(lines, "  " .. issue.title)
        end
        vim.notify(table.concat(lines, "\n"), vim.log.levels.WARN, notify_opts)
      elseif #todo > 0 then
        local lines = { "Focus: Consider working on" }
        for i = 1, math.min(3, #todo) do
          table.insert(lines, "  " .. todo[i].title)
        end
        vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, notify_opts)
      end
    end)
  )
end

function M.start()
  if timer then
    return
  end

  local interval = 15 * 60 * 1000

  timer = vim.uv.new_timer()
  timer:start(interval, interval, vim.schedule_wrap(fetch_and_notify))
end

function M.stop()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

function M.check()
  fetch_and_notify()
end

if vim.fn.executable(focus_bin) == 1 then
  M.start()
else
  vim.notify("Focus is not availble on this system", vim.log.levels.INFO, notify_opts)
end

return M
