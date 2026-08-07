vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  {
      src = 'https://github.com/GustavEikaas/easy-dotnet.nvim',
      -- ref = '45072273314ee5edd1ac8dab9897aba8715a21c2'
  }
})

local dotnet = require('easy-dotnet')
dotnet.setup({
  auto_bootstrap_namespace = {
    enabled = false
  },
  test_runner = {
    viewmode = 'float',
    enable_buffer_test_execution = true,
  },
  picker = 'snacks',
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

require("easy-dotnet.netcoredbg").register_dap_variables_viewer()

vim.keymap.set('n', '<leader>dt', dotnet.testrunner,              { desc = 'dotnet test runner' })
vim.keymap.set('n', '<leader>db', dotnet.build_solution_quickfix, { desc = 'dotnet build' })
