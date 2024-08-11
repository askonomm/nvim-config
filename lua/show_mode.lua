_G.show_mode = function()
    local api = vim.api

    -- Get the current mode
    local mode = vim.fn.mode()
    local mode_map = {
        n = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        V = "VISUAL LINE",
        [""] = "VISUAL BLOCK",
        c = "COMMAND",
        R = "REPLACE",
        t = "TERMINAL",
    }

    -- Get the current window dimensions
    local width = api.nvim_win_get_width(0)
    local height = api.nvim_win_get_height(0)

    -- Calculate the position to center the floating window
    local opts = {
        relative = "win",
        width = string.len(mode_map[mode] or mode),
        height = 1,
        row = 0,
        col = 4,
        style = "minimal",
        border = "none"
    }

    -- Create the floating window
    local bufnr = api.nvim_create_buf(false, true)
    api.nvim_buf_set_lines(bufnr, 0, -1, false, { (mode_map[mode] or mode) })

    -- Display the window
    local win_id = api.nvim_open_win(bufnr, false, opts)

    -- Close the window automatically after a short delay
    vim.defer_fn(function()
        api.nvim_win_close(win_id, true)
    end, 1000)
end

-- Create an autocmd to trigger the floating window on mode change
vim.cmd([[
    augroup ShowMode
        autocmd!
        autocmd ModeChanged * lua _G.show_mode()
    augroup END
]])
