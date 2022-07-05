local M = {}

M.mix_fzf = function(selection)
  if selection then
    M.mix_run(selection)
  else
    local lines = {}
    local result = io.popen("mix help --names")
    if result then
      for line in result:lines() do
        if line ~= "do" then
          table.insert(lines, line)
        end
      end
      result:close()

      vim.ui.select(lines, { prompt = "mix> ", kind = "codeaction" }, M.mix_run)
    end
  end
end

return M
