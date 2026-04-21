vim.pack.add({ 'https://github.com/gbprod/yanky.nvim' })

require('yanky').setup()
vim.keymap.set('n', '<leader>y', function() Snacks.picker.yanky() end, { desc = 'Yank history' })
