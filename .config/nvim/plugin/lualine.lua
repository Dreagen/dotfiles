vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-lualine/lualine.nvim'
})

vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
  callback = function() require('lualine').refresh() end,
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
      {
        function()
          local reg = vim.fn.reg_recording()
          if reg ~= '' then
            return 'recording @' .. reg
          end
          return ''
        end,
        cond = function()
          return vim.fn.reg_recording() ~= ''
        end,
        color = 'RedrawDebugRecompose'
      },
      'encoding', 'filetype',
    },
  },
})
