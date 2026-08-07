-- Force Neovim's LSP file watching off the default per-directory `inotifywait`
-- backend. On Linux, vim.lsp._watchfiles picks `watch.inotify` whenever
-- `inotifywait` is on PATH, which spawns one recursive inotifywait process per
-- watched directory. Roslyn (via easy-dotnet) registers watchers across the
-- entire NuGet/SDK dependency graph on large solutions, exhausting the per-user
-- inotify pool. `vim._watch.watch` uses a single libuv fs_event handle per
-- watch root instead of a process per directory.
vim.lsp._watchfiles._watchfunc = require("vim._watch").watch
