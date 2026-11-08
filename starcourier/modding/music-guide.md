---
layout: doc
title: Writing music for Star Courier
section: music
---


A hands-on guide for people who have never written music. You'll learn just enough theory to build a track,
and every idea comes with the actual numbers the game wants. It goes with the API reference in the [Lua API reference](lua-api.html)
(draft: the Lua loader isn't built yet, but the track data below is exactly what the synth plays today).

Contents: 1. Notes and numbers · 2. Scales · 3. Chords · 4. How the game builds a chord · 5. Time: bars, beats, steps · 6. Melody · 7. The arpeggio · 8. The other layers · 9. The mix · 10. Moods · 11. Build a track step by step · 12. When it sounds wrong · 13. Reference tables · 14. MIDI files

---

## 1. Notes and numbers

Every note is a number (a **MIDI note number**, the same numbers any music program uses).

- Each step of **+1** is the next key on a piano, black or white. That step is a **semitone**.
- **+12** is the same note one **octave** higher: it sounds like "the same note, thinner". So 60, 72 and 84 are all C.
- **Middle C is 60.** Bigger numbers sound higher.

A piano octave has 12 keys: C, C#, D, D#, E, F, F#, G, G#, A, A#, B. The black keys are the sharps (#) or, from
the other side, flats (b): C# is the same key as Db. Counting from C = 0:

| C | C# | D | D# | E | F | F# | G | G# | A | A# | B |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |

So **a note's number = 12 × (octave + 1) + its position above**. Octave 4 starts at 60 (C4), so D4 = 60 + 2 = 62
and Bb4 = 60 + 10 = 70. You don't need the formula; use the table:

| Octave | C | C# | D | D# | E | F | F# | G | G# | A | A# | B |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 24 | 25 | 26 | 27 | 28 | 29 | 30 | 31 | 32 | 33 | 34 | 35 |
| 2 | 36 | 37 | 38 | 39 | 40 | 41 | 42 | 43 | 44 | 45 | 46 | 47 |
| 3 | 48 | 49 | 50 | 51 | 52 | 53 | 54 | 55 | 56 | 57 | 58 | 59 |
| 4 | 60 | 61 | 62 | 63 | 64 | 65 | 66 | 67 | 68 | 69 | 70 | 71 |
| 5 | 72 | 73 | 74 | 75 | 76 | 77 | 78 | 79 | 80 | 81 | 82 | 83 |
| 6 | 84 | 85 | 86 | 87 | 88 | 89 | 90 | 91 | 92 | 93 | 94 | 95 |

(A# and Bb are the same key. The game accepts notes 24 to 108.)

**Rough ranges:** bass notes live around 36 to 48 (octave 2 and 3), chords around 55 to 76 (octave 3 to 5), melodies
around 62 to 88 (octave 4 to 6). Below 36 is a rumble; above 90 is a squeak.

---

## 2. Scales: the notes that belong together

Picking notes at random sounds wrong, because most of the 12 notes clash with each other. A **scale** is a set of
7 notes that sound good together. You build one from a starting note (the **root**) by stepping up by these gaps
(in semitones):

- **Major scale** (bright, happy): 2, 2, 1, 2, 2, 2, 1
- **Minor scale** (dark, calm, spacey): 2, 1, 2, 2, 1, 2, 2

D minor, from D (62): 62 → +2 = 64 (E) → +1 = 65 (F) → +2 = 67 (G) → +2 = 69 (A) → +1 = 70 (Bb) → +2 = 72 (C) → +2 = 74 (D).
That gives the notes **D E F G A Bb C**. Play them all and it already sounds like a space film. Every built-in
track is in D minor or close to it, which is why they sit together well.

| Scale | Root | Notes (octave 4) as numbers |
|---|---|---|
| D minor | D | 62 64 65 67 69 70 72 (74) |
| A minor | A | 69 71 72 74 76 77 79 (81) |
| C major | C | 60 62 64 65 67 69 71 (72) |
| G minor | G | 67 69 70 72 74 75 77 (79) |

**Minor pentatonic** keeps 5 of the 7 notes and has no clashes at all, so it's a great way to start: from the root,
step by 3, 2, 2, 3, 2. In D minor: **D F G A C** = 62 65 67 69 72. Any notes from it, in any order, sound fine.

---

## 3. Chords

A **chord** is notes played together. You build one by stacking every other note of a scale:

- **Minor triad** (root + 3 + 7 semitones): D minor = D, F, A = 62, 65, 69. Calm, a little sad.
- **Major triad** (root + 4 + 7): D major = D, F#, A = 62, 66, 69. Bright.
- **7th** (add the note 10 or 11 above the root): adds a soft, jazzy colour. `Dm7` = D F A C = 62, 65, 69, 72.
  `maj7` (11 above) is dreamy: `Bbmaj7` = Bb D F A = 58, 62, 65, 69.
- **9th** (add the note 14 above the root, which is the same note as 2 above, an octave up): even more open.
  `Dm9` = D F A + E = 62, 65, 69, 76 (E an octave up).
- **sus2 / sus4** (swap the third for the note 2 or 5 above the root): neither happy nor sad, just floating.
  `Csus2` = C D G = 60, 62, 67. `A7sus4` = A D E G = 57, 62, 64, 67.

You don't need to remember this: just keep the **chord's own notes** in the four slots (section 4). Chords sound
best when they **share notes** with the next one. Look at these four in the built-in "Outbound":

| Chord | Notes | Shares with the next |
|---|---|---|
| Dm9 | D F A E | F and A |
| Bbmaj7 | Bb D F A | D, F and A |
| Fadd9 | F C G A | A |
| Csus2 | C D G C | G |

That sharing is why the loop feels like one smooth thing instead of four unrelated chords.

**Chord loops that work** (in D minor, as a starting menu):

- `Dm  Bb  F  C`: the classic "epic and open" loop
- `Dm  Bb  Gm  A`: a little more tension, pulling back to Dm
- `Dm  F  C  Gm`: gentle and floaty
- `Bbmaj7  Am7  Gm9  A7sus4`: slow, dreamy (the built-in "Slow Lights")

---

## 4. How the game builds a chord

You give each chord **five numbers**: `chord(bass, a, b, c, d)`.

- **`bass`** is the one low note, played on its own as the bassline. Use the chord's root, in octave 2 or 3.
- **`a, b, c, d`** are the four chord notes. They have three jobs at once:
  1. the **pad** holds all four for the whole chord;
  2. the **arpeggio** plays them one at a time, then again an octave higher (so 8 notes total);
  3. the **bells** and **melody** are separate (sections 6 and 8).

Worked example. We want **D minor 9**:

- root D → bass in octave 2 = **38**
- chord notes D F A E in the middle: D4 62, F4 65, A4 69, E5 76 (the 9th sits high, as it does in real voicings)
- result: `chord(38, 62, 65, 69, 76)`

Another: **Bb major 7**, with the root Bb at 46 in the bass:

- notes Bb D F A = 58, 62, 65, 69
- result: `chord(46, 58, 62, 65, 69)`

Rules of thumb for the four notes `a, b, c, d`:

- Keep them **ascending** and within about an octave and a half (55 to 76). That keeps the pad smooth.
- Don't repeat the bass note's exact pitch in `a`, or the bass and pad will blur.
- `a` is the lowest and `d` the highest; the top note is the one you hear most, so put an interesting note there
  (a 9th, a 7th, a sus note).

Real chords from the game, ready to copy:

| Chord | `chord(...)` | | Chord | `chord(...)` |
|---|---|---|---|---|
| Dm9 | 38, 62, 65, 69, 76 | | Gm9 | 43, 58, 62, 65, 69 |
| Dm | 38, 57, 62, 65, 69 | | Gm | 43, 58, 62, 67, 70 |
| Bbmaj7 | 46, 58, 62, 65, 69 | | Am7 | 45, 57, 60, 64, 67 |
| Bb | 46, 58, 62, 65, 70 | | A7sus4 | 45, 57, 62, 64, 67 |
| Fadd9 | 41, 60, 65, 67, 69 | | Amaj | 45, 57, 61, 64, 69 |
| F | 41, 60, 65, 69, 72 | | Eb | 39, 58, 63, 67, 70 |
| Fmaj7 | 41, 57, 60, 64, 69 | | Bbm | 46, 58, 61, 65, 70 |
| Csus2 | 48, 60, 62, 67, 72 | | Cmaj | 48, 60, 64, 67, 72 |

**To move a whole track to another key**, don't rewrite the chords: set `transpose` (see section 9). `transpose = 5`
moves everything up 5 semitones (D minor becomes G minor).

---

## 5. Time: bars, beats and steps

- **Tempo (`bpm`)** is beats per minute. 60 is one beat per second.
- A **bar** is 4 beats. At 72 bpm one bar lasts 60 / 72 × 4 = 3.3 seconds.
- Each chord lasts **`barsPerChord`** bars (1 to 4). A 4-chord loop at 2 bars each is **8 bars**, which at 72 bpm
  is 27 seconds before it repeats.
- The game counts a bar in **16 steps** (sixteenth notes). Step 0 is the start of the bar. Everything in the track
  hangs off those steps:

| Steps | 0 1 2 3 | 4 5 6 7 | 8 9 10 11 | 12 13 14 15 |
|---|---|---|---|---|
| Beat | 1 | 2 | 3 | 4 |

- **Eighth notes** are every second step (0, 2, 4, ... 14): 8 of them per bar. The melody is written in eighths.

**Loop length** = `#chords × barsPerChord` bars. Pick it on purpose: 4 chords × 2 bars = 8 bars is a good length for a
melody to fill; 4 × 1 = 4 bars suits a busy cruise track.

**Tempo guide:**

| bpm | Feels like |
|---|---|
| 60 to 72 | Sleeping, waiting, a quiet hangar |
| 72 to 88 | Cruising calmly, drifting |
| 88 to 104 | Moving with purpose |
| 104 to 130 | Racing, chased |
| 130 to 200 | Panic (use sparingly) |

---

## 6. Melody

A melody is a **list of numbers**, one per eighth note, so **8 per bar**:

- a **note number** (62, 69, ...) starts that note;
- **`-2`** means "keep holding whatever note is playing";
- **`-1`** means a rest (silence, the note stops).

One bar, written out. Each box is an eighth note:

```
step:    0    2    4    6    8   10   12   14      (the 16-step bar, eighths only)
beat:    1    .    2    .    3    .    4    .
        74   -2   -2   -2   77   -2   -2   -2
```

This plays D5 for the first half of the bar (beats 1 and 2) and F5 for the second half (3 and 4): two long notes.
A busier bar:

```
        76   -2   74   -2   72   -2   -2   -1
```

E5 (a beat), D5 (a beat), C5 (a beat and a half), then a rest for the last eighth.

**How the game uses the list:**

- It reads **one bar of 8 entries per bar** and **wraps around** when the list ends. The list length must be a
  multiple of 8, and up to 64 bars.
- The list is indexed by the **bar count**, not by chord: bar 1 reads entries 1 to 8, bar 2 reads 9 to 16, and so on.
  If your loop is 8 bars (4 chords × 2), write **64 entries** and the melody lines up with the chords exactly.
- If you write fewer (say 32, 4 bars), it repeats twice over the 8-bar chord loop, which can be lovely: the same
  tune over changing chords.
- A melody **note + `transpose`** is what plays, so the melody follows the track's key shift.

**Writing a melody that fits:**

1. Look at the chord playing in that bar. Its notes (`a, b, c, d`, in any octave) are the "safe" notes; start and end
   phrases on them.
2. Between those, you may use any note of the key (section 2) as passing notes, but keep them on the weaker beats
   (the "and" of a beat).
3. Mostly **move by small steps** (1 to 3 semitones). Big jumps (7+) are dramatic; use one per phrase.
4. **Leave space.** Rests and long holds are what make a tune memorable. If every eighth note has a new pitch it
   sounds like a ringtone.
5. Repeat an idea with a small change. Bars 1 and 3 almost the same is a tune; all different is noise.

Example: over `Dm9` for 2 bars (16 entries): notes of Dm9 are D F A E (62 65 69 76), so

```
  74 -2 -2 -2 77 -2 -2 -2   76 -2 74 -2 72 -2 -2 -1
  D5            F5          E5    D5    C5
```

D5 and F5 are chord notes (stable); E5, D5 and C5 walk down the scale (movement); the last eighth rests before the
next chord. It sounds finished because the walk ends on a note (C5) that leads into the next chord.

---

## 7. The arpeggio

The arpeggio plays your four chord notes `a, b, c, d` one at a time. It builds an **8-note ladder**: `a b c d` and the
same four an octave up (`a+12 b+12 c+12 d+12`), numbered 0 to 7. `arpStyle` decides the walk:

| `arpStyle` | Walk through the ladder | Sound |
|---|---|---|
| 0 | 0 1 2 3 4 5 6 7 6 5 4 3 2 1 (up and back down) | Smooth waves; the default |
| 1 | 0 1 2 3 4 5 6 7 (up, then straight back to the bottom) | Rising, hopeful; a harp sweep |
| 2 | 0 2 1 3 2 4 3 5 4 6 5 7 (broken: step back, jump forward) | Busy, zig-zag; a music box |

The walk restarts at the beginning of every chord. A note is played every `arpDiv` steps: **`arpDiv = 2`** plays every
eighth note (8 per bar, relaxed); **`arpDiv = 1`** plays every sixteenth (16 per bar, driving). The notes alternate
between the left and right speakers a little.

With the soundfont on, the style also picks the instrument: 0 is a harp, 1 is a music box, 2 is a nylon guitar.

---

## 8. The other layers

- **Pad:** the four chord notes held, soft. It carries calm tracks. Mix: `pad`.
- **Bass:** with `drums` below 0.3, the bass plays the `bass` note long, twice a bar (steps 0 and 8). With `drums`
  above 0.3 it switches to a pulse: the `bass` note on every eighth (even steps), jumping up an octave on steps 6
  and 14 for a bounce. Mix: `bass`.
- **Bells:** sparse, random notes that drift up and down by small steps over the top. They always use the
  **D minor pentatonic** (D F G A C), moved by `transpose`. Mix: `bells`. **Important:** if your chords are in another key, either set `transpose` so the bells
  land in your key, or turn `bells` to 0, otherwise the bells will clash. The chance of a bell each eighth note is
  `bells × 16%`, so 0.5 is a bell about every 12 eighth notes.
- **Drums:** a kick on beats 1 and 3 once `drums` > 0.12; hi-hats on every 4th step (offbeat) once > 0.3; and a kick on
  beats 2 and 4 too once > 0.5. A harder number is a louder hit. Mix: `drums`.
- **Lead:** your melody (section 6), as a flute-like voice. Mix: `lead`. Without a `melody` it is silent.
- **Brightness (`bright`):** not a note but a filter: low values muffle the pad and pluck (warm, dark); high ones
  open them (crisp). 0.3 is soft, 0.8 is bright.

---

## 9. The mix

All the knobs in one place. Levels go from 0 (off) to 1.5; most tracks sit between 0.1 and 0.9.

| Knob | 0 | 0.5 | 1 | Note |
|---|---|---|---|---|
| `pad` | silent | present | loud | Calm tracks: 0.8 to 0.95 |
| `bass` | silent | soft | strong | Calm: 0.45; driving: 0.85 |
| `arp` | off (below 0.05) | medium | busy | 0.15 to 0.35 for calm |
| `bells` | none | occasional | frequent | Only works well in D minor / with `transpose` |
| `drums` | none | kick and hats | hard | 0.1 is just a soft kick |
| `bright` | dark | medium | crisp | 0.3 calm; 0.8 driving |
| `lead` | silent | medium | loud | Use 0.7 to 0.85 when you have a melody |
| `arpDiv` | | | | 2 = eighths, 1 = sixteenths (a whole number, not a level) |

Other track settings: `transpose` (-12 to 12 semitones; applies to chords, melody and bells together) and `bpm`,
`barsPerChord`, `arpStyle` from sections 5 and 7.

**Three recipes:**

```
calm (docked / surface):  bpm 70, barsPerChord 2, arpStyle 1, arpDiv 2
                          pad 0.85  bass 0.45  arp 0.2  bells 0.5  drums 0.1  bright 0.35

cruising (flight / cruise): bpm 96, barsPerChord 1, arpStyle 2, arpDiv 1
                          pad 0.5  bass 0.85  arp 0.8  bells 0.1  drums 0.7  bright 0.85

danger (tension):         bpm 92, barsPerChord 1, arpStyle 1, arpDiv 1
                          pad 0.65  bass 0.9  arp 0.5  bells 0  drums 0.6  bright 0.3
```

---

## 10. Moods: when your track plays

| `mood` | The game plays it when... | Good for |
|---|---|---|
| `flight` | You're flying in open space | Calm to medium, steady |
| `cruise` | The cruise drive is engaged | Fast, driving, drums |
| `docked` | You're docked at a station | Very calm, slow, soft |
| `tension` | Pirates, a blockade scan, low hull, falling at a planet | Dark, driving, short chords |
| `surface` | Within 3 km of a planet's ground | Open, quiet, wide |

Only the title song (`menu`) can't be replaced. The game picks randomly among all tracks of the current mood, mixing
in recorded music according to the player's setting, and the player can step through them with the next/previous
track keys, so a mood with five tracks keeps the music from repeating.

---

## 11. Build a track, step by step

Goal: a calm docked track in D minor.

1. **Mood and speed.** `mood = "docked"`, `bpm = 68`, `barsPerChord = 2`.
2. **Pick a loop** from section 3: `Bbmaj7  Am7  Gm9  A7sus4` (slow and dreamy). That is 4 chords × 2 bars = 8 bars,
   about 28 seconds before it repeats at 68 bpm.
3. **Write the chords** (section 4 table):
   ```
   chord(46, 58, 62, 65, 69),   -- Bbmaj7
   chord(45, 57, 60, 64, 67),   -- Am7
   chord(43, 58, 62, 65, 69),   -- Gm9
   chord(45, 57, 62, 64, 67),   -- A7sus4
   ```
4. **Set the mix** from the calm recipe: `pad 0.9, bass 0.45, arp 0.2, bells 0.5, drums 0.1, bright 0.35, arpDiv 2`.
   Listen to it with no melody first. If the chords alone feel good, you're done with the hardest part.
5. **Add a melody** (optional): 64 entries for 8 bars. Start by writing only the first note of each chord's 2-bar
   phrase from the chord's notes: over Bbmaj7 start on D5 (74), over Am7 on E5 (76), over Gm9 on D5 (74), over A7sus4
   on D5 (74). Then fill: hold each start note for 4 eighth notes, add a step or two, leave a rest at the end.
   ```
   74 -2 -2 -2 77 -2 76 -2   74 -2 -2 -2 -2 -2 -2 -1     -- Bbmaj7 (2 bars)
   76 -2 -2 -2 79 -2 77 -2   76 -2 -2 -2 -2 -2 -2 -1     -- Am7
   74 -2 -2 -2 77 -2 76 -2   74 -2 72 -2 70 -2 -2 -1     -- Gm9 (walks down)
   74 -2 -2 -2 76 -2 -2 -2   74 -2 -2 -2 -2 -2 -2 -1     -- A7sus4 (resolves to D)
   ```
   Check the starts against the chords: 74 (D) is in Bbmaj7 (Bb D F A), 76 (E) in Am7 (A C E G), 74 in Gm9, and 74 in
   A7sus4 (A D E G). Every phrase starts on a chord note.
6. **Set `lead`** to 0.75 so the melody is heard.
7. **Switch to a second version** by copying the track and changing `transpose = 5`, `arpStyle = 2` and
   `bpm = 62`. Two tracks from one idea.

---

## 12. When it sounds wrong

| Symptom | Cause | Fix |
|---|---|---|
| A clashing, "off" note keeps appearing | The bells (they are D minor pentatonic) in another key | Set `bells` to 0, or `transpose` so your key lines up with D minor |
| The melody sounds wrong against the chord | A note in the melody isn't in the chord or key | Check the chord's notes (section 4); end phrases on them |
| The melody doesn't line up with the chords | The list isn't `#chords × barsPerChord × 8` long | Count: 64 entries for 4 chords × 2 bars |
| It's muddy and boomy | The bass note is above 48, or `a` is the same as the bass | Bass in 36 to 48; `a` at least a 5th higher |
| It's thin and harsh | `bright` too high, `pad` too low | Lower `bright` to 0.35; raise `pad` |
| Too busy for a quiet moment | `arpDiv` 1, `arp` high, `drums` on | `arpDiv` 2, `arp` 0.2, `drums` under 0.12 |
| It lurches between chords | The chords share no notes | Swap one chord for one that shares 2 notes with its neighbours |
| The tune is boring | Every eighth note has a new pitch | Use holds (`-2`) and rests (`-1`); repeat an idea with small changes |
| Nothing plays | Notes outside 24 to 108, melody not a multiple of 8, or bad `mood` | The Mods menu shows the exact message |

---

## 13. Reference tables

**Intervals (semitones above the root):** unison 0 · minor 2nd 1 · major 2nd 2 · minor 3rd 3 · major 3rd 4 ·
perfect 4th 5 · tritone 6 · perfect 5th 7 · minor 6th 8 · major 6th 9 · minor 7th 10 · major 7th 11 · octave 12.

**Chord recipes** (semitones above the root):

| Chord | Notes above the root | D example (root 62) |
|---|---|---|
| major | 0 4 7 | 62 66 69 |
| minor | 0 3 7 | 62 65 69 |
| sus2 | 0 2 7 | 62 64 69 |
| sus4 | 0 5 7 | 62 67 69 |
| major 7th | 0 4 7 11 | 62 66 69 73 |
| minor 7th | 0 3 7 10 | 62 65 69 72 |
| dominant 7th | 0 4 7 10 | 62 66 69 72 |
| add9 | 0 4 7 14 | 62 66 69 76 |
| minor 9th | 0 3 7 10 14 | 62 65 69 72 76 |

For the game's four slots, drop the least important note (usually the 5th, then the root, since the bass already
plays the root).

**Durations in seconds:** one eighth note = 30 ÷ bpm. At 60 bpm that's 0.5 s, at 120 bpm it's 0.25 s. One bar = 240 ÷ bpm.

**Limits:** notes 24 to 108 · bpm 70 to 200 · 1 to 16 chords · barsPerChord 1 to 4 · melody up to 64 bars (a multiple of 8
entries) · 64 tracks per mod · mix 0 to 1.5 · `transpose` -12 to 12.

---

## 14. Already write music elsewhere? Use a MIDI file

Everything above is for building a track from the synth's chord loop. If you compose in a music program, export a
standard MIDI file (`.mid`) and the game plays it as written through the sampled soundfont, with your own notes,
instruments and tempo. Put it in `midi/<mood>/` in your mod (or register it with `music.midi{...}`, see
the [Lua API reference](lua-api.html)). The note numbers in section 1 are the same numbers a MIDI file uses, so everything you learned
here carries over. Limits: 1 MB and 100,000 notes per file, and it needs the player's sampled instruments switched on.
