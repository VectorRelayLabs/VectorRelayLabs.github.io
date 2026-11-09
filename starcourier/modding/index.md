---
layout: doc
title: "Modding Star Courier"
section: overview
group: guides
description: Add music, tweaks, windows and Lua scripts to Star Courier, and change how the game plays.
---

Star Courier is built so players can add to it, and keep it fresh long after launch. Mods are **folders of plain
files**, loaded by the game and switched on and off from the **Mods** menu (main menu and pause menu, with an
**Open mods folder** button).

## Arriving in 0.10.0-alpha.1

Mods are **Lua scripts**. A mod is a folder with a `mod.lua`, run in a sandbox with no file or network access and
a budget of about 100,000 instructions per call. The full list of what works and what is still planned is in the
[Lua API](api/) (and `docs/LUA_API.md` in the game's repository, which has a **works today** table).

- **Add music and text:** synth tracks written as a chord loop and a melody, and client and cargo names.
  [Writing music](music-guide.html) teaches it from scratch.
- **Change how the game plays:** tweaks scale 15 values (contract pay, prices, raiders, storms, standing and more)
  within safe ranges, and the Mods menu shows exactly what each mod changes. A mod can also put a job on a station's board.
- **React to the game:** docking, deliveries, hull changes, jumps, landings, raiders, chat. Read ship and economy state,
  set timers, and keep data that is saved with the game.
- **Add interface:** windows, HUD readouts, dialogs, a **MODS tab** in the station terminal, keys, and chat and
  [console](console.html) commands.
- **Control the music:** a mod can pick which of its own tracks plays, for a scene it designs. Players can turn that off.
- **Depend on other mods,** with load order and version checks. The Mods menu lists what each mod asks for.
- **Hot loading:** add, change or remove a mod while the game runs.
- **Recorded music** in `audio/<mood>/` folders (`.ogg`, `.wav`, `.mp3`) plays alongside the built-in music.

A bad mod is skipped with a message, never a crash.

## Still planned

Missions and events with choices, rewards, ship paints, rivalries, achievements, MIDI and recorded music from Lua,
and eventually new worlds and star systems. **Steam Workshop** sharing comes with the Steam release.

## Feedback

Tell us what you would want to make. The API is still being shaped, and what people ask for decides what goes in
first.
