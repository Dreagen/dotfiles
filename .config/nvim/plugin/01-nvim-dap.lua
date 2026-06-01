vim.pack.add({
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/mfussenegger/nvim-dap',
})

local dap = require('dap')
local dapui = require('dapui')
dap.adapters.coreclr = {
  type = 'executable',
  command = '/usr/bin/netcoredbg',
  args = { '--interpreter=vscode' },
}
dap.adapters.netcoredbg = {
  type = 'executable',
  command = '/usr/bin/netcoredbg',
  args = { '--interpreter=vscode' },
}
dap.configurations.cs = {
  {
    -- pressing F5 will trigger attach to process
    type = 'coreclr',
    name = 'Launch .NET DLL (Debug)',
    request = 'launch',
    program = function()
      local matches = vim.fn.glob('./bin/Debug/**/testhost.dll', false, true)
      if #matches == 0 then
        error('No testhost.dll found in Debug build. Did you run `dotnet build -c Debug`?')
      end
      return matches[1]
    end,
  },
  {
    type = 'coreclr',
    name = 'Attach to process',
    request = 'attach',
    processId = require('dap.utils').pick_process,
  },
}
dapui.setup()
dap.listeners.before.attach.dapui_config          = function() dapui.open() end
dap.listeners.before.launch.dapui_config          = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config     = function() dapui.close() end
vim.keymap.set('n',        '<F5>',        function() dap.continue() end,                                        { desc = 'Continue' })
vim.keymap.set('n',        '<Leader>De',  function() dap.terminate() end,                                       { desc = 'Terminate' })
vim.keymap.set('n',        '<F10>',       function() dap.step_over() end,                                       { desc = 'Step over' })
vim.keymap.set('n',        '<F11>',       function() dap.step_into() end,                                       { desc = 'Step into' })
vim.keymap.set('n',        '<F12>',       function() dap.step_out() end,                                        { desc = 'Step out' })
vim.keymap.set('n',        '<Leader>Dt',  function() dap.toggle_breakpoint() end,                               { desc = 'Toggle breakpoint' })
vim.keymap.set({ 'n', 'v' }, '<Leader>Dh', function() require('dap.ui.widgets').hover() end,                   { desc = 'Open hover UI' })
vim.keymap.set({ 'n', 'v' }, '<Leader>Dp', function() require('dap.ui.widgets').preview() end,                 { desc = 'Open preview' })
vim.keymap.set('n',        '<Leader>Df',  function() local w = require('dap.ui.widgets'); w.centered_float(w.frames) end,  { desc = 'Open float UI' })
vim.keymap.set('n',        '<Leader>Ds',  function() local w = require('dap.ui.widgets'); w.centered_float(w.scopes) end, { desc = 'Open scopes' })
