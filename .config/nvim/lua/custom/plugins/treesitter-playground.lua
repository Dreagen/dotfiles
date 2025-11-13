return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/playground',
  },
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'lua', 'python', 'javascript' }, -- your languages
      highlight = { enable = true },
      incremental_selection = { enable = true },
      textobjects = { enable = true },
    }
  end,
}
