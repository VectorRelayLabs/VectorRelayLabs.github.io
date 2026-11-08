---
layout: doc
title: "Tweaks"
section: api-tweaks
group: api
preview: true
---

## `tweaks.set(key, value)`: changing the game

A mod can change how existing things behave by setting **tweaks**: named values the game exposes on purpose. This
is how a mod makes the game harder, slower, richer or stranger without touching the game's code. Every value is
clamped to a safe range, and the Mods menu lists exactly what each active mod changes.

```lua
tweaks.set("economy.contract_pay", 1.25)        -- contracts pay 25% more
tweaks.set("cargo.damage_rate", 1.5)            -- cargo is 50% more fragile
tweaks.set("pirates.frequency", 0.5)            -- raiders appear half as often
tweaks.set("fuel.price", 0.8)                   -- fuel is 20% cheaper
```

| Key | What it scales | Range |
|---|---|---|
| `economy.contract_pay` | Contract rewards | 0.5 to 2.0 |
| `economy.trade_margin` | The spread between buying and selling prices | 0.5 to 2.0 |
| `economy.market_events` | How often shortages and booms occur | 0 to 3 |
| `fuel.price`, `repair.price`, `tow.fee` | Service prices | 0.25 to 3.0 |
| `fuel.burn` | Fuel use | 0.5 to 2.0 |
| `cargo.damage_rate` | Damage cargo takes from hits and rough flying | 0 to 3 |
| `pirates.frequency`, `pirates.aggression` | How often and how hard raiders come | 0 to 3 |
| `storms.frequency` | Ion storms | 0 to 3 |
| `traffic.density` | Ships coming and going | 0 to 2 |
| `career.points` | Career points earned | 0.5 to 3 |
| `standing.gain`, `standing.loss` | Standing changes | 0.5 to 2.0 |
| `contracts.per_board` | Contracts offered on each station board | 0.5 to 2.0 |

- Several mods setting the same key **multiply** together, within the range, in load order.
- There is no way to set a value outside its range, and the keys above are the whole list. A mod that needs one
  more asks for it to be added.
- **Not changeable:** a ship's physics, the save format, and anything about other players' sessions.

