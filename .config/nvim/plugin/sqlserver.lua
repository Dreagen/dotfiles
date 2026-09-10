vim.pack.add({ 'https://github.com/NicholasMata/sqlserver.nvim' })

local sqlserver = require('sqlserver')

sqlserver.setup({
    keymap_prefix = "<leader>sq",
})
