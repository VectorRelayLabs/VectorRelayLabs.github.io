---
layout: doc
title: "Missions"
section: api-missions
group: api
preview: true
---

## `missions.add{...}`: missions

A mission is a short story told in steps: pick something up, deliver it, visit a place, land on a pad, then
get paid. Missions appear in the terminal's Missions list with their current step, and the HUD shows the active
step's text.

```lua
missions.add{
  id = "the-audit",
  title = "The Audit",
  giver = "The Counting House",
  summary = "A client wants its ledgers moved before the inspectors arrive.",
  rank = 1,                      -- minimum rank (0 Cadet, 1 Courier, 2 Senior Courier ...)
  repeatable = false,
  steps = {
    { kind = "pickup",  text = "Collect the sealed ledgers at {origin}", cargo = "sealed ledgers", at = "nearest" },
    { kind = "deliver", text = "Take them to {destination} before {deadline}", to = "other-world", deadline = 25 },
    { kind = "land",    text = "Land at the {destination} outpost to hand over the key", to = "outpost" },
  },
  reward = { credits = 1800, standing = { who = "giver", amount = 8 } },
  on_complete = function(m) ui.toast("The inspectors found nothing. Thanks, courier.") end,
}
```

| Field | Notes |
|---|---|
| `id`, `title`, `giver`, `summary` | `id` unique within the mod; the others are text (60 and 160 characters, no angle brackets). |
| `rank` | Lowest rank that is offered the mission. |
| `repeatable` | `false` (default) offers it once. |
| `steps` | 1 to 8 steps. `{origin}`, `{destination}` and `{deadline}` in `text` are filled in by the game. |
| `reward` | Credits, standing, and nothing else. **The game caps it**: credits are limited by the mission's rank and its number of steps, so a mod can't pay out unlimited credits. The cap is shown in the Mods menu. |
| `on_step`, `on_complete`, `on_fail` | Optional callbacks (`ui.toast` and `store` work inside them, like any handler). |

**Step kinds**

| `kind` | The player must |
|---|---|
| `pickup` | Collect a named cargo at a station (`at`: `"nearest"` or a station name). |
| `deliver` | Bring the mission's cargo to a station (`to`: a station name, `"other-world"` or `"other-system"`). `deadline` in minutes is optional. |
| `visit` | Dock at a station. |
| `land` | Land on an outpost pad (`to`: a name or `"outpost"`). |
| `survive` | Stay alive, with no hull below 20%, for the length of a flight leg or the number of `seconds`. |
| `wait` | Spend `seconds` docked or landed (a meeting that takes a while). |

A mission can end in failure (late delivery, abandoned cargo, destroyed hull). That fires `on_fail` and may cost
standing as the game's own contracts do.

