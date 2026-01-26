local M = {}

-- Utilities
M.has = function(x)
  return vim.fn.has(x) == 1
end

M.app_installed = function(x)
  return vim.fn.isdirectory("/Applications/" .. x) == 1 or
    vim.fn.isdirectory(vim.env.HOME .. "/Applications/" .. x) == 1
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

M.is_mac = M.has("macunix")

M.is_linux = not M.is_wsl and not M.is_mac

M.env_has = function(x, y)
  return string.find(os.getenv(x) or "", y) ~= nil
end

M.env_present = function(x)
  x = os.getenv(x)
  return x ~= "" and x ~= nil
end

M.is_kitty = function()
  M.env_has("TERMINFO", "kitty")
end

M.is_modern_terminal = function()
  return M.env_has("TERM_PROGRAM", "ghostty") or
    M.is_kitty() or
    M.env_has("TERM_PROGRAM", "iTerm") or
    M.env_has("TERM_PROGRAM", "WezTerm") or
    M.env_present("KITTY_WINDOW_ID") or
    M.env_present("SSH_CLIENT") or
    M.env_present("ALACRITTY_LOG") or
    false
end

return M
