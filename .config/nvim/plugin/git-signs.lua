vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })

local gs = require('gitsigns')

vim.keymap.set('n', '<leader>gn', function()
    gs.nav_hunk('next')
end, { desc = 'Next Git hunk' })

vim.keymap.set('n', '<leader>gp', function()
    gs.nav_hunk('prev')
end, { desc = 'Previous Git hunk' })

vim.keymap.set('v', '<leader>gd', function()
    gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end, { desc = 'Discard selected Git lines' })
