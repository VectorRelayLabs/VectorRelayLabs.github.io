---
layout: doc
title: Modding Star Courier
section: overview
description: Add music, text and scripts to Star Courier.
---

Star Courier is built so players can add to it. Mods are **folders of plain files**, loaded by the game and
switched on and off from the **Mods** menu (main menu and pause menu, with an **Open mods folder** button).

## In the game today (0.9.0-alpha)

- **The Mods menu**, which lists every mod folder, shows whether it loaded or why it was skipped, and lets you
  switch each one on or off.
- **Recorded music.** Put `.ogg`, `.wav` or `.mp3` files in an `audio/<mood>/` folder inside a mod (moods:
  `flight`, `cruise`, `docked`, `tension`, `surface`) and they play alongside the built-in music. The in-game next
  and previous track keys include them.
- **Early music and text packs** in an interim format. We aren't publishing that format, because the Lua format
  below replaces it.

A bad file is skipped with a message, never a crash.

## Coming (preview)

- **Lua mods.** A `mod.lua` that registers its tracks and text and reacts to events: docking, deliveries,
  cargo damage and more. It runs in a sandbox with no file or network access. See the
  [Lua API reference](lua-api.html) and the [example mod](example-mod.html). These pages describe planned
  features and will change.
- **Writing music.** Tracks are a chord loop plus a melody and a few mix settings. [Writing music](music-guide.html)
  teaches it from scratch, with the numbers. The synth it describes is the one in the game today.
- **Hot loading:** add, change or remove a mod while the game runs.
- **Windows and HUD widgets** that mods can add through the same API.
- **MIDI files** that play through the game's sampled instruments.
- **Steam Workshop** sharing, once the game is on Steam.

## Feedback

Tell us what you would want to make. The API is still being shaped, and what people ask for decides what goes in
first.
