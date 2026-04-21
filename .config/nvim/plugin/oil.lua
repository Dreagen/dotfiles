vim.pack.add({
  'https://github.com/echasnovski/mini.icons',
  'https://github.com/stevearc/oil.nvim',
})
require('oil').setup({
  columns = { 'icon' },
  view_options = {
    show_hidden = true,
  },
})
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
