return {
  'sindrets/diffview.nvim',
  keys = {
    {
      '<leader>gd',
      ':lua require("gitsigns").preview_hunk()<CR>',
      desc = 'See hunk diff',
    },
    {
      '<leader>gr',
      ':lua require("gitsigns").reset_hunk()<CR>',
      desc = 'Reset hunk',
    },
    {
      '<leader>gn',
      ':lua require("gitsigns").next_hunk()<CR>',
      desc = 'Next hunk',
    },
    {
      '<leader>gp',
      ':lua require("gitsigns").prev_hunk()<CR>',
      desc = 'Previous hunk',
    },
  },
}
