-- lazy.nvim
return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    picker = {
      -- your picker configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    scope = {
      -- absolute minimum size of the scope.
      -- can be less if the scope is a top-level single line scope
      min_size = 2,
      -- try to expand the scope to this size
      max_size = nil,
      cursor = true, -- when true, the column of the cursor is used to determine the scope
      edge = true, -- include the edge of the scope (typically the line above and below with smaller indent)
      siblings = false, -- expand single line scopes with single line siblings
      -- what buffers to attach to
      filter = function(buf)
        return vim.bo[buf].buftype == '' and vim.b[buf].snacks_scope ~= false and vim.g.snacks_scope ~= false
      end,
      -- debounce scope detection in ms
      debounce = 30,
      treesitter = {
        -- detect scope based on treesitter.
        -- falls back to indent based detection if not available
        enabled = true,
        injections = true, -- include language injections when detecting scope (useful for languages like `vue`)
        ---@type string[]|{enabled?:boolean}
        blocks = {
          enabled = false, -- enable to use the following blocks
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
        -- these treesitter fields will be considered as blocks
        field_blocks = {
          'local_declaration',
        },
      },
    },
  },
  keys = {
    -- Top Pickers & Explorer
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader><leader>',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Search Buffers',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Search Grep',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Search Resume',
    },
    {
      '<leader>s.',
      function()
        Snacks.picker.recent()
      end,
      desc = 'Search Recent',
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = 'Search Help',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'Search Key Maps',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'Search Lsp Symbols',
    },
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git Status',
    },
    {
      '<leader>se',
      function()
        Snacks.picker.explorer()
      end,
      desc = 'File explorer',
    },
    {
      '<leader>:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Search Command History',
    },
  },
}
