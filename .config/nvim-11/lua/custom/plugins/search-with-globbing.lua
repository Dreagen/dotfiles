return {
  'Dreagen/search-with-globbing.nvim',
  name = 'search-with-globbing',
  keys = {
    {
      '<leader>su',
      '<cmd>lua require("search-with-globbing").search_with_globbing()<CR>',
      mode = { 'n', 'o', 'x' },
      desc = 'Search with Globbing',
    },
  },
}
