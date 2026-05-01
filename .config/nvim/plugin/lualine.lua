vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-lualine/lualine.nvim'
})

require('lualine').setup({
  sections = {
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = {
      {
        function()
          local mode = vim.fn.mode()
          if mode == 'v' or mode == 'V' or mode == '\22' then
            local wc = vim.fn.wordcount()
            local lines = vim.fn.line('v') ~= vim.fn.line('.') and math.abs(vim.fn.line('.') - vim.fn.line('v')) + 1 or nil
            if lines then
              return lines
            elseif wc.visual_chars then
              return wc.visual_chars
            end
          end
          return ''
        end,
        cond = function()
          local mode = vim.fn.mode()
          return mode == 'v' or mode == 'V' or mode == '\22'
        end,
      },
      'encoding', 'filetype',
    },
  },
})
