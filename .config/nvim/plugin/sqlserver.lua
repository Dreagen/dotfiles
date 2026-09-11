vim.pack.add({ 'https://github.com/NicholasMata/sqlserver.nvim' })

local sqlserver = require('sqlserver')

sqlserver.setup({
    keymap_prefix = "<leader>sq",
    connections_file = vim.fn.stdpath("config") .. "/plugin-config/sqlserver/connections.json"
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'sqlserver-result',
    callback = function(args)
        vim.keymap.set('n', 'yic', function()
            vim.cmd('SQLServer CopyResultCell')
            vim.fn.setreg('+', vim.fn.getreg('"'), 'v')
        end, {
        buffer = args.buf,
        desc = 'Copy SQL result cell to system clipboard',
    })
end,
})
