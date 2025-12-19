# BLB.nvim
A plugin to search the selected text on https://www.blueletterbible.org.

## Features
- Run `:BLB` to open a window on BLB with the last selected text.
- Set default translation `config.translation`.
- Attempts to detect translation from the last term in the search (eg. `Psa 63:3 ESV`)

## Installation
### Lazy.nvim
```
{
  'joshepen/blb.nvim',
  config = function()
    local blb = require 'blb'
    blb.setup()
    blb.config.translation = 'ESV'
  end,
  keys = {
    { '<leader>b', '<Esc>:BLB<CR>', desc = 'Open Blue Letter Bible', mode = { 'n', 'v' } },
  },
}
```

### Manual Install:
- `cp -r ./lua/blb/ /path/to/your/nvim/lua/`
- Add the following somewhere in your config:
```
local blb = require 'blb'
blb.setup()
vim.keymap.set({ 'n', 'v' }, '<leader>b', '<Esc>:BLB<CR>', { desc = 'Open Blue Letter Bible' })
```
