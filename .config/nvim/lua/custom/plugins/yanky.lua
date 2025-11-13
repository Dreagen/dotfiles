return {
  'gbprod/yanky.nvim',
  config = function()
    local yanky = require 'yanky'
    yanky.setup()

    vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
    vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
    vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
    vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')

    vim.keymap.set('n', '<c-p>', '<Plug>(YankyPreviousEntry)')
    vim.keymap.set('n', '<c-n>', '<Plug>(YankyNextEntry)')

    require('telescope').load_extension 'yank_history'

    vim.keymap.set('n', '<leader>y', ':Telescope yank_history<CR>')
  end,
}
