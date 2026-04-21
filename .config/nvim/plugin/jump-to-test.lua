vim.pack.add({ 'https://github.com/Dreagen/jump-to-test.nvim' })

vim.keymap.set({ 'n', 'o', 'x' }, '<leader>jt', function() require('jump-to-test').toggle() end,         { desc = 'Jump to test toggle' })
vim.keymap.set({ 'n', 'o', 'x' }, '<leader>je', function() require('jump-to-test').jump_to_test() end,   { desc = 'Jump to test' })
vim.keymap.set({ 'n', 'o', 'x' }, '<leader>js', function() require('jump-to-test').jump_to_source() end, { desc = 'Jump to source' })
