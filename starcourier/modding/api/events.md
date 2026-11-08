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
with choices. A choice either has a declared `outcome`, or a `run` function that decides what happens.

Here is a beacon that can be a windfall, a trap, or the start of a story:

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
    { text = "Scan it", run = function(e)
        if rand(1, 100) <= 70 then
          rewards.grant{ credits = 200 }
          radio.say("Beacon archive", "Packet received: a hundred-year-old trade route.")
          ui.toast("Scan complete. A collector will pay for this.")
        else
          ui.toast("It was bait. Raiders are closing in!")
          threats.spawn{ count = 2 }
        end
      end },
    { text = "Tow it to the nearest station", run = function(e)
        rewards.grant{ standing = { who = "nearest", amount = 3 } }
        store.towed = (store.towed or 0) + 1
        ui.toast("The harbormaster is pleased.")
        if store.towed == 3 then events.trigger("harbormasters-favor") end   -- a chain: the third tow opens a new event
      end },
    { text = "Leave it", outcome = {} },
  },
}

events.add{
  id = "harbormasters-favor",
  name = "A word from the harbormaster",
  kind = "convoy",
  chance = 0,                    -- never appears on its own: only when another event triggers it
  text = "Three beacons towed in. The harbormaster has a job for someone she trusts.",
  choices = {
    { text = "Hear her out", run = function() missions.start("the-audit") end },
    { text = "Not now", outcome = {} },
  },
}
```

| Field | Notes |
|---|---|
| `kind` | Picks the marker icon and the radio line. |
| `where` | `open-space`, `near-planet` (within a planet's atmosphere or orbit) or `outpost`. |
| `chance`, `cooldown` | How often it appears. `chance = 0` means it only appears when something triggers it. The game limits the number of mod events active in a sector (3), whatever the mod asks for. |
| `text` | What the player sees when they arrive (up to 240 characters). |
| `choices` | 1 to 4. Each has `text` and either an `outcome` table or a `run` function. |
| `requires` | Optional on a choice: `{ cargo = "medical supplies" }` or `{ module = "cargo-cradles" }`. A player who lacks it doesn't see the option. |

### Outcomes: the simple way

When a choice needs no logic, declare it. These are capped by the game: `credits`, `standing`, `fuel` (a refill,
never above full), `log` (a line for the logbook), `toast`, `spawn_raiders = n` (1 to 3), `contract` (as in
`contracts.offer`) and `next` (the `id` of another event).

### What `run` can do

`run = function(e) ... end` is for choices that need to decide something: a roll, a check, a memory of what the
player did before. It can use everything the rest of the API allows, plus these effect calls. **Every one is
validated and capped by the game, the same way an outcome is.** A `run` function cannot get around the caps.

| Call | Effect | Limit |
|---|---|---|
| `rewards.grant{credits, standing, fuel}` | Pay the player | Same per-event cap as an outcome, and an hourly budget per mod |
| `threats.spawn{count, kind}` | Raiders appear | 1 to 3, with a cooldown |
| `missions.start(id)`, `missions.advance(id)` | Start or move on one of this mod's missions | Only the mod's own missions |
| `events.trigger(id)` | Open another event | Chains at most 4 deep |
| `radio.say(name, text)` | A radio line from an invented character | Text limits as usual |
| `ship.repair(percent)` | A small repair | At most 25% per use |
| `time.after(seconds, fn)` | Run something later ("the beacon blows up in 20 seconds") | 5 to 600 seconds; the same instruction budget as any call |
| `cargo.give(name, count)` | A cargo item the mod declares | A small hold limit |

The Mods menu shows each mod's totals (credits paid, raiders spawned) so players can see what a mod has done.

**A `run` function cannot:** set credits directly, change a ship's stats, read other players' state, touch files or
the network, or change anything outside the mod's own `store`. It runs on the host, so every crew member gets the
same result.


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
