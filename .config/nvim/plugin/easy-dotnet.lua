vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/GustavEikaas/easy-dotnet.nvim',
})

local dotnet = require('easy-dotnet')
dotnet.setup({
  test_runner = {
    viewmode = 'float',
    enable_buffer_test_execution = true,
  },
  picker = 'snacks',
  background_scanning = true,
  lsp = {
    enabled = true,
    config = {
      settings = {
        ["csharp|code_lens"] = {
          dotnet_enable_references_code_lens = false,
        },
      },
    },
  },
})

vim.keymap.set('n', '<leader>dt', dotnet.testrunner,              { desc = 'dotnet test runner' })
vim.keymap.set('n', '<leader>db', dotnet.build_solution_quickfix, { desc = 'dotnet build' })
vim.keymap.set('n', '<leader>dp', dotnet.project_view_default,    { desc = 'Project View' })
