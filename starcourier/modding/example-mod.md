---
layout: doc
title: "Example mod: Courier Ledger"
section: example
group: guides
preview: true
---

A sample `mod.lua` showing the shape of the API: music, text, a window, a HUD readout, events, a mission and an event. It is a design draft: nothing loads it yet.

```lua
-- Courier Ledger: a sample Lua mod (DESIGN DRAFT, API v1).
-- Nothing loads this yet: the Lua loader and StarCourier.Api are not built. It shows what a mod would
-- look like, so the API can be argued about before it is written.
--
-- What it does: adds two slow docked tracks and some cargo flavor, keeps a ledger of deliveries in a
-- window (key L), warns when your hull gets low, and thanks you for undamaged fragile deliveries.

mod.id          = "courier-ledger"
mod.name        = "Courier Ledger"
mod.version     = "1.0.0"
mod.author      = "Star Courier"
mod.description = "A delivery ledger window, a low-hull warning and two quiet tracks."
mod.api         = 1                       -- the oldest gateway version this mod needs
mod.permissions = {}                      -- no file or network access asked for

-- ---------------------------------------------------------------- data

-- Music: the fields are explained in the music guide; helpers make the arrays short.
music.add{
  name = "Ledger Lines", mood = "docked", bpm = 70, barsPerChord = 2, arpStyle = 0,
  chords = {
    chord(38, 62, 65, 69, 76),            -- chord(bass, a, b, c, d), MIDI notes
    chord(46, 58, 62, 65, 69),
    chord(43, 58, 62, 65, 69),
    chord(45, 57, 62, 64, 67),
  },
  -- eighth notes: a note, -2 to hold, -1 to rest. One chord lasts barsPerChord bars (16 entries here).
  melody = join(
    { 74,-2,-2,-2,77,-2,-2,-2,  76,-2,74,-2,72,-2,-2,-1 },
    { 70,-2,-2,-2,74,-2,-2,-2,  77,-2,76,-2,74,-2,-2,-1 },
    rep({ -1,-1,-1,-1,-1,-1,-1,-1 }, 4)  -- two bars of rest for the last two chords
  ),
  mix = { pad = 0.85, bass = 0.45, arp = 0.15, bells = 0.4, drums = 0.1, bright = 0.35, lead = 0.75 },
}

-- A second track built in code: the same progression a fourth higher, with no melody.
music.add{
  name = "Ledger Lines (Late)", mood = "docked", bpm = 64, barsPerChord = 2, arpStyle = 1,
  chords = map(function(c) return transpose(c, 5) end, {
    chord(38, 62, 65, 69, 76), chord(46, 58, 62, 65, 69),
    chord(43, 58, 62, 65, 69), chord(45, 57, 62, 64, 67),
  }),
  mix = { pad = 0.95, bass = 0.4, arp = 0.25, bells = 0.5, drums = 0.0, bright = 0.3, lead = 0.0 },
}

-- Text: lines are checked (60 characters, no angle brackets, 500 per mod).
text.clients("Ledger & Sons", "The Counting House")
text.cargo("standard", "bound account books", "sealed ink barrels")
text.cargo("fragile", "an abacus made of glass")
text.cargo("express", "yesterday's closing figures")

-- ---------------------------------------------------------------- state

-- store is saved with the game save (capped at 64 KB). Defaults first.
store.alertHull  = store.alertHull  or 35      -- warn below this hull %
store.totalPaid  = store.totalPaid  or 0
store.count      = store.count      or 0
local warned = false

-- ---------------------------------------------------------------- the window

local win = ui.window{ title = "COURIER LEDGER", width = 640 }

local summary = win:label("")
local list    = win:list{ height = 260 }

win:slider{
  label = "Warn when hull drops below", min = 10, max = 80, step = 5, value = store.alertHull,
  format = function(v) return v .. "%" end,
  on_change = function(v) store.alertHull = v end,
}

win:row(
  win:button{ text = "CLEAR", on_click = function()
    list:clear(); store.totalPaid, store.count = 0, 0; refresh()
  end },
  win:button{ text = "CLOSE", on_click = function() win:close() end }
)

function refresh()
  summary:set(string.format("%d deliveries  ·  %d CR paid", store.count, store.totalPaid))
end
refresh()

-- A rebindable action: it appears in Settings > Controls under this mod's name.
bind("Open ledger", "L", function() win:toggle() end)

-- ---------------------------------------------------------------- a small HUD readout

-- Read-only, fixed anchor, at most 3 per mod. Updates only when you call set().
local hud = ui.hud{ anchor = "top-right", width = 220 }
local hudLine = hud:label("")
local function hudRefresh() hudLine:set("Ledger  " .. store.count .. " delivered") end
hudRefresh()

-- ---------------------------------------------------------------- events

on("delivered", function(e)
  -- e: client, type, reward, damage (0 to 1), station
  store.count     = store.count + 1
  store.totalPaid = store.totalPaid + e.reward
  list:add(string.format("%-22s %-10s %5d CR  %s", e.client, e.type, e.reward,
                         e.damage > 0 and string.format("(%d%% damaged)", e.damage * 100) or ""))
  refresh(); hudRefresh()

  if e.type == "fragile" and e.damage == 0 then
    ui.toast("Not a scratch. " .. e.client .. " is thrilled.")
    sfx.play("cash")                       -- a named built-in sound, nothing else
  end
end)

on("cargo_damaged", function(e)
  -- e: percent, cause ("raiders", "collision", "rough flying")
  if e.cause == "rough flying" and e.percent >= 10 then
    ui.toast("Easy on the stick: the cargo is rattling.")
  end
end)

on("hull_changed", function(e)
  -- e: hull (0 to 100). Fires when the value changes, not every frame.
  if e.hull < store.alertHull and not warned then
    warned = true
    ui.toast("Hull at " .. math.floor(e.hull) .. "%. Find a dock.")
  elseif e.hull >= store.alertHull + 10 then
    warned = false                         -- re-arm once repaired
  end
end)

on("docked", function(e)
  -- e: station, world
  if store.count > 0 and store.count % 10 == 0 then
    ui.toast(store.count .. " deliveries on the ledger.")
  end
end)

-- Offer a small favor job the first time you dock at a station with good standing.
on("docked", function(e)
  if economy.standing(e.station) >= 40 and not store["offered_" .. e.station] then
    store["offered_" .. e.station] = true
    contracts.offer{
      type = "standard", client = "The Counting House", cargo = "sealed ink barrels",
      destination = "nearest", reward = 600, deadline = 20,   -- minutes; the game applies its own limits
    }
  end
end)

-- ---------------------------------------------------------------- a mission and an event

missions.add{
  id = "the-audit",
  title = "The Audit",
  giver = "The Counting House",
  summary = "A client wants its ledgers moved before the inspectors arrive.",
  rank = 1,
  repeatable = false,
  steps = {
    { kind = "pickup",  text = "Collect the sealed ledgers at {origin}", cargo = "sealed ledgers", at = "nearest" },
    { kind = "deliver", text = "Take them to {destination} before {deadline}", to = "other-world", deadline = 25 },
    { kind = "land",    text = "Land at the {destination} outpost to hand over the key", to = "outpost" },
  },
  reward = { credits = 1800, standing = { who = "giver", amount = 8 } },
  on_complete = function(m) ui.toast("The inspectors found nothing. Thanks, courier.") end,
}

events.add{
  id = "drifting-beacon",
  name = "Drifting beacon",
  kind = "beacon",
  where = "open-space",
  chance = 0.25,
  cooldown = 40,
  text = "A beacon is tumbling past, still sending a faint repeating signal.",
  choices = {
    { text = "Scan it", outcome = { credits = 200, log = "A hundred-year-old trade route. Worth a few credits to a collector." } },
    { text = "Tow it to the nearest station", outcome = { standing = { who = "nearest", amount = 3 }, toast = "The harbormaster is pleased." } },
    { text = "Leave it", outcome = {} },
  },
}
```
