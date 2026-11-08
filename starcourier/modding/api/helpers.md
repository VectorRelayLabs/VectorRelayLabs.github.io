---
layout: doc
title: "Helpers"
section: api-helpers
group: api
preview: true
---

## Helpers

| Function | Returns |
|---|---|
| `chord(bass, a, b, c, d)` | A chord table (MIDI notes 24 to 108). |
| `rep(list, n)` | The list repeated `n` times. |
| `join(list, list, ...)` | The lists joined into one. |
| `map(fn, list)` | A new list with `fn` applied to each item. |
| `transpose(chord, semitones)` | A chord moved up or down. |
| `note(name)` | The MIDI number for a note name: `note("D4")` is 62, `note("Bb2")` is 46, `note("F#3")` is 54. |
| `rand(n)` / `rand(a, b)` | A seeded random integer (the same sequence for the same game seed). |

