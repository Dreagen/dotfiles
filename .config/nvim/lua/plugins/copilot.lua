vim.pack.add({
  'https://github.com/copilotlsp-nvim/copilot-lsp',
  'https://github.com/zbirenbaum/copilot.lua',
})

vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    require('copilot').setup({
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
    })
  end,
})
