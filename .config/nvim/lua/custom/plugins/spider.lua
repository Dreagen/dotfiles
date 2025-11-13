return {
  {
    'chrisgrieser/nvim-spider',
    keys = {
      {
        'E',
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { 'n', 'o', 'x' },
      },
      {
        'W',
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { 'n', 'o', 'x' },
      },
      {
        'B',
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { 'n', 'o', 'x' },
      },
    },
    opts = {
      skipInsignificantPunctuation = false,
    },
  },
}
