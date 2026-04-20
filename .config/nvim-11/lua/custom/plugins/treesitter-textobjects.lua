return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    -- - va) - [V]isually select [A]round [)]paren
    -- - yinq - [Y]ank [I]nside [N]ext [']quote
    -- - ci' - [C]hange [I]nside [']quote
    local spec_treesitter = require('mini.ai').gen_spec.treesitter
    require('mini.ai').setup {
      n_lines = 500,
      custom_textobjects = {
        F = spec_treesitter { a = '@function.outer', i = '@function.inner' },
        o = spec_treesitter {
          a = { '@conditional.outer', '@loop.outer' },
          i = { '@conditional.inner', '@loop.inner' },
        },
      },
    }
    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd' - [S]urround [D]elete [']quotes
    -- - sr)' - [S]urround [R]eplace [)] [']
    -- require('mini.surround').setup()
    -- Check out: https://github.com/echasnovski/mini.nvim
    --

    vim.api.nvim_set_keymap('n', 'viF', '[mvi{', { noremap = true, silent = true })
  end,
}
