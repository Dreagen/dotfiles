vim.pack.add({ 'https://github.com/rose-pine/neovim' })

vim.cmd.colorscheme('rose-pine')

-- Use regular underlines for diagnostics because xterm-256color doesn't
-- advertise undercurl support in this WSL terminal.
for _, severity in ipairs({ 'Error', 'Warn', 'Info', 'Hint', 'Ok' }) do
  local group = 'DiagnosticUnderline' .. severity
  local highlight = vim.api.nvim_get_hl(0, { name = group })
  vim.api.nvim_set_hl(0, group, { sp = highlight.sp, underline = true })
end

vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', {
  bg = '#403d52', -- rose-pine "highlight med" — visible but subtle
  bold = true,
})
