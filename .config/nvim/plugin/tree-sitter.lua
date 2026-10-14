vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", 
    version = 'main' },
})

require('nvim-treesitter').setup({})

-- Install configured parsers on startup when they are missing.
require('nvim-treesitter').install({
  'c_sharp', 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc',
})
