---
layout: doc
title: "State, actions and saving"
section: api-state
group: api
preview: true
---

## Reading state

All read-only.

| Call | Returns |
|---|---|
| `ship.speed()` | Speed in m/s. |
| `ship.fuel()` | Fuel, 0 to 100. |
| `ship.hull()` | Hull, 0 to 100. |
| `ship.docked()` | The station name, or `nil`. |
| `economy.credits()` | Credits. |
| `economy.standing(station)` | Standing with that station, -100 to 100. |
| `world.current()` | The current system and world names. |


## Actions

| Call | Effect |
|---|---|
| `ui.toast(text)` | A message in the corner, like the game's own. |
| `sfx.play(name)` | One of the built-in sounds: `click`, `blip`, `error`, `sting`, `cash`. Nothing else. |
| `ui.dialog{title, text, choices}` | A dialog with up to four buttons (see below). |
| `contracts.offer{...}` | Puts a contract in the current station's board. Fields: `type`, `client`, `cargo`, `destination` (`"nearest"` or a station name), `reward`, `deadline` (minutes). The game applies its own limits: reward is capped per type, and the contract can be declined like any other. |

There is no function that gives credits, items or fuel directly. Rewards come through contracts, and through mission and event rewards that are declared in the registry and capped by the game.


## Saved data

`store` is a table saved with the game save, one per mod. Keys are strings; values are numbers, strings, booleans or
nested tables of those. The total is capped at 64 KB (extra writes are dropped with a warning). A mod that is removed
leaves its store in the save, ready if it comes back.

