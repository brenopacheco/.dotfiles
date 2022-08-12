local uv = vim.loop

local M = {}

--- Run task in a separate thread and callback in main thread on return.
-- Example:
-- <pre>
--   async(function() return "foo" end, function(result) print(result) end)
-- </pre>
-- @param task function       A task to run in the separate thread.
--                            Return value is passed to parameter {callback}
-- @param callback function   A callback to run in the main thread.
--                            Runs with task results once it is done.
-- @return luv_thread_t userdata or fail
function M.async(task, callback)
  local async
  async = uv.new_async(vim.schedule_wrap(function(results)
    async:close()
    callback(results)
  end))
  local func = function(a, t) a:send(loadstring(t)()) end
  return uv.new_thread(func, async, string.dump(task))
end

return M


-- threads do not have access to vim.fn.systemlist()
-- TODO: implement custom systemlist using uv.spawn
--       add here as M.systemlist
--       use in task as require('utils.async').systemlist()




-- NOTES:
--
-- *lua-loop-callbacks*
--
-- vim.defer_fn
-- vim.wait
--
-- vim.schedule(callback)
--   run this whenever the event loop has some time to do so
--   used in contexts where we cannot access something
--     e.g: nvim_buf_attach on_lines
--     threads do not have access to it
--
-- uv = vim.loop      -> libuv exposed functions
-- uv.new_async
--   + function executed by the main loop thread
--   + can be called by other threads
--   + receives arguments from other threads
--
--
-- vim.json       -> lua cjson lib exposed
-- vim.json.encode({foo = "bar"}) -> string '{"foo": "bar"}'
-- vim.json.decode('{"foo": "bar"}') -> table {foo = "bar"}
--   cannot serialize function
--
-- vim.mpack      -> message pack serialization
-- vim.mpack.encode({foo = "bar"}) -> string "<81><a3>foo<a3>bar"
--
-- *** userdata .. what is userdata in lua?
-- *** upvalues .. what are upvalues?
--
--
-- schedule_wrap will defer until it is safe to run (bridges gap from libuv)



-- local function task()
--   local uv = vim.loop
--   local stdin = nil
--   local stdout = uv.new_pipe()
--   local stderr = uv.new_pipe()

--   local close_handle = function(handle)
--     if handle and not handle:is_closing() then handle:close() end
--   end

--   local handle

--   local path = 'fd'
--   local options = {
--     args = {'-p', '.'},
--     stdio = {stdin, stdout, stderr},
--     cwd = '/tmp',
--     env = {}
--   }

--   local s = {}

--   local on_exit = function(code, signal)
--     -- print('exit code', code)
--     -- print('exit signal', signal)
--     vim.pretty_print({data = s, code = code, signal = signal})
--     stdout:read_stop()
--     stdout:read_stop()
--     close_handle(stdout)
--     close_handle(stderr)
--     close_handle(handle)
--   end

--   handle, pid = uv.spawn(path, options, on_exit)

--   local handler = function(err, data)
--     if data then for w in data:gmatch('(.-)\n') do table.insert(s, w) end end
--     if err then print(err) end
--   end

--   uv.read_start(stderr, handler)
--   uv.read_start(stdout, handler)
-- end
