vim.api.nvim_create_user_command('CloseAllFloatingWindows', function()
    local closed_windows = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= "" then
        vim.api.nvim_win_close(win, false)
        table.insert(closed_windows, win)
      end
    end
    print(string.format('Closed %d windows: %s', #closed_windows, vim.inspect(closed_windows)))
end, {})

function get_buffer_number_by_pattern(pattern)
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match(pattern) then
            return buf
        end
    end
    return nil -- Return nil if no matching buffer is found
end

function move_buffer_to_new_tab(buffer_number)
    if vim.api.nvim_buf_is_valid(buffer_number) then
        local current_window = vim.api.nvim_get_current_win()
        vim.cmd("tabnew")
        vim.api.nvim_win_set_buf(0, buffer_number)
        vim.api.nvim_win_close(current_window, true)
    else
        print("Invalid buffer number")
    end
end

-- vim.api.nvim_create_user_command('MoveBufferToNewTab', move_buffer_to_new_tab, {})
