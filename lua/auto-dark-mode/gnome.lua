local utils = require 'auto-dark-mode.utils'

local M = {}

---@number
local running_monitor

function M.set_dark_mode() end
function M.set_light_mode() end

local function check_is_dark_mode()
    utils.start_job('gsettings get org.gnome.desktop.interface color-scheme', {
        on_stdout = function(data)
            local output = table.concat(data, "\n")
            if output:match(".+prefer.dark.+") then
                M.set_dark_mode()
            else
                M.set_light_mode()
            end
        end,
    })
end

local function start_monitor()
    running_monitor = utils.start_job('gsettings monitor org.gnome.desktop.interface color-scheme', {
        buffered = false,
        on_stdout = function(data)
            local output = table.concat(data, "\n")
            if output:match(".+prefer.dark.+") then
                M.set_dark_mode()
            else
                M.set_light_mode()
            end
        end
    })
end

function M.init()
    check_is_dark_mode()
    start_monitor()
end

function M.disable()
    vim.fn.jobstop(running_monitor)
end

return M
