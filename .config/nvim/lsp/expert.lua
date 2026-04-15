local homedir = vim.uv.os_homedir()
local osInfo = vim.uv.os_uname()
local arch
if osInfo.machine == "x86_64" then
  arch = "amd64"
else
  arch = string.lower(osInfo.machine)
end
local expert = vim.fn.resolve(homedir .. "/.local/bin/expert_" .. string.lower(osInfo.sysname) .. "_" .. arch)
-- local expert = vim.fn.resolve(homedir .. "/expert/apps/expert/_build/prod/rel/plain/bin/start_expert")

return {
  cmd = { expert, '--stdio' },
  settings = {
    codelens = { enable = true },
  },
  filetypes = { 'elixir', 'eelixir', 'heex' },
  root_markers = { 'mix.exs' },
}
