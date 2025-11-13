return {
  'GustavEikaas/easy-dotnet.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    local dotnet = require 'easy-dotnet'
    dotnet.setup {
      test_runner = {
        viewmode = 'float',
        enable_buffer_test_execution = true,
      },
      picker = 'snacks',
      background_scanning = true,
      lsp = {
        enabled = true,
      },
    }

    vim.keymap.set('n', '<leader>dt', dotnet.testrunner, { desc = 'dotnet test runner' })
    vim.keymap.set('n', '<leader>db', dotnet.build_solution_quickfix, { desc = 'dotnet build' })
    vim.keymap.set('n', '<leader>dp', dotnet.project_view_default, { desc = 'Project View' })
  end,
}
