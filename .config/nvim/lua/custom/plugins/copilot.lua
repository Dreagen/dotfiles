return {
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter', -- or whatever you prefer
    config = function()
      require('copilot').setup {
        suggestion = {
          enabled = true,
          auto_trigger = false,
          keymap = {
            accept = '<M-l>',
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
          },
        },
        panel = {
          enabled = true,
          layout = {
            position = 'bottom',
            ratio = 0.4,
          },
        },
        -- … any other options you want
      }
    end,
    requires = {
      'copilotlsp-nvim/copilot-lsp', -- only if you want the NES feature
    },
  },
}
