vim.pack.add({'https://github.com/folke/snacks.nvim'})
--
-- Configuration via plugin's setup (called after pack loads)
-- vim.pack doesn't have a lazy-style opts/keys abstraction,
-- so you handle setup and keymaps manually.
-- Setup snacks with your config
require('snacks').setup({
  picker = {},
  scope = {
    ui_select = true,
    min_size = 2,
    max_size = nil,
    cursor = true,
    edge = true,
    siblings = false,
    filter = function(buf)
      return vim.bo[buf].buftype == '' and vim.b[buf].snacks_scope ~= false and vim.g.snacks_scope ~= false
    end,
    debounce = 30,
    treesitter = {
      enabled = true,
      injections = true,
      blocks = {
        enabled = false,
        'function_declaration',
        'function_definition',
        'method_declaration',
        'method_definition',
        'class_declaration',
        'class_definition',
        'do_statement',
        'while_statement',
        'repeat_statement',
        'if_statement',
        'for_statement',
      },
      field_blocks = { 'local_declaration' },
    },
  },
})
-- Keymaps (previously handled by lazy's `keys` field)
vim.keymap.set('n', '<leader>sf', function() Snacks.picker.files() end,          { desc = 'Smart Find Files' })
vim.keymap.set('n', '<leader><leader>', function() Snacks.picker.buffers() end,  { desc = 'Search Buffers' })
vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end,           { desc = 'Search Grep' })
vim.keymap.set('n', '<leader>sr', function() Snacks.picker.resume() end,         { desc = 'Search Resume' })
vim.keymap.set('n', '<leader>s.', function() Snacks.picker.recent() end,         { desc = 'Search Recent' })
vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end,           { desc = 'Search Help' })
vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end,        { desc = 'Search Key Maps' })
vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end,    { desc = 'Search Lsp Symbols' })
vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status() end,     { desc = 'Git Status' })
vim.keymap.set('n', '<leader>se', function() Snacks.picker.explorer() end,       { desc = 'File explorer' })
vim.keymap.set('n', '<leader>:', function() Snacks.picker.command_history() end, { desc = 'Search Command History' })
vim.keymap.set('n', '<leader>gh', function() Snacks.picker.git_log_file() end, { desc = 'Show history for current file' })
