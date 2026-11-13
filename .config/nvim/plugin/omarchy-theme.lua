local state_dir = vim.fn.expand("~/.local/state/omarchy/current")
local colors_file = state_dir .. "/theme/colors.toml"

vim.pack.add({ "https://github.com/bjarneo/aether.nvim" })

local function palette()
  if vim.fn.executable("omarchy-theme-color") == 0 then
    return nil
  end

  local out = vim.fn.system({ "omarchy-theme-color", "--file", colors_file, "--all" })
  if vim.v.shell_error ~= 0 then
    return nil
  end

  local colors = {}
  local mode

  for line in out:gmatch("[^\n]+") do
    local key, value = line:match("^([%w_]+)\t(.-)%s*$")
    if key == "mode" then
      mode = value
    elseif key and value:match("^#%x%x%x%x%x%x$") then
      colors[key] = value
    end
  end

  if vim.tbl_isempty(colors) then
    return nil
  end

  return colors, mode
end

local function apply()
  local colors, mode = palette()
  if not colors then
    return
  end

  if mode == "light" or mode == "dark" then
    vim.o.background = mode
  end

  local ok, theme = pcall(require, "aether.theme")
  if not ok then
    return
  end

  theme.setup({ colors = colors })
  vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "aether", modeline = false })
end

apply()

local uv = vim.uv or vim.loop
local timer = uv.new_timer()
local watcher = uv.new_fs_event()

_G.omarchy_theme = { timer = timer, watcher = watcher }

if watcher and watcher:start(state_dir, {}, vim.schedule_wrap(function()
    timer:stop()
    timer:start(1500, 0, vim.schedule_wrap(apply))
  end)) == 0 then
  _G.omarchy_theme.watching = true
end
