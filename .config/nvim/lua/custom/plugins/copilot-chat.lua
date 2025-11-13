return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      'github/copilot.vim', -- or zbirenbaum/copilot.lua
      'nvim-lua/plenary.nvim', -- for curl, log wrapper
    },
    opts = {
      model = 'claude-3.7-sonnet',
    },
    keys = {
      { '<leader>ac', ':CopilotChatOpen<CR>', mode = { 'n', 'o', 'x' } },
      { '<leader>ae', ':CopilotChatExplain<CR>', mode = { 'v' } },
      { '<leader>ar', ':CopilotChatReview<CR>', mode = { 'v' } },
      { '<leader>af', ':CopilotChatFix<CR>', mode = { 'v' } },
      { '<leader>ao', ':CopilotChatOptimize<CR>', mode = { 'v' } },
      { '<leader>at', ':CopilotChatTests<CR>', mode = { 'v' } },
      { '<leader>am', ':CopilotChatModels<CR>', mode = { 'n' } },
    },
  },
}
