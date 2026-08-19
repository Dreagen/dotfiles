vim.pack.add({ 'https://github.com/rose-pine/neovim' })

vim.cmd.colorscheme('rose-pine')

vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', {
  bg = '#403d52', -- rose-pine "highlight med" — visible but subtle
  bold = true,
})
