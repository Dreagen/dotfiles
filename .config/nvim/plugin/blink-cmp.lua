vim.pack.add({
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1') }
})

require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = {
    nerd_font_variant = 'mono',
  },
  completion = { documentation = { auto_show = true } },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    per_filetype = {
      sql   = { 'dadbod', 'buffer' },
      mysql = { 'dadbod', 'buffer' },
      plsql = { 'dadbod', 'buffer' },
      cs = { 'lsp', 'path', 'snippets', 'buffer', 'easy-dotnet' },
    },
    providers = {
      dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
      ['easy-dotnet'] = {
        name = 'easy-dotnet',
        enabled = true,
        module = 'easy-dotnet.completion.blink',
        score_offset = 10000,
        async = true,
      },
    },
  },
  fuzzy = { implementation = 'lua' },
})
