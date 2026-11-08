---
layout: doc
title: "Windows, HUD and keys"
section: api-ui
group: api
preview: true
---

## UI

### Windows

```lua
local win = ui.window{ title = "TITLE", width = 640 }
```

A window is a menu screen: it opens from a keypress or the Mods menu, pauses ship controls like other menus, and
closes with Escape. Mods cannot open a window by themselves during flight (use `ui.toast` for that).

| Window method | Meaning |
|---|---|
| `win:label(text)` | A line of text; returns a handle with `:set(text)`. |
| `win:button{text=, on_click=}` | A button. |
| `win:switch{label=, value=, on_change=}` | OFF/ON, like the settings rows. |
| `win:slider{label=, min=, max=, step=, value=, format=fn, on_change=}` | A slider. `format` turns the number into text. |
| `win:choice{label=, options={...}, value=, on_change=}` | Left/right chooser; `value` and the callback use the 1-based index. |
| `win:list{height=}` | A scrolling list; handle has `:add(text)`, `:clear()`. |
| `win:progress{label=, value=}` | A bar, 0 to 1; handle has `:set(v)`. |
| `win:row(a, b, ...)` | Puts the given widgets side by side. |
| `win:open()`, `win:close()`, `win:toggle()` | Show, hide, or flip the window. |

Layout is rows and columns only (no pixel positions), so every window works with a pad. Widgets use the game's own
look and scale with the UI settings.

### HUD widgets

```lua
local hud = ui.hud{ anchor = "top-right", width = 220 }
local line = hud:label("text")
line:set("new text")
```

Read-only (no buttons), at most 3 per mod. `anchor` is one of `top-left`, `top-right`, `bottom-left`,
`bottom-right`. They are drawn under the game's own HUD and hide in photo mode and menus.

### Keybinds

`bind(label, defaultKey, fn)` registers an action in Settings > Controls under the mod's name, so players can
rebind it. If the default key clashes with another action the mod loads but the key starts unbound, and the Mods
menu says so. Mods never read the keyboard directly.

