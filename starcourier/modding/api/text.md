---
layout: doc
title: "Text and names"
section: api-text
group: api
preview: true
---

## `text.clients(name, ...)` and `text.cargo(kind, line, ...)`

Adds client names and cargo names. `kind` is one of `standard`, `fragile`, `express`, `hazardous`, `charter`,
`convoy`, `contraband`, `rendezvous`, `outpost`, `favor`. Lines are at most 60 characters, 500 per mod.


## Replacing text and names

`text.replace(old, new)` swaps a game string for another in the same mod's language file (station names, contract
text, radio lines). It only works for text the game marks as replaceable, and the result is checked like any text
(length, no angle brackets).
