# pi-usage without its footer

This local wrapper loads the installed `@narumitw/pi-usage` package and suppresses
only its `setStatus("usage", ...)` calls. `/usage`, dialogs, error notifications,
and the rest of the upstream behavior remain available. Other extensions' footer
statuses are unchanged. Upstream background refreshes still run; this is a
presentation-only wrapper, not a command-only rewrite.

Pi discovers `index.ts` automatically from this directory. In
`~/.pi/agent/settings.json`, keep the upstream package installed and updateable,
but disable its direct extension entry point to prevent duplicate loading:

```json
{
    "source": "npm:@narumitw/pi-usage",
    "extensions": []
}
```

Run `/reload` after changes. The wrapper imports the package from the absolute
path `~/.pi/agent/npm/node_modules/@narumitw/pi-usage/dist/index.ts` rather than a
relative one, because stow symlinks this file and Pi resolves it back to the
dotfiles repo. An upstream change to that entry point or status key may require
updating the wrapper.

## Verify

```bash
node --test ~/.pi/agent/extensions/usage-command-only/test.mjs
```

The tests cover scoped suppression, asynchronous captured contexts, live context
getters, command delegation, and loading the real installed package without
making provider requests. The loader smoke test references the currently
installed Pi 1.5.0 release path.

## Undo

Remove this wrapper directory, restore the package entry in `settings.json` to
`"npm:@narumitw/pi-usage"`, then run `/reload`.
