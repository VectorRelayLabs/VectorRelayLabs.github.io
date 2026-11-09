---
layout: doc
title: "The console"
section: console
group: guides
description: "The in-game developer console: opening it, reading the log, and the commands that help when you make a mod."
---

The console is a panel at the top of the screen that shows the game's log and runs commands. It works on the main
menu and in flight, so you can read what happened while a mod was loading.

## Opening it

Press the key left of **1** (`` ` `` on most keyboards). It's rebindable under **Settings > Controls**. Press it
again or **Esc** to close.

| Key | Does |
|---|---|
| **Up / Down** | Recall earlier commands |
| **PgUp / PgDn**, mouse wheel | Scroll the log |
| **Shift + Up / Down** | Scroll one line |
| **Ctrl + Home / End** | Jump to the oldest or newest line |

The log keeps everything since launch (up to 2,000 lines), including startup, so you can scroll back to the
moment your mod loaded.

## Commands for everyone

These always work. They're the ones to use while building and testing a mod.

| Command | What it does |
|---|---|
| `help` | Lists every command. Cheats are dimmed until they're unlocked, and commands added by mods are marked `[mod]`. |
| `log` | The last 15 warnings and errors. Start here when a mod misbehaves. |
| `copylog` | Copies the whole log to the clipboard, ready to paste into a bug report or a forum post. |
| `verbose [on\|off]` | Adds `[trace]` lines about flow, docking, contracts, saves and cruise. |
| `quiet [on\|off]` | Warnings and errors only, so a mod's messages aren't buried. |
| `clear` | Clears the console. |
| `folder` | Opens the folder with saves and `Player.log`. |
| `version` | Game and Unity version. Include it when you report something. |
| `fps` | Current frame rate, to check a mod isn't slowing the game. |
| `modkeys` | Lists the keys that mods registered with `bind`, and what each is set to. |
| `modkey <mod-id> <label> <key\|none>` | Rebinds a mod's key, for example `modkey ledger Open ledger F6`. The choice is saved. |
| `saves`, `load <auto\|quick\|1-3>` | List and load save slots, to get back to a test situation fast. |
| `newgame`, `menu`, `quit` | Start over, return to the menu, leave. |
| `net` | Co-op session status. |

## Cheat commands

These change your own ship and wallet, so they're good for putting yourself in the situation a mod needs. They
are on in development builds, or after turning on **Settings > Gameplay > Developer console**. They never touch
a shared co-op world: as a client in someone else's session they're refused.

| Command | What it does |
|---|---|
| `credits <amount>` | Add or take credits. Test a mod that charges or pays. |
| `fuel`, `repair` | Fill the tank, restore hull and shields. |
| `goto <world>` | Park next to a world's station (`worlds` lists them with distances). |
| `standing <world> <0-100>` | Set your standing with a world, for missions that need a tier. |
| `jobs [count]` | Re-roll the job board while docked, to see a contract of yours show up. |
| `ship <hauler\|skiff\|runner\|freighter>` | Switch ship class for free. |
| `pirates`, `distress`, `salvage`, `storm` | Trigger that event right now, to test a mod that reacts to it. |
| `trial [1-3]` | Line up on a time-trial start gate. |
| `jump [system]` | List the star systems or jump to one. |

## Where a mod's messages go

A mod can print to the console with `log(...)`, `print(...)` and `warn(...)`. Each line starts with `[mod your-id]`, and
`warn` shows in amber. They also go to `Player.log`, so `copylog` includes them. A mod can also write a colored line
with `console.print(text, style)`.

A mod that fails to load, or stops later because a handler errored or ran too long, says why in the console and under
its name in the **Mods** menu, along with any calls it made that the game doesn't support yet.

## Adding your own commands

A mod can add commands to this console with `console.command(name, description, fn)`:

```lua
console.command("ledger-reset", "Clear the ledger", function(args)
  store.count = 0
  console.print("Ledger cleared.", "good")
end)
```

Mod commands show up in `help` marked `[mod]`, work on the main menu, can't replace a built-in command, and aren't cheats:
they can only do what the rest of the mod API allows. A mod can also add `/commands` to the chat box with
`chat.command`. Both are described in the [Lua API](api/).

## A test loop

1. Edit your mod folder. The game notices and reloads it, or press **Rescan** in the **Mods** menu.
2. Open the console and type `log`.
3. Fix what it says, and repeat. If you're stuck, run `copylog` and paste it in the feedback channel.
