---
layout: doc
title: Lua API reference
section: api
preview: true
---


**Status: a preview.** None of this exists in the game yet. It describes what a Lua mod will look like, so the shape can be discussed before it is built. The [example mod](example-mod.html) uses it end to end.

A mod is a folder with a `mod.lua` (and optionally `preview.png`, audio files and `.mid` MIDI files). Lua is the only mod format.
`mod.lua` runs once when the mod loads, then your event handlers run when things happen.

## Rules of the sandbox

- Only the base language is available: `string`, `table`, `math`, and `pairs`/`ipairs`/`type` and the like.
  There is **no** `io`, `os`, `debug`, `package` or `require` of files, and no network.
- Every call into your code (the main chunk and each event handler) has a budget of about 100,000 VM
  instructions. Going over stops that call and shows an error under the mod in the Mods menu.
- An error in a handler disables that handler's mod and shows the message. It never crashes the game.
- You only ever see plain values (numbers, strings, booleans, tables). No game objects.
- Strings you give the game may not contain `<` or `>` and are cut to their limits (below).
- Lua is loaded as text only (no precompiled bytecode), so what a player installs is readable source.
- A mod is switched on and off with the Mods menu, and loads and unloads while the game runs. Unloading removes
  its handlers, windows, HUD widgets and keybinds.

## Manifest

Set these at the top of `mod.lua`:

| Field | Type | Notes |
|---|---|---|
| `mod.id` | string | 2 to 39 characters: lowercase letters, digits, hyphens. Unique. |
| `mod.name` | string | Shown in the Mods menu. |
| `mod.version` | string | `1.0` or `1.2.3`. |
| `mod.api` | number | The oldest API version the mod needs. A newer requirement than the game offers skips the mod with a message. |
| `mod.author`, `mod.description` | string | Optional. |
| `mod.permissions` | table | Names of extra things the mod asks for. v1 defines none; leave it `{}`. |

## Data registries

### `music.add{...}`: writing a track
New to music? Read the [music guide](music-guide.html) first: it teaches notes, chords and melodies from scratch, with the numbers.

You don't need to read music. A track is a **chord loop** plus a few knobs, and the game's synth turns it into
sound and never plays it quite the same way twice (the bells and the small details vary each time).

**How it plays**

- The track steps through your `chords` one at a time, each lasting `barsPerChord` bars, and loops back to the
  first. A bar is 4 beats; `bpm` is beats per minute.
- Each chord is **five notes**: `chord(bass, a, b, c, d)`.
  - `bass` is the low note, played on its own as the bassline.
  - `a`, `b`, `c`, `d` are the four notes of the chord. The **pad** (soft sustained sound) holds all four for the
    whole chord, and the **arpeggio** (a stream of plucked notes) walks up and down through them over two octaves.
- Notes are **MIDI numbers**: middle C is 60, and each +1 is one semitone (piano key) higher. +12 is the same note
  one octave up. `note("D4")` gives the number for a note name (see Helpers).

  | | C | D | E | F | G | A | B |
  |---|---|---|---|---|---|---|---|
  | Octave 2 (bass range) | 36 | 38 | 40 | 41 | 43 | 45 | 47 |
  | Octave 3 | 48 | 50 | 52 | 53 | 55 | 57 | 59 |
  | Octave 4 (middle) | 60 | 62 | 64 | 65 | 67 | 69 | 71 |
  | Octave 5 | 72 | 74 | 76 | 77 | 79 | 81 | 83 |

  Add 1 for a sharp (C# = 61), subtract 1 for a flat (Bb = 58).
- Easy way to build a chord: pick a bass note (octave 2 or 3), then four notes from octave 3 and 4 that sound good
  together. `chord(38, 62, 65, 69, 76)` is D in the bass over D minor (D F A) with an E on top, which sounds
  open and spacey. Chords that share notes with their neighbors flow smoothly.

**Fields**

| Field | Values | What it does |
|---|---|---|
| `name` | text | Shown when you switch tracks. |
| `mood` | `flight`, `cruise`, `docked`, `tension`, `surface` | When the game plays it: flying, in cruise, docked, in danger, near a planet's ground. The title song can't be replaced. |
| `bpm` | 70 to 200 | Speed. 60 to 80 is calm, 90 to 110 is driving. |
| `barsPerChord` | 1 to 4 | How long each chord lasts. 2 is relaxed, 1 is busy. |
| `chords` | 1 to 16 chords | The loop. 4 chords is typical; the loop repeats. |
| `transpose` | -12 to 12 | Moves the whole track up or down this many semitones (all chords, melody and bells). Handy for making a second version in another key. |
| `arpStyle` | 0, 1, 2 | The arpeggio pattern: 0 up and back down, 1 always rising then restarting, 2 broken (a skipping, zig-zag pattern). Also picks the instrument (harp, music box or nylon guitar when the soundfont is on). |
| `melody` | list, optional | A tune on top, see below. |
| `mix` | levels 0 to 1.5 | How loud each layer is, see below. |

**Melody**

The melody is a list of **eighth notes** (8 to a bar). Each entry is a MIDI note, or `-2` for "keep holding the
previous note", or `-1` for a rest (silence). So `{ 74,-2,-2,-2, 77,-2,-2,-2 }` is one bar: a D held for half a bar,
then an F held for the other half.

- The list must be whole bars (a multiple of 8). The game plays it bar by bar and loops it.
- To make the melody cover the whole loop, make it `#chords * barsPerChord * 8` long: 4 chords at 2 bars each is
  64 entries. A shorter melody just repeats against the chords, which can sound great or odd.
- Write notes that fit the chord playing at that time (the notes in that chord's `a`, `b`, `c`, `d`, give or take an
  octave) and the melody will always sound right.
- `rep(list, n)` and `join(...)` save typing for repeated bars.

**Mix: what the layers are**

`mix = { pad, bass, arp, bells, drums, bright, lead, arpDiv }`. Each is 0 (off) to 1.5; most tracks use 0.1 to 0.9.

| Layer | What you hear |
|---|---|
| `pad` | The held chord, soft and wide. The backbone of calm tracks. |
| `bass` | The low note. Long and gentle when there are no drums; a steady eighth-note pulse when `drums` is above 0.3. |
| `arp` | The plucked arpeggio. Under 0.05 it's off. |
| `arpDiv` | Pluck speed: 2 means every eighth note (calm), 1 means every sixteenth (busy and driving). |
| `bells` | Sparse, random bell notes drifting over the top. Higher means more of them. |
| `drums` | Above 0.12: a kick on beats 1 and 3. Above 0.3: hi-hats. Above 0.5: a kick on 2 and 4 as well. |
| `bright` | How bright the sound is (filter opening). Low is dark and warm, high is crisp. |
| `lead` | The melody's volume. Only matters if you gave a `melody`. |

**Three starting points**

| Feel | bpm | barsPerChord | arpDiv | pad | bass | arp | bells | drums | bright |
|---|---|---|---|---|---|---|---|---|---|
| Calm (docked, surface) | 66 to 80 | 2 | 2 | 0.85 | 0.45 | 0.2 | 0.5 | 0 to 0.15 | 0.35 |
| Cruising (flight, cruise) | 88 to 104 | 1 | 1 | 0.5 | 0.85 | 0.8 | 0.1 | 0.6 to 0.8 | 0.8 |
| Danger (tension) | 84 to 150 | 1 or 2 | 1 | 0.4 to 0.7 | 0.9 | 0.5 | 0 | 0.5 to 0.9 | 0.3 to 0.7 |

**Limits and checks**

Up to 64 tracks per mod. Notes must be 24 to 108, chords 1 to 16, melodies up to 64 bars. A bad track is skipped with
a warning in the Mods menu (it says which field), and the others still load. The in-game next and previous track
keys include your tracks. Your tracks play through the same instruments as the built-in ones (with the sampled
soundfont when the player has it on); choosing instruments yourself isn't in v1.

### `music.midi{...}`: MIDI files

A `.mid` file in the mod folder plays as written: its own instruments, tempo and arrangement, through the game's
sampled soundfont. This is the easy route if you already write music in a program (a DAW or a notation program).

```lua
music.midi{ file = "midi/harbour.mid", mood = "docked", name = "Harbour Lights", loop = true }
```

| Field | Values | Notes |
|---|---|---|
| `file` | path inside the mod | Standard MIDI file, type 0 or 1. |
| `mood` | as for `music.add` | When it plays. |
| `name` | text | Optional; defaults to the file name. |
| `loop` | true / false | `true` repeats it; `false` plays once and then hands over to the usual choice for the mood (default). |
| `gain` | 0.2 to 1.5 | Optional volume trim (default 1). |

**No code needed:** any file in `midi/<mood>/` (for example `midi/docked/harbour.mid`) is picked up on its own, named after its file,
set to play once. The `music.midi` call is for choosing a name, looping or a gain.

- MIDI tracks join the mood's list with the synth tracks and recorded music, so the next and previous track keys step
  through them too, and they crossfade like the rest.
- **They need the sampled soundfont.** If the player has "Sampled instruments" switched off or no soundfont installed,
  MIDI tracks are skipped for that player.
- **Limits:** up to 24 MIDI files per mod, 1 MB each, 100,000 notes each; a file over the limit is skipped with a
  message under the mod. Tempo changes, program changes, volume, pan, pitch bend and sustain are honored. Anything
  else (SysEx, lyrics, meta text) is ignored.
- **Rights:** only upload MIDI you have the right to share. A MIDI of a copyrighted song is still that song.

### `text.clients(name, ...)` and `text.cargo(kind, line, ...)`

Adds client names and cargo names. `kind` is one of `standard`, `fragile`, `express`, `hazardous`, `charter`,
`convoy`, `contraband`, `rendezvous`, `outpost`, `favor`. Lines are at most 60 characters, 500 per mod.

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

No event can be canceled or changed in v1. Mods react; they don't decide.

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
| `contracts.offer{...}` | Puts a contract in the current station's board. Fields: `type`, `client`, `cargo`, `destination` (`"nearest"` or a station name), `reward`, `deadline` (minutes). The game applies its own limits: reward is capped per type, and the contract can be declined like any other. |

There is no function that gives credits, items or fuel directly. Rewards come through contracts.

## Saved data

`store` is a table saved with the game save, one per mod. Keys are strings; values are numbers, strings, booleans or
nested tables of those. The total is capped at 64 KB (extra writes are dropped with a warning). A mod that is removed
leaves its store in the save, ready if it comes back.

## UI

### Windows

```lua
local win = ui.window{ title = "TITLE", width = 640 }
```

A window is a menu screen: it opens from a keypress or the Mods menu, pauses ship controls like other menus, and
closes with Escape. Mods cannot open a window by themselves during flight (use `ui.toast` for that).

| Window method | Meaning |
|---|---|
| `win:label(text)` | A line of text; returns a handle with `:set(text)`. |
| `win:button{text=, on_click=}` | A button. |
| `win:switch{label=, value=, on_change=}` | OFF/ON, like the settings rows. |
| `win:slider{label=, min=, max=, step=, value=, format=fn, on_change=}` | A slider. `format` turns the number into text. |
| `win:choice{label=, options={...}, value=, on_change=}` | Left/right chooser; `value` and the callback use the 1-based index. |
| `win:list{height=}` | A scrolling list; handle has `:add(text)`, `:clear()`. |
| `win:progress{label=, value=}` | A bar, 0 to 1; handle has `:set(v)`. |
| `win:row(a, b, ...)` | Puts the given widgets side by side. |
| `win:open()`, `win:close()`, `win:toggle()` | Show, hide, or flip the window. |

Layout is rows and columns only (no pixel positions), so every window works with a pad. Widgets use the game's own
look and scale with the UI settings.

### HUD widgets

```lua
local hud = ui.hud{ anchor = "top-right", width = 220 }
local line = hud:label("text")
line:set("new text")
```

Read-only (no buttons), at most 3 per mod. `anchor` is one of `top-left`, `top-right`, `bottom-left`,
`bottom-right`. They are drawn under the game's own HUD and hide in photo mode and menus.

### Keybinds

`bind(label, defaultKey, fn)` registers an action in Settings > Controls under the mod's name, so players can
rebind it. If the default key clashes with another action the mod loads but the key starts unbound, and the Mods
menu says so. Mods never read the keyboard directly.

## Co-op

- Music and text from a mod are cosmetic and don't need to match between players.
- A mod with event handlers, `contracts.offer` or a window that reads economy state is gameplay: every player
  must have the same mod and version, and a joining player is asked first (nothing installs unprompted).
- `contracts.offer` runs on the host only; on a client it is ignored.

## Versioning

`api` is a whole number. Additions keep the number; a breaking change bumps it, and the game keeps loading older
mods for at least one version back. The Mods menu shows each mod's `api`.

## Limits at a glance

| Thing | Limit |
|---|---|
| Instructions per call | about 100,000 |
| Music tracks per mod | 64 |
| Text lines per mod | 500, each at most 60 characters |
| HUD widgets per mod | 3 |
| `store` size | 64 KB |
| Files in a mod | `.lua`, `.png`, `.mid`, `.ogg`, `.wav`, `.mp3`; each under 256 KB except audio (up to 40 MB) and MIDI (1 MB) |
| MIDI files per mod | 24, up to 100,000 notes each |
