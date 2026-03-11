return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-mini/mini.icons" },
  branch = "stable",  -- Use stable branch for production
  lazy = false, -- Necessary for `default_explorer` to work properly
  config = function()
    require('fyler').setup({})
    vim.keymap.set('n', '<leader>-', '<CMD>Fyler<CR>', { desc = 'Open parent directory' })
  end,
}
