local M = {}

---@param cmd string
---@param opts table
---@return number | 'the job id'
function M.start_job(cmd, opts)
    opts = opts or {}
    local id = vim.fn.jobstart(cmd, {
        stdout_buffered = opts.buffered == nil and true or opts.buffered,
        on_stdout = function(_, data, _)
            if data and opts.on_stdout then opts.on_stdout(data) end
        end,
        on_exit = function(_, data, _)
            if opts.on_exit then opts.on_exit(data) end
        end
    })

    if opts.input then
        vim.fn.chansend(id, opts.input)
        vim.fn.chanclose(id, 'stdin')
    end

    return id
end

---@return 'win'|'darwin'|'gnome'|'linux'
function M.get_os()
    if package.config:sub(1, 1) == '\\' then
        return 'win'
    elseif (io.popen("uname -s"):read '*a'):match 'Darwin' then
        return 'darwin'
    else
        local _, _, gnome_version = (io.popen('gnome-shell --version'):read '*a'):find '(%d+).%d+'
        if gnome_version and tonumber(gnome_version) >= 42 then
            return 'gnome'
        end
        return 'linux'
    end
end

return M
