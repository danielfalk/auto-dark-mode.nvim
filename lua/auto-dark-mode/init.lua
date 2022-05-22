local utils = require 'auto-dark-mode.utils'

---@type string
local current_os

---@type fun()
local set_light_mode

---@type fun()
local set_dark_mode

local function get_provider()
    current_os = current_os or utils.get_os()

    if current_os == 'darwin' then
        return require 'auto-dark-mode.macos'
    else
        return require 'auto-dark-mode.gnome'
    end
end

local function init()
    current_os = current_os or utils.get_os()
    if current_os ~= 'darwin' and current_os ~= 'gnome' then return end

    if not set_dark_mode or not set_light_mode then
        error([[

        Call `setup` first:

        require('auto-dark-mode').setup({
            set_dark_mode=function()
                vim.api.nvim_set_option('background', 'dark')
                vim.cmd('colorscheme gruvbox')
            end,
            set_light_mode=function()
                vim.api.nvim_set_option('background', 'light')
            end,
        })
        ]])
    end

    local provider = get_provider()
    provider.set_dark_mode = set_dark_mode
    provider.set_light_mode = set_light_mode
    provider.init()
end

---@param options table<string, fun()>
---`options` contains two function - `set_dark_mode` and `set_light_mode`
local function setup(options)
    options = options or {}

    ---@param background string
    local function set_background(background)
        vim.api.nvim_set_option('background', background)
    end

    local provider = get_provider()

    set_dark_mode = options.set_dark_mode or
                        function() set_background('dark') end
    set_light_mode = options.set_light_mode or
                         function() set_background('light') end
    provider.update_interval = options.update_interval or 3000
end

local function disable()
    get_provider().disable()
end

return {setup = setup, init = init, disable = disable}
