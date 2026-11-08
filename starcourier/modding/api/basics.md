---
layout: doc
title: "Sandbox and manifest"
section: api-basics
group: api
preview: true
---

## Rules of the sandbox

- Only the base language is available: `string`, `table`, `math`, and `pairs`/`ipairs`/`type` and the like.
  There is **no** `io`, `os`, `debug`, `package` or `require` of files, and no network.
- Every call into your code (the main chunk and each event handler) has a budget of about 100,000 VM
  instructions. Going over stops that call and shows an error under the mod in the Mods menu.
- An error in a handler disables that handler's mod and shows the message. It never crashes the game.
- You only ever see plain values (numbers, strings, booleans, tables). No game objects.
- Strings you give the game may not contain `<` or `>` and are cut to their limits (below).
- Lua is loaded as text only (no precompiled bytecode), so what a player installs is readable source.
- A mod is switched on and off with the Mods menu, and loads and unloads while the game runs. Unloading removes
  its handlers, windows, HUD widgets and keybinds.


## Manifest

Set these at the top of `mod.lua`:

| Field | Type | Notes |
|---|---|---|
| `mod.id` | string | 2 to 39 characters: lowercase letters, digits, hyphens. Unique. |
| `mod.name` | string | Shown in the Mods menu. |
| `mod.version` | string | `1.0` or `1.2.3`. |
| `mod.api` | number | The oldest API version the mod needs. A newer requirement than the game offers skips the mod with a message. |
| `mod.author`, `mod.description` | string | Optional. |
| `mod.permissions` | table | Names of extra things the mod asks for. v1 defines none; leave it `{}`. |

