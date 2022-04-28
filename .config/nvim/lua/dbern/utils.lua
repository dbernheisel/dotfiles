local M = {}

-- Utilities
M.has = function(x)
  return vim.fn.has(x) == 1
end

M.executable = function(x)
  return vim.fn.executable(x) == 1
end

M.is_dir = function(x)
  return vim.fn.isdirectory(x) == 1
end

M.is_wsl = (function()
  local output = vim.fn.systemlist "uname -r"
  return not not string.find(output[1] or "", "WSL")
end)()

M.is_mac = M.has("maxunix")

M.is_linux = not M.is_wsl and not M.is_mac

M.env_has = function(x, y)
  return string.find(os.getenv(x) or "", y)
end

M.env_present = function(x)
  x = os.getenv(x)
  return x ~= "" and x ~= nil
end

M.is_modern_terminal = function()
  if M.env_has("TERM_PROGRAM", "iTerm") then
    return true
  end

  if M.env_has("TERMINFO", "kitty") then
    return true
  end

  if M.env_present("KITTY_WINDOW_ID") then
    return true
  end

  if M.env_present("SSH_CLIENT") then
    return true
  end

  if M.env_present("ALACRITTY_LOG") then
    return true
  end

  return false
end

return M
