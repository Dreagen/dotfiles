local function build_renderer(path)
  local render_dir = path .. '/render'
  for _, cmd in ipairs({
    { 'npm', 'ci' },
    { 'npx', 'puppeteer', 'browsers', 'install', 'chrome-headless-shell' },
  }) do
    local result = vim.system(cmd, { cwd = render_dir }):wait()
    if result.code ~= 0 then
      vim.notify(
        ('vellum: %s failed:\n%s'):format(table.concat(cmd, ' '), result.stderr),
        vim.log.levels.ERROR
      )
      return
    end
  end
end

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('vellum-pack-build', { clear = true }),
  callback = function(event)
    local data = event.data
    if data.spec.name == 'vellum.nvim' and (data.kind == 'install' or data.kind == 'update') then
      if vim.fn.executable('npm') == 0 or vim.fn.executable('npx') == 0 then
        vim.notify('vellum: install Node.js 20+ and npm to enable diagrams and non-PNG images', vim.log.levels.WARN)
        return
      end
      build_renderer(data.path)
    end
  end,
})

vim.pack.add({ 'https://github.com/blackhat-7/vellum.nvim' })

require('vellum').setup({})

vim.keymap.set('n', '<leader>mp', '<cmd>Vellum<cr>', { desc = 'Markdown preview' })
vim.keymap.set('n', '<leader>mz', function() require('vellum').zoom() end, { desc = 'Zoom markdown image' })
