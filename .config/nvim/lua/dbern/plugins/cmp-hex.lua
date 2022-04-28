local cmp = require('cmp')
local Job = require('plenary.job')
local endpoint = "https://hex.pm/api"
local json_decode_opts = { luanil = { object = true, array = true } }
local useragent = vim.fn.shellescape("cmp-hex (https://github.com/dbernheisel/cmp-hex.nvim)")

local source = {}
local doc_cache = {}
local version_cache = {}


source.new = function()
  return setmetatable({
    running_job_id = 0,
    timer = vim.loop.new_timer()
  }, { __index = source })
end

-- defp deps do
--   [
--      search for packages - NOT CACHED
--      vvvvvvvvv
--     {:hex_core, "~> 0.2"},
--                 ^^^^^^^^
--                  search for package version
--                  CACHED
--
--     documentation displays `mix hex.info {package}`
--     CACHED
--   ]
-- end

function source:is_available()
  local filename = vim.fn.expand('%:t')
  return filename == "mix.exs" and vim.fn.executable("hex_complete") and vim.fn.executable("mix")
end

function source:get_debug_name()
  return 'hex'
end
--
-- function source:get_trigger_characters()
--   return { ":", '"' }
-- end
--
function source:get_keyword_pattern(_)
   return [[\([^"'\%^<>=~,\s]\)*]]
end


function source:get_trigger_characters(_)
   return { '"', "'", ".", "<", ">", "=", "^", "~", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
end


function source:resolve(completion_item, callback)
  local name = completion_item.data.name
  if doc_cache[name] then
    completion_item.documentation = {
      kind = cmp.lsp.MarkupKind.PlainText,
      value = doc_cache[name]
    }
  else
    Job:new({
      command = "mix",
      args = { "hex.info", name },
      on_exit = function(result, status)
        if status == 0 then
          doc_cache[name] = table.concat(result:result(), "\n")
          completion_item.documentation = {
            kind = cmp.lsp.MarkupKind.PlainText,
            value = doc_cache[name]
          }
        end
      end
    }):sync()
  end
  callback(completion_item)
end

function source:complete(params, callback)
  local cur_line = params.context.cursor_line
  local cur_col = params.context.cursor.col
  local name = string.match(cur_line, '%s*{:([^,]*),?')
  if name == nil then return end
  if name == "" then return end
  local _, idx_after_comma = string.find(cur_line, '.*,.*')
  if idx_after_comma and cur_col >= idx_after_comma then
    if version_cache[name] then
      callback({ items = version_cache[name] })
    else
      local items = {}

      Job:new({
        command = "curl",
        args = {"-sLA", "cmp-hex", "--input", name, "--versions"},
        on_stdout = function(_, version, _job)
          table.insert(items, {
            data = { name = name },
            label = version,
            detail = "mix hex.info "..name
          })
          callback({items = items, isIncomplete = true})
        end,
        on_exit = function(_job)
          callback({items = items, isIncomplete = false})
        end
      }):start()
      -- local on_event = function(_job_id, data, event)
      --   if event == "stdout" then
      --     for _, version in ipairs(data) do
      --       if version ~= "" then
      --         table.insert(items, {
      --           data = { name = name },
      --           label = version,
      --           detail = "mix hex.info "..name
      --         })
      --         callback({items = items, isIncomplete = true})
      --       end
      --     end
      --   end
      --
      --   if event == "stderr" then
      --     vim.cmd('echohl Error')
      --     print(table.concat(data, ""))
      --     vim.cmd('echohl None')
      --   end
      --
      --   if event == "exit" then
      --     version_cache[name] = items
      --     callback({items = items, isIncomplete = false})
      --   end
      -- end
      --
      -- self.timer:stop()
      -- self.timer:start(
      --   params.option.debounce or 100,
      --   0,
      --   vim.schedule_wrap(function()
      --     vim.fn.jobstop(self.running_job_id)
      --     self.running_job_id = vim.fn.jobstart(
      --       string.format("hex_complete --input %s --versions", name),
      --       { on_stderr = on_event, on_stdout = on_event, on_exit = on_event, cwd = vim.fn.getcwd() }
      --     )
      --   end)
      -- )
    end
  else
    local items = {}

    Job:new({
      command = "hex_complete",
      args = {"--input", name},
      on_stdout = function(_, hex_package, _job)
        table.insert(items, {
          data = { name = hex_package },
          label = ":"..hex_package,
          insertText = hex_package,
          detail = "mix hex.info "..hex_package
        })
        callback({items = items, isIncomplete = true})
      end,
      on_exit = function(_job)
        callback({items = items, isIncomplete = false})
      end
    }):start()

    -- local on_event = function(_job_id, data, event)
    --   if event == "stdout" then
    --     for _, hex_package in ipairs(data) do
    --       if hex_package ~= "" then
    --         table.insert(items, {
    --           data = { name = hex_package },
    --           label = ":"..hex_package,
    --           insertText = hex_package,
    --           detail = "mix hex.info "..hex_package
    --         })
    --         callback({items = items, isIncomplete = true})
    --       end
    --     end
    --   end
    --
    --   if event == "stderr" then
    --     vim.cmd('echohl Error')
    --     print(table.concat(data, ""))
    --     vim.cmd('echohl None')
    --   end
    --
    --   if event == "exit" then
    --     callback({items = items, isIncomplete = false})
    --   end
    -- end
    --
    -- self.timer:stop()
    -- self.timer:start(
    --   params.option.debounce or 100,
    --   0,
    --   vim.schedule_wrap(function()
    --     vim.fn.jobstop(self.running_job_id)
    --     print(string.format("hex_complete --input %s", name))
    --     self.running_job_id = vim.fn.jobstart(
    --       string.format("hex_complete --input %s", name),
    --       { on_stderr = on_event, on_stdout = on_event, on_exit = on_event, cwd = vim.fn.getcwd() }
    --     )
    --   end)
    -- )
  end
end

function source:execute(completion_item, callback)
  callback(completion_item)
end

cmp.register_source("hex", source.new())

return source
