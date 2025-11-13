return {
  'sindrets/diffview.nvim',
  keys = {
    {
      '<leader>gd',
      ':lua require("gitsigns").preview_hunk()<CR>',
      desc = 'See hunk diff',
    },
  },
}
