# auto-dark-mode.nvim
A Neovim plugin for macOS and Gnome 42+ that automatically changes the editor appearance
based on system settings.
![demo](assets/demo.gif?raw=true)

## Installation
### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'f-person/auto-dark-mode.nvim'
```

## Configuration
You need to call `setup` before initialization.
`setup` accepts a table with options – `set_dark_mode` function,
`set_light_mode` function, and `update_interval` integer.

`set_dark_mode` is called when the system appearance changes to dark mode, and
`set_light_mode` is called when it changes to light mode.
By default, they just change the background option but you can do whatever you like.

`update_interval` is how frequently the system appearance is checked.
The value is stored in milliseconds. Defaults to `3000`.

```lua
local auto_dark_mode = require('auto-dark-mode')

auto_dark_mode.setup({
	update_interval = 1000,
	set_dark_mode = function()
		vim.api.nvim_set_option('background', 'dark')
		vim.cmd('colorscheme gruvbox')
	end,
	set_light_mode = function()
		vim.api.nvim_set_option('background', 'light')
		vim.cmd('colorscheme gruvbox')
	end,
})
auto_dark_mode.init()
```

#### Disable
You can disable `aut-dark-mode.nvim` at runtime via `lua require('aut-dark-mode').disable()`.

## Requirements
* macOS or Gnome 42+
* Neovim
