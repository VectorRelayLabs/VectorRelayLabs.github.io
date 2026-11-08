#!/usr/bin/env bash
# Rebuilds the modding pages from the game repo's docs (the mods branch).
#   tools/build-docs.sh [path-to-game-repo-worktree]
# Source of truth: docs/LUA_API.md, docs/MUSIC_GUIDE.md and docs/examples/courier-ledger-lua/mod.lua.
set -e
GAME="${1:-/l/UNITY/StarCourier-mods}"
OUT="$(cd "$(dirname "$0")/.." && pwd)/starcourier/modding"
API="$GAME/docs/LUA_API.md"

# sect "<heading line>": that section, up to the next heading of the same or higher level.
sect() { awk -v h="$1" '
  function lvl(s) { match(s, /^#+/); return RLENGTH }
  $0 == h { on = 1; L = lvl($0); print; next }
  on && /^#+ / && lvl($0) <= L { on = 0 }
  on { print }' "$API"; }
# promote: ### to ##, #### to ###.
promote() { sed 's/^### /## /; s/^#### /### /'; }
# page <file> <title> <section-key> <group>   (body on stdin)
page() { { printf -- '---\nlayout: doc\ntitle: "%s"\nsection: %s\ngroup: %s\npreview: true\n---\n\n' "$2" "$3" "$4"; cat; } > "$OUT/$1"; }

mkdir -p "$OUT/api"

# --- API pages ---
{ echo "A mod is a folder with a \`mod.lua\` (and optionally \`preview.png\`, audio files and \`.mid\` MIDI files). Lua is the only mod format."
  echo "\`mod.lua\` runs once when the mod loads, then your event handlers run when things happen."
  echo; echo "This is a **preview**: none of it is in the game yet. It describes what a Lua mod will look like, so the shape can be discussed before it is built. The [example mod](../example-mod.html) uses it end to end."
  echo; sect "## What mods can add"; } | page api/index.md "Lua API: overview" api-index api

{ sect "## Rules of the sandbox" | sed 's/^## /## /'; echo; sect "## Manifest"; } | page api/basics.md "Sandbox and manifest" api-basics api
sect "## Data registries" >/dev/null
{ sect '### `music.add{...}`: writing a track' | promote; echo; sect '### `music.midi{...}`: MIDI files' | promote; } | page api/music.md "Music" api-music api
{ sect '### `text.clients(name, ...)` and `text.cargo(kind, line, ...)`' | promote; echo; sect '#### Replacing text and names' | promote | promote; } | page api/text.md "Text and names" api-text api
sect '### `missions.add{...}`: missions' | promote | page api/missions.md "Missions" api-missions api
{ sect '### `events.add{...}`: events and things to do' | promote; echo; sect '### `ui.dialog{...}`' | promote; } | page api/events.md "Events and dialogs" api-events api
sect '### `tweaks.set(key, value)`: changing the game' | sed '/^#### Replacing text and names/,$d' | promote | page api/tweaks.md "Tweaks" api-tweaks api
sect "## Events" | page api/hooks.md "Game events" api-hooks api
{ sect "## Reading state"; echo; sect "## Actions"; echo; sect "## Saved data"; } | page api/state.md "State, actions and saving" api-state api
sect "## Helpers" | page api/helpers.md "Helpers" api-helpers api
sect "## UI" | page api/ui.md "Windows, HUD and keys" api-ui api
{ sect "## Co-op"; echo; sect "## Versioning"; echo; sect "## Limits at a glance"; } | page api/reference.md "Co-op, versions and limits" api-reference api

# --- music guide (a guide, not preview) ---
{ printf -- '---\nlayout: doc\ntitle: "Writing music for Star Courier"\nsection: music-guide\ngroup: guides\n---\n\n'
  sed '1d' "$GAME/docs/MUSIC_GUIDE.md" | sed 's#`docs/LUA_API.md`#the [Lua API](api/)#g'; } > "$OUT/music-guide.md"

# --- example mod ---
{ printf -- '---\nlayout: doc\ntitle: "Example mod: Courier Ledger"\nsection: example\ngroup: guides\npreview: true\n---\n\n'
  printf 'A sample `mod.lua` showing the shape of the API: music, text, a window, a HUD readout, events, a mission and an event. It is a design draft: nothing loads it yet.\n\n```lua\n'
  cat "$GAME/docs/examples/courier-ledger-lua/mod.lua"; printf '```\n'; } > "$OUT/example-mod.md"
echo "built from $GAME"
