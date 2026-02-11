local wezterm = require("wezterm")

local M = {}

local alt_screen_apps = { nvim=1, vim=1, vi=1, less=1, more=1, man=1, htop=1, top=1, btop=1, bat=1 }
local alt_screen_cache = {}

function M.is_alt_screen(pane)
  local vars = pane:get_user_vars()
  local zs = vars.zellij_session
  if not zs or not M.bin then
    return false
  end

  local cached = alt_screen_cache[zs]
  local now = os.time()
  if cached and now - cached.time < 5 then
    return cached.result
  end

  local success, stdout = wezterm.run_child_process({
    M.bin, '-s', zs, 'action', 'list-clients',
  })
  if not success then
    alt_screen_cache[zs] = { result = false, time = now }
    return false
  end

  -- Only check the first client's focused pane command.
  -- list-clients is session-wide; checking all clients would falsely
  -- detect alt-screen when another client is focused on a different pane.
  for line in stdout:gmatch('[^\n]+') do
    local cmd = line:match('^%d+%s+%S+%s+(%S+)')
    if cmd then
      local name = cmd:match('([^/]+)$') or cmd
      local result = alt_screen_apps[name] ~= nil
      alt_screen_cache[zs] = { result = result, time = now }
      return result
    end
  end

  alt_screen_cache[zs] = { result = false, time = now }
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
