-- for csharp development ensure netcoredbg is installed and available in the PATH
-- https://github.com/Samsung/netcoredbg/
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      dap.adapters.coreclr = {
        type = 'executable',
        command = '/usr/bin/netcoredbg',
        args = { '--interpreter=vscode' },
      }

      dap.configurations.cs = {
        {
          type = 'coreclr',
          name = 'Launch .NET DLL (Debug)',
          request = 'launch',
          program = function()
            -- Dynamically look for testhost.dll in bin/Debug/**/testhost.dll
            local matches = vim.fn.glob('./bin/Debug/**/testhost.dll', false, true)
            if #matches == 0 then
              error 'No testhost.dll found in Debug build. Did you run `dotnet build -c Debug`?'
            end
            return matches[1] -- or let the user pick if multiple exist
          end,
        },
        {
          type = 'coreclr',
          name = 'Attach to process',
          request = 'attach',
          processId = require('dap.utils').pick_process,
        },
      }

      dap.adapters.netcoredbg = {
        type = 'executable',
        command = '/usr/bin/netcoredbg',
        args = { '--interpreter=vscode' },
      }

      dapui.setup()
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      vim.keymap.set('n', '<F5>', function()
        dap.continue()
      end, {
        desc = 'Continue',
      })
      vim.keymap.set('n', '<Leader>De', function()
        dap.terminate()
      end, {
        desc = 'Terminate',
      })
      vim.keymap.set('n', '<F10>', function()
        dap.step_over()
      end, {
        desc = 'Step over',
      })
      vim.keymap.set('n', '<F11>', function()
        dap.step_into()
      end, {
        desc = 'Step into',
      })
      vim.keymap.set('n', '<F12>', function()
        dap.step_out()
      end, {
        desc = 'Step out',
      })
      vim.keymap.set('n', '<Leader>Dt', function()
        dap.toggle_breakpoint()
      end, {
        desc = 'Toggle breakpoint',
      })
      vim.keymap.set({ 'n', 'v' }, '<Leader>Dh', function()
        require('dap.ui.widgets').hover()
      end, {
        desc = 'Open hover UI',
      })
      vim.keymap.set({ 'n', 'v' }, '<Leader>Dp', function()
        require('dap.ui.widgets').preview()
      end, { desc = 'Open preview' })
      vim.keymap.set('n', '<Leader>Df', function()
        local widgets = require 'dap.ui.widgets'
        widgets.centered_float(widgets.frames)
      end, { desc = 'Open float UI' })
      vim.keymap.set('n', '<Leader>Ds', function()
        local widgets = require 'dap.ui.widgets'
        widgets.centered_float(widgets.scopes)
      end, { desc = 'Open scopes' })
    end,
  },
}
