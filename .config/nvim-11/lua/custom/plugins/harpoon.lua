return {
  {
    'ThePrimeagen/harpoon',
    keys = {
      {
        '<leader>H',
        '<cmd>lua require("harpoon.mark").add_file()<CR>',
        mode = { 'n', 'o', 'x' },
      },
      {
        '<leader>h',
        '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>',
        mode = { 'n', 'o', 'x' },
      },
      {
        '<leader>1',
        '<cmd>lua require("harpoon.ui").nav_file(1)<CR>',
        mode = { 'n', 'o', 'x' },
      },
      {
        '<leader>2',
        '<cmd>lua require("harpoon.ui").nav_file(2)<CR>',
        mode = { 'n', 'o', 'x' },
      },
      {
        '<leader>3',
        '<cmd>lua require("harpoon.ui").nav_file(3)<CR>',
        mode = { 'n', 'o', 'x' },
      },
      {
        '<leader>4',
        '<cmd>lua require("harpoon.ui").nav_file(4)<CR>',
        mode = { 'n', 'o', 'x' },
      },
      {
        '<leader>5',
        '<cmd>lua require("harpoon.ui").nav_file(5)<CR>',
        mode = { 'n', 'o', 'x' },
      },
    },
    opts = {
      menu = {
        -- width = vim.api.nvim_win_get_width(0) - 4,
        width = 140,
      },
    },
  },
}
