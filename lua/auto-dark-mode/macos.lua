local utils = require 'auto-dark-mode.utils'

local M = {}

local timer_id
---@type boolean
local is_currently_dark_mode

---@type number
---Every `update_interval` milliseconds a theme check will be performed.
M.update_interval = 3000

function M.set_dark_mode() end
function M.set_light_mode() end

---@param callback fun(is_dark_mode: boolean)
local function check_is_dark_mode(callback)
    utils.start_job('defaults read -g AppleInterfaceStyle', {
        on_exit = function(exit_code)
            local is_dark_mode = exit_code == 0
            callback(is_dark_mode)
        end
    })
end

---@param is_dark_mode boolean
local function change_theme_if_needed(is_dark_mode)
    if (is_dark_mode == is_currently_dark_mode) then return end

    is_currently_dark_mode = is_dark_mode
    if is_currently_dark_mode then
        M.set_dark_mode()
    else
        M.set_light_mode()
    end
end

local function start_check_timer()
    timer_id = vim.fn.timer_start(M.update_interval, function()
        check_is_dark_mode(change_theme_if_needed)
    end, {['repeat'] = -1})
end

function M.init()
    check_is_dark_mode(change_theme_if_needed)
    start_check_timer()
end

function M.disable()
    vim.fn.timer_stop(timer_id)
end

return M
