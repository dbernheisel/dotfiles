local M = {}

M.setup = function()
  local codecompanion = require('codecompanion')
  codecompanion.setup({
    strategies = {
      chat = {
        adapter = "gemini",
      },
    },
    adapters = {
      gemini = function()
        return require('codecompanion.adapters').extend('gemini', {
          env = {
            api_key = "GOOGLE_AI_API_KEY"
          }
        })
      end
    },
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true
        }
      }
    }
  })
end

return M
