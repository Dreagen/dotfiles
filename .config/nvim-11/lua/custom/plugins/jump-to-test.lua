return {
  'Dreagen/jump-to-test.nvim',
  name = 'jump-to-test',
  keys = {
    {
      '<leader>jt',
      '<cmd>lua require("jump-to-test").toggle()<CR>',
      mode = { 'n', 'o', 'x' },
    },
    {
      '<leader>je',
      '<cmd>lua require("jump-to-test").jump_to_test()<CR>',
      mode = { 'n', 'o', 'x' },
    },
    {
      '<leader>js',
      '<cmd>lua require("jump-to-test").jump_to_source()<CR>',
      mode = { 'n', 'o', 'x' },
    },
  },
}
