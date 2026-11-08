---
layout: doc
title: "Events and dialogs"
section: api-events
group: api
preview: true
---

## `events.add{...}`: events and things to do

An event is something found out in the world: a drifting beacon, a derelict, an anomaly, a ship in trouble. It
appears on the sector map and the nav list as a marker. When the player flies to it, a short **dialog** opens
with choices, and each choice has an outcome.

```lua
events.add{
  id = "drifting-beacon",
  name = "Drifting beacon",
  kind = "beacon",               -- beacon, derelict, anomaly, wreck, convoy
  where = "open-space",          -- open-space, near-planet, outpost
  chance = 0.25,                 -- how likely it is to appear in a sector that day, 0 to 1
  cooldown = 40,                 -- minutes before it can appear again
  text = "A beacon is tumbling past, still sending a faint repeating signal.",
  choices = {
    { text = "Scan it", outcome = { credits = 200, log = "A hundred-year-old trade route. Worth a few credits to a collector." } },
    { text = "Tow it to the nearest station", outcome = { standing = { who = "nearest", amount = 3 }, toast = "The harbormaster is pleased." } },
    { text = "Leave it", outcome = {} },
  },
}
```

| Field | Notes |
|---|---|
| `kind` | Picks the marker icon and the radio line. |
| `where` | `open-space`, `near-planet` (within a planet's atmosphere or orbit) or `outpost`. |
| `chance`, `cooldown` | How often it appears. The game limits the number of mod events active in a sector (3), whatever the mod asks for. |
| `text` | What the player sees when they arrive (up to 240 characters). |
| `choices` | 1 to 4. Each has `text` and an `outcome` table, or a `run` function for code. |

**Outcome fields (declared, capped by the game):** `credits`, `standing`, `fuel` (a refill, never above full),
`log` (a line added to the logbook), `toast`, `spawn_raiders = n` (1 to 3, which then behave like any raiders), `contract`
(offer a contract, as in `contracts.offer`), `next` (the `id` of another event, for a short chain). `run = function(e) ... end`
may do anything the rest of the API allows, with no extras.

A choice can also have `requires = { cargo = "medical supplies" }` or `{ module = "cargo-cradles" }` so a
player who lacks it doesn't see the option grayed out.


## `ui.dialog{...}`

The same dialog the events use, for any mod code that wants one: a title, a paragraph and up to four buttons.
It is a menu, so it pauses ship controls like other menus and closes with Escape.

```lua
ui.dialog{
  title = "The harbormaster calls",
  text = "Your standing has been noticed.",
  choices = { { text = "Accept", run = function() ui.toast("Thanks.") end }, { text = "Not now" } },
}
```
