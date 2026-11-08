---
layout: doc
title: "Lua API: overview"
section: api-index
group: api
preview: true
---

A mod is a folder with a `mod.lua` (and optionally `preview.png`, audio files and `.mid` MIDI files). Lua is the only mod format.
`mod.lua` runs once when the mod loads, then your event handlers run when things happen.

This is a **preview**: none of it is in the game yet. It describes what a Lua mod will look like, so the shape can be discussed before it is built. The [example mod](../example-mod.html) uses it end to end.

## What mods can add

The aim is for the community to keep the game fresh with new things to do. Content registries, roughly in the
order they will arrive:

| Registry | Adds | Status |
|---|---|---|
| `music.add`, `music.midi`, `text.*` | Tracks, client and cargo names | In the game's data format today; Lua next |
| `contracts.offer` | Contracts on a station's board | Planned (v1 of the Lua API) |
| `missions.add` | Multi-step missions with a story and a reward | Planned (v1) |
| `events.add`, `ui.dialog` | Things to find and do out in the world | Planned (v1) |
| `paints.add` | Ship paints and livery colors | Planned |
| `rivalries.add` | Which stations dislike each other, and how much | Planned |
| `tweaks.set`, `text.replace` | Change existing values and text (a balance mod, a retheme) within safe ranges | Planned (v1) |
| `achievements.add` | Mod achievements shown in the career screen (Steam achievements can't be mod-defined) | Planned |
| `worlds.add`, `systems.add` | New worlds, stations and star systems | Later: they touch outposts, hangars, rivalry and saves |
| New ship classes, new mechanics, new UI beyond windows | | Not planned |

Content from mods is optional and labeled, never mixed in unmarked. A player can switch any mod off.

