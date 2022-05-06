-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/dbern/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/dbern/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/dbern/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/dbern/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/dbern/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["FTerm.nvim"] = {
    config = { "require('dbern.plugins.fterm')" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/FTerm.nvim",
    url = "https://github.com/numToStr/FTerm.nvim"
  },
  LuaSnip = {
    config = { "require('dbern.plugins.snippets')" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["calendar.vim"] = {
    config = { "require('dbern.plugins.calendar')" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/calendar.vim",
    url = "https://github.com/itchyny/calendar.vim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-calc"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/cmp-calc",
    url = "https://github.com/hrsh7th/cmp-calc"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-document-symbol"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-document-symbol",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["fzf-lua"] = {
    config = { "require('dbern.plugins.fzf').setup()" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/fzf-lua",
    url = "https://github.com/ibhagwan/fzf-lua"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["goyo.vim"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/goyo.vim",
    url = "https://github.com/junegunn/goyo.vim"
  },
  ["limelight.vim"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/limelight.vim",
    url = "https://github.com/junegunn/limelight.vim"
  },
  ["lualine.nvim"] = {
    config = { "require('dbern.plugins.lualine')" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/hoob3rt/lualine.nvim"
  },
  ["neo-tree.nvim"] = {
    config = { "require('dbern.plugins.neotree').setup()" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  neogit = {
    config = { "require('dbern.plugins.neogit')" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/neogit",
    url = "https://github.com/TimUntersberger/neogit"
  },
  nerdcommenter = {
    config = { "require('dbern.plugins.nerdcomment')" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/nerdcommenter",
    url = "https://github.com/scrooloose/nerdcommenter"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-cmp"] = {
    config = { "require('dbern.plugins.completion')" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    config = { "require('dbern.plugins.dap')" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-jdtls"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/nvim-jdtls",
    url = "https://github.com/mfussenegger/nvim-jdtls"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    config = { "require('dbern.lsp')" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-spectre"] = {
    config = { "require('dbern.plugins.spectre').setup()" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/nvim-spectre",
    url = "https://github.com/windwp/nvim-spectre"
  },
  ["nvim-treesitter"] = {
    config = { "require('dbern.plugins.treesitter').setup()" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    config = { "require('dbern.plugins.nvim-web-devicons')" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  onehalf = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/onehalf/vim/",
    url = "https://github.com/sonph/onehalf"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  sonokai = {
    config = { "require('dbern.theme').setup()" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/sonokai",
    url = "https://github.com/sainnhe/sonokai"
  },
  tabular = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/tabular",
    url = "https://github.com/godlygeek/tabular"
  },
  ["trouble.nvim"] = {
    config = { "require('dbern.plugins.trouble')" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vim-colors-pencil"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/vim-colors-pencil",
    url = "https://github.com/reedes/vim-colors-pencil"
  },
  ["vim-eunuch"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/vim-eunuch",
    url = "https://github.com/tpope/vim-eunuch"
  },
  ["vim-fugitive"] = {
    config = { "require('dbern.plugins.fugitive')" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-mkdir"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/vim-mkdir",
    url = "https://github.com/pbrisbin/vim-mkdir"
  },
  ["vim-pencil"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/vim-pencil",
    url = "https://github.com/reedes/vim-pencil"
  },
  ["vim-projectionist"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/vim-projectionist",
    url = "https://github.com/tpope/vim-projectionist"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-signify"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/vim-signify",
    url = "https://github.com/mhinz/vim-signify"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-test"] = {
    config = { "require('dbern.plugins.test')" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/vim-test",
    url = "https://github.com/vim-test/vim-test"
  },
  ["vim-visual-multi"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/vim-visual-multi",
    url = "https://github.com/mg979/vim-visual-multi"
  },
  ["vim-wordy"] = {
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/vim-wordy",
    url = "https://github.com/reedes/vim-wordy"
  },
  ["virt-column.nvim"] = {
    config = { "require('virt-column').setup()" },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/virt-column.nvim",
    url = "https://github.com/lukas-reineke/virt-column.nvim"
  },
  winresizer = {
    config = { "      vim.api.nvim_set_keymap('t', '<c-e>', '<c-\\\\><c-n>:WinResizerStartResize<cr>', { noremap = true })\n    " },
    loaded = true,
    path = "/home/dbern/.local/share/nvim/site/pack/packer/start/winresizer",
    url = "https://github.com/simeji/winresizer"
  }
}

time([[Defining packer_plugins]], false)
-- Runtimepath customization
time([[Runtimepath customization]], true)
vim.o.runtimepath = vim.o.runtimepath .. ",/home/dbern/.local/share/nvim/site/pack/packer/start/onehalf/vim/"
time([[Runtimepath customization]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
require('dbern.plugins.treesitter').setup()
time([[Config for nvim-treesitter]], false)
-- Config for: neogit
time([[Config for neogit]], true)
require('dbern.plugins.neogit')
time([[Config for neogit]], false)
-- Config for: sonokai
time([[Config for sonokai]], true)
require('dbern.theme').setup()
time([[Config for sonokai]], false)
-- Config for: neo-tree.nvim
time([[Config for neo-tree.nvim]], true)
require('dbern.plugins.neotree').setup()
time([[Config for neo-tree.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
require('dbern.plugins.trouble')
time([[Config for trouble.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
require('dbern.plugins.lualine')
time([[Config for lualine.nvim]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
require('dbern.plugins.snippets')
time([[Config for LuaSnip]], false)
-- Config for: nvim-web-devicons
time([[Config for nvim-web-devicons]], true)
require('dbern.plugins.nvim-web-devicons')
time([[Config for nvim-web-devicons]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
require('dbern.plugins.completion')
time([[Config for nvim-cmp]], false)
-- Config for: nerdcommenter
time([[Config for nerdcommenter]], true)
require('dbern.plugins.nerdcomment')
time([[Config for nerdcommenter]], false)
-- Config for: vim-test
time([[Config for vim-test]], true)
require('dbern.plugins.test')
time([[Config for vim-test]], false)
-- Config for: winresizer
time([[Config for winresizer]], true)
      vim.api.nvim_set_keymap('t', '<c-e>', '<c-\\><c-n>:WinResizerStartResize<cr>', { noremap = true })
    
time([[Config for winresizer]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
require('dbern.lsp')
time([[Config for nvim-lspconfig]], false)
-- Config for: vim-fugitive
time([[Config for vim-fugitive]], true)
require('dbern.plugins.fugitive')
time([[Config for vim-fugitive]], false)
-- Config for: nvim-dap
time([[Config for nvim-dap]], true)
require('dbern.plugins.dap')
time([[Config for nvim-dap]], false)
-- Config for: virt-column.nvim
time([[Config for virt-column.nvim]], true)
require('virt-column').setup()
time([[Config for virt-column.nvim]], false)
-- Config for: nvim-spectre
time([[Config for nvim-spectre]], true)
require('dbern.plugins.spectre').setup()
time([[Config for nvim-spectre]], false)
-- Config for: calendar.vim
time([[Config for calendar.vim]], true)
require('dbern.plugins.calendar')
time([[Config for calendar.vim]], false)
-- Config for: FTerm.nvim
time([[Config for FTerm.nvim]], true)
require('dbern.plugins.fterm')
time([[Config for FTerm.nvim]], false)
-- Config for: fzf-lua
time([[Config for fzf-lua]], true)
require('dbern.plugins.fzf').setup()
time([[Config for fzf-lua]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
