---
layout: doc
title: "Music"
section: api-music
group: api
preview: true
---

## `music.add{...}`: writing a track
New to music? Read `docs/MUSIC_GUIDE.md` first: it teaches notes, chords and melodies from scratch, with the numbers.

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


## `music.midi{...}`: MIDI files

A `.mid` file in the mod folder plays as written: its own instruments, tempo and arrangement, through the game's
sampled soundfont. This is the easy route if you already write music in a program (a DAW or a notation program).

```lua
music.midi{ file = "midi/harbor.mid", mood = "docked", name = "Harbor Lights", loop = true }
```

| Field | Values | Notes |
|---|---|---|
| `file` | path inside the mod | Standard MIDI file, type 0 or 1. |
| `mood` | as for `music.add` | When it plays. |
| `name` | text | Optional; defaults to the file name. |
| `loop` | true / false | `true` repeats it; `false` plays once and then hands over to the usual choice for the mood (default). |
| `gain` | 0.2 to 1.5 | Optional volume trim (default 1). |

**No code needed:** any file in `midi/<mood>/` (for example `midi/docked/harbor.mid`) is picked up on its own, named after its file,
set to play once. The `music.midi` call is for choosing a name, looping or a gain.

- MIDI tracks join the mood's list with the synth tracks and recorded music, so the next and previous track keys step
  through them too, and they crossfade like the rest.
- **They need the sampled soundfont.** If the player has "Sampled instruments" switched off or no soundfont installed,
  MIDI tracks are skipped for that player.
- **Limits:** up to 24 MIDI files per mod, 1 MB each, 100,000 notes each; a file over the limit is skipped with a
  message under the mod. Tempo changes, program changes, volume, pan, pitch bend and sustain are honored. Anything
  else (SysEx, lyrics, meta text) is ignored.
- **Rights:** only upload MIDI you have the right to share. A MIDI of a copyrighted song is still that song.

