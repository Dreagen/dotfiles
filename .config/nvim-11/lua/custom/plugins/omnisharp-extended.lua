return {
  {
    'Hoffs/omnisharp-extended-lsp.nvim',
    keys = {
      {
        'gd',
        '<cmd>lua require("omnisharp_extended").lsp_definition()<CR>',
        mode = { 'n', 'o', 'x' },
      },
    },
  },
}
