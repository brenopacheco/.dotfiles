local uv = vim.loop

local M = {}

M.readFile = function(path, callback)
  return uv.fs_open(path, 'r', 438, function(open_err, fd)
    assert(not open_err, open_err)
    return uv.fs_fstat(fd, function(fstat_err, stat)
      assert(not fstat_err, fstat_err)
      return uv.fs_read(fd, stat.size, 0, function(read_err, data)
        assert(not read_err, read_err)
        return uv.fs_close(fd, function(close_err)
          assert(not close_err, close_err)
          local wrapper = function() callback(data) end
          return vim.schedule(wrapper)
        end)
      end)
    end)
  end)
end

return M
