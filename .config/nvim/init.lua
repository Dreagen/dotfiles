vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Prevents showing extra messages when using completion
vim.opt.shortmess:append("c")
-- Sets the height of the command line area at the bottom
vim.opt.cmdheight = 0
-- Displays the line number for the current line
vim.opt.number = true
-- Displays line numbers relative to the current cursor position
vim.opt.relativenumber = true
-- Time in milliseconds to wait for a mapped sequence to complete
vim.opt.timeoutlen = 500
-- Time in milliseconds of inactivity before calling CursorHold or writing to swap
vim.opt.updatetime = 4000
-- Ignores case when searching patterns
vim.opt.ignorecase = true
-- Automatically switches to case-sensitive search if a capital letter is used
vim.opt.smartcase = true
-- Enables 24-bit RGB colors in the terminal
vim.opt.termguicolors = true
-- Configures the behavior of the insert mode completion menu
vim.opt.completeopt = "menu,menuone,noselect,popup"
-- Number of spaces that a <Tab> character represents
vim.opt.tabstop = 2
-- Number of spaces to use for each step of automatic indentation
vim.opt.shiftwidth = 2
-- Number of spaces that a <Tab> counts for during editing operations
vim.opt.softtabstop = 2
-- Converts tabs into spaces when typing
vim.opt.expandtab = true
-- Automatically inserts an extra level of indentation in some cases
vim.opt.smartindent = true
-- Makes <Tab> insert 'shiftwidth' number of spaces at the start of a line
vim.opt.smarttab = true
vim.opt.showmode = false
vim.opt.showcmd = false
vim.g.have_nerd_font = true

-- keep cursor not at the bottom of the screen
vim.opt.scrolloff = 10

-- Folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldcolumn = '0'
vim.opt.foldtext = ''
vim.opt.foldlevel = 99
vim.opt.foldnestmax = 4

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.opt.wrap = false

-- tabs and spaces
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4 -- The number of spaces inserted for each indentation
vim.opt.softtabstop = 4 -- Number of spaces that a <Tab> counts for while performing editing operations
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> counts for

-- Set more granular undo points
vim.keymap.set('i', ' ', ' <c-g>u')
vim.keymap.set('i', '.', '.<c-g>u')
vim.keymap.set('i', ',', ',<c-g>u')
vim.keymap.set('i', '!', '!<c-g>u')
vim.keymap.set('i', '?', '?<c-g>u')

-- inline diagnostics
vim.diagnostic.config { virtual_text = true }

-- handle accidental upper case when saving
vim.api.nvim_create_user_command('W', 'w', { bang = true })
vim.api.nvim_create_user_command('Wa', 'wa', { bang = true })
vim.api.nvim_create_user_command('Wq', 'wq', { bang = true })
vim.api.nvim_create_user_command('Wqa', 'wqa', { bang = true })
vim.api.nvim_create_user_command('Q', 'q', { bang = true })
vim.api.nvim_create_user_command('Qa', 'qa', { bang = true })
--
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- SQLCMD wide column mode utilities
local sqlcmd_env = {
  fixed_width = vim.env.SQLCMDMAXFIXEDTYPEWIDTH or nil,
  var_width = vim.env.SQLCMDMAXVARTYPEWIDTH or nil,
}

local function enable_wide_columns()
  vim.env.SQLCMDMAXFIXEDTYPEWIDTH = '12000'
  vim.env.SQLCMDMAXVARTYPEWIDTH = '12000'
  print 'Wide column mode enabled for sqlcmd'
end

local function disable_wide_columns()
  vim.env.SQLCMDMAXFIXEDTYPEWIDTH = sqlcmd_env.fixed_width
  vim.env.SQLCMDMAXVARTYPEWIDTH = sqlcmd_env.var_width
  print 'Wide column mode disabled for sqlcmd'
end

local wide_columns_enabled = false
local function toggle_wide_columns()
  if wide_columns_enabled then
    disable_wide_columns()
  else
    enable_wide_columns()
  end
  wide_columns_enabled = not wide_columns_enabled
end

vim.api.nvim_create_user_command('EnableWideColumns', enable_wide_columns, {})
vim.api.nvim_create_user_command('DisableWideColumns', disable_wide_columns, {})
vim.api.nvim_create_user_command('ToggleWideColumns', toggle_wide_columns, {})

-- set float windows border style
vim.o.winborder = 'single'

vim.keymap.set('n', '<leader>i', vim.diagnostic.open_float, { desc = 'Show diagnostic error messages' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end,                                    { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end,                                   { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']e', function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end,  { desc = 'Next error' })
vim.keymap.set('n', '[e', function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, { desc = 'Previous error' })
vim.keymap.set('n', '<leader>i', vim.diagnostic.open_float,  { desc = 'Show diagnostic error messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,  { desc = 'Open diagnostic quickfix list' })

-- new ui
require('vim._core.ui2').enable({})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end
    local map_normal_visual = function(keys, func, desc)
      vim.keymap.set({ 'n', 'v' }, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end
    map('gd',         function() Snacks.picker.lsp_definitions() end,           '[G]oto [D]efinition')
    map('gr',         function() Snacks.picker.lsp_references() end,            '[G]oto [R]eferences')
    map('gI',         function() Snacks.picker.lsp_implementations() end,       '[G]oto [I]mplementation')
    map('<leader>D',  function() Snacks.picker.lsp_type_definitions() end,      'Type [D]efinition')
    map('<leader>ds', function() Snacks.picker.lsp_symbols() end,               '[D]ocument [S]ymbols')
    map('<leader>ws', function() Snacks.picker.lsp_workspace_symbols() end,     '[W]orkspace [S]ymbols')
    map('<leader>rn', vim.lsp.buf.rename,                                       '[R]e[n]ame')
    map_normal_visual('<leader>ca', vim.lsp.buf.code_action,                    '[C]ode [A]ction')
    map('K',          vim.lsp.buf.hover,                                        'Hover Documentation')
    map('<leader>ch', vim.lsp.buf.signature_help,                               'Signature Help')
    map('gD',         vim.lsp.buf.declaration,                                  '[G]oto [D]eclaration')

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
        end,
      })
    end
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, '[T]oggle Inlay [H]ints')
    end
    vim.lsp.codelens.enable(false)
  end,
})

vim.cmd [[
  highlight Visual guibg=#524c80
  highlight YankHighlight guibg=#ADD8E6 guifg=#000000
]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank {
      higroup = 'YankHighlight',
      timeout = 150,
    }
  end,
})

vim.api.nvim_set_hl(0, "@lsp.type.recordClass", { link = "@type" })
vim.api.nvim_set_hl(0, "@lsp.type.recordStruct", { link = "@type" })
vim.api.nvim_set_hl(0, "@lsp.type.extensionMethod", { link = "@function.method" })

vim.keymap.set("n", "p", "p`[v`]=")
vim.keymap.set("n", "P", "P`[v`]=")
