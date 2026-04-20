vim.pack.add({ 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' })

require('tiny-inline-diagnostic').setup({
  preset = 'classic',
  options = {
    show_source = false,
    multilines = {
      enabled = true,
    },
  },
})

vim.diagnostic.config({ virtual_text = false })
