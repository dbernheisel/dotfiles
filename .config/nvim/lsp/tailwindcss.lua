local filetypes = {
  'aspnetcorerazor', 'astro', 'blade', 'clojure', 'django-html', 'htmldjango',
  'edge', 'eelixir', 'elixir', 'ejs', 'erb', 'eruby', 'gohtml', 'gohtmltmpl',
  'haml', 'handlebars', 'hbs', 'html', 'htmlangular', 'html-eex', 'heex',
  'jade', 'leaf', 'liquid', 'mustache', 'njk', 'nunjucks',
  'php', 'razor', 'slim', 'twig',
  'css', 'less', 'postcss', 'sass', 'scss', 'stylus', 'sugarss',
  'javascript', 'javascriptreact', 'reason', 'rescript', 'typescript', 'typescriptreact',
  'vue', 'svelte', 'templ',
}

--- Check if a file contains a field/string pattern
local function file_contains(path, pattern)
  local f = io.open(path, 'r')
  if not f then return false end
  local content = f:read('*a')
  f:close()
  return content:find(pattern) ~= nil
end

return {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  filetypes = filetypes,
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    -- Check for tailwind/postcss config files
    local root = vim.fs.root(fname, {
      'tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.mjs', 'tailwind.config.ts',
      'postcss.config.js', 'postcss.config.cjs', 'postcss.config.mjs', 'postcss.config.ts',
    })
    if root then
      on_dir(root)
      return
    end
    -- Check package.json for tailwindcss dependency
    local pkg_root = vim.fs.root(fname, { 'package.json' })
    if pkg_root and file_contains(pkg_root .. '/package.json', 'tailwindcss') then
      on_dir(pkg_root)
      return
    end
    -- Check mix.lock for tailwind (Phoenix projects)
    local mix_root = vim.fs.root(fname, { 'mix.lock' })
    if mix_root and file_contains(mix_root .. '/mix.lock', 'tailwind') then
      on_dir(mix_root)
      return
    end
    -- Tailwind v4 fallback (no config file needed)
    local git_root = vim.fs.root(fname, { '.git' })
    if git_root then
      on_dir(git_root)
    end
  end,
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidScreen = 'error',
        invalidVariant = 'error',
        invalidConfigPath = 'error',
        invalidTailwindDirective = 'error',
        recommendedVariantOrder = 'warning',
      },
      classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
      includeLanguages = {
        eelixir = 'html-eex',
        elixir = 'phoenix-heex',
        eruby = 'erb',
        heex = 'phoenix-heex',
        htmlangular = 'html',
        templ = 'html',
      },
    },
  },
}
