---
layout: doc
title: "Co-op, versions and limits"
section: api-reference
group: api
preview: true
---

## Co-op

- Music and text from a mod are cosmetic and don't need to match between players.
- A mod with event handlers, `contracts.offer` or a window that reads economy state is gameplay: every player
  must have the same mod and version, and a joining player is asked first (nothing installs unprompted).
- `contracts.offer`, missions and events run on the host only; on a client they are ignored. Everyone in the session sees the same missions and events, and a crew member sharing a ship shares its active mission.


## Versioning

`api` is a whole number. Additions keep the number; a breaking change bumps it, and the game keeps loading older
mods for at least one version back. The Mods menu shows each mod's `api`.


## Limits at a glance

| Thing | Limit |
|---|---|
| Instructions per call | about 100,000 |
| Music tracks per mod | 64 |
| Missions per mod | 16, each with 1 to 8 steps |
| Events per mod | 32, each with 1 to 4 choices; 3 active in a sector at once |
| Text lines per mod | 500, each at most 60 characters |
| HUD widgets per mod | 3 |
| `store` size | 64 KB |
| Files in a mod | `.lua`, `.png`, `.mid`, `.ogg`, `.wav`, `.mp3`; each under 256 KB except audio (up to 40 MB) and MIDI (1 MB) |
| MIDI files per mod | 24, up to 100,000 notes each |
