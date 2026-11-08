---
layout: doc
title: "Game events"
section: api-hooks
group: api
preview: true
---

## Events

Register with `on(name, function(e) ... end)`. You may register several handlers for one event. The payload `e` is a
read-only table.

| Event | Payload | Fires when |
|---|---|---|
| `docked` | `station`, `world` | The ship docks. |
| `undocked` | `station`, `world` | The ship launches. |
| `delivered` | `client`, `type`, `reward`, `damage` (0 to 1), `station` | A contract is completed. |
| `contract_accepted` | `client`, `type`, `reward`, `destination` | A contract is taken. |
| `cargo_damaged` | `percent`, `cause` (`raiders`, `collision`, `rough flying`) | The cargo takes damage. |
| `hull_changed` | `hull` (0 to 100) | The hull value changes (not every frame). |
| `jumped` | `from`, `to` | The ship arrives in another system. |
| `landed` | `outpost`, `world` | The ship lands at an outpost. |
| `pirates_arrived` | `count` | Raiders appear. |
| `mission_started` | `id`, `title` | A mission from this mod is accepted. |
| `mission_step` | `id`, `step` (1-based) | The player completes a step. |
| `mission_completed`, `mission_failed` | `id` | A mission ends. |
| `event_started` | `id`, `kind`, `where` | A mod event appears in the sector. |
| `event_chosen` | `id`, `choice` (1-based) | The player picks a choice in an event dialog. |

Events can't be canceled or altered. A mod reacts to what happens, and changes how the game plays through `tweaks.set`, missions, events and contracts (below).

