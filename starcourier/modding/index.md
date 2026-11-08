---
layout: doc
title: "Modding Star Courier"
section: overview
group: guides
description: Add music, missions, events and Lua scripts to Star Courier, and change how the game plays.
---

Star Courier is built so players can add to it, and keep it fresh long after launch. Mods are **folders of plain
files**, loaded by the game and switched on and off from the **Mods** menu (main menu and pause menu, with an
**Open mods folder** button).

## In the game today (0.9.0-alpha)

- **The Mods menu**, which lists every mod folder, shows whether it loaded or why it was skipped, and lets you
  switch each one on or off.
- **Recorded music.** Put `.ogg`, `.wav` or `.mp3` files in an `audio/<mood>/` folder inside a mod (moods:
  `flight`, `cruise`, `docked`, `tension`, `surface`) and they play alongside the built-in music. The in-game next
  and previous track keys include them.
- **Early music and text packs** in an interim format. We aren't publishing that format, because the Lua format
  below replaces it.

A bad file is skipped with a message, never a crash.

## What mods will be able to do (preview)

The [Lua API](api/) is a preview of what's planned. A mod is a `mod.lua` in a sandbox with no file or network
access.

- **Add things to do.** [Missions](api/missions.html) with a story and steps, [events](api/events.html) out in the
  world (a drifting beacon, a derelict, a ship in trouble) with choices, and contracts on a station's board.
- **Change how the game plays.** [Tweaks](api/tweaks.html) scale existing values (contract pay, prices, raider
  frequency, cargo damage) within safe ranges, and the Mods menu shows exactly what each mod changes.
- **Add music and text.** [Tracks](api/music.html) written as a chord loop and a melody, MIDI files, and client
  and cargo names. [Writing music](music-guide.html) teaches it from scratch, with the numbers.
- **React to the game** with [events](api/hooks.html) like docking, deliveries and cargo damage, and add
  [windows and HUD readouts](api/ui.html).
- **Hot loading:** add, change or remove a mod while the game runs.
- **Steam Workshop** sharing, once the game is on Steam.

Later: paints, rivalries, achievements, and eventually new worlds and star systems.

## Feedback

Tell us what you would want to make. The API is still being shaped, and what people ask for decides what goes in
first.
