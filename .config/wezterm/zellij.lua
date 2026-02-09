local wezterm = require("wezterm")

local M = {}

local alt_screen_apps = { nvim=1, vim=1, vi=1, less=1, more=1, man=1, htop=1, top=1, btop=1, bat=1 }
local alt_screen_cache = { result = false, time = 0 }

function M.is_alt_screen(pane)
  local vars = pane:get_user_vars()
  if not vars.zellij_session or not M.bin then
    return false
  end

  local now = os.time()
  if now - alt_screen_cache.time < 2 then
    return alt_screen_cache.result
  end

  local success, stdout = wezterm.run_child_process({
    M.bin, '-s', vars.zellij_session, 'action', 'list-clients',
  })
  if not success then
    alt_screen_cache = { result = false, time = now }
    return false
  end

  -- list-clients output: CLIENT_ID ZELLIJ_PANE_ID RUNNING_COMMAND
  -- RUNNING_COMMAND is only present when it's not the default shell
  for line in stdout:gmatch('[^\n]+') do
    local cmd = line:match('^%d+%s+%S+%s+(%S+)')
    if cmd then
      local name = cmd:match('([^/]+)$') or cmd
      if alt_screen_apps[name] then
        alt_screen_cache = { result = true, time = now }
        return true
      end
    end
  end

  alt_screen_cache = { result = false, time = now }
  return false
end

function M.find_binary()
  local paths = { '/opt/homebrew/bin/zellij', os.getenv('HOME') .. '/.local/bin/zellij' }
  for _, p in ipairs(paths) do
    local f = io.open(p, 'r')
    if f then
      f:close()
      return p
    end
  end
  local success, stdout = wezterm.run_child_process({ '/bin/sh', '-c', 'command -v zellij' })
  if success then
    return stdout:gsub('%s+$', '')
  end
  return nil
end

-- Cache the binary path
M.bin = M.find_binary()

return M
