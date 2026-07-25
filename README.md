# Harrow Library

**An AI mystery adventure set in a university library.**

Explore three floors of Harrow Library, talk to students and researchers, recover scattered digital fragments, and uncover the truth behind **SYSTEM_7** — a classified AI project that may still be awake.

Built with **Godot 4.3** and **GDScript**.

---

## About

You arrive at Harrow Library on your first day. What starts as a simple orientation quickly turns into an investigation: missing files, nervous staff, hidden memos, and references to a sealed third floor. Piece together clues from code snippets, USB dumps, and notes left behind by someone named Kai.

The game blends **exploration**, **dialogue**, **collection**, and **light coding puzzles** across a multi-floor library world.

---

## Development status

> **Godot migration scaffold with generated visual architecture.**

| Area | Status |
|------|--------|
| Game logic & state | ✅ Implemented |
| HUD, pause, files UI | ✅ Implemented |
| Floor layout (data) | ✅ Defined |
| Generated room architecture | ✅ Implemented |
| Prop collision scaffold | ✅ Implemented |
| NPCs & fragments | ✅ Spawned by code |
| Visual shaders | ✅ Added |
| Tilemaps & sprites | ⚠️ Asset production pending |
| Dialogue (Dialogic 2) | ⚠️ Optional plugin, not bundled |

When you run the Godot project today, the floors build a readable placeholder version of the redesigned library from `scripts/world/EnvironmentCatalog.gd`: room blocks, color palettes, large props, collision bodies, labels, board markings, book spines, and lighting hooks. This is the production scaffold for the final hand-drawn pixel-art tilesets.

For a **playable visual prototype**, open `harrow-library-game_16.html` in a web browser. That file is a self-contained browser version of the game concept with full pixel-art presentation.

---

## Features

- **Three explorable floors**
  - Floor 1 — Student Hub
  - Floor 2 — Software Engineering & AI
  - Floor 3 — Classified Research Facility *(unlocked through progression)*
- **14 NPCs** with roles, schedules, and dialogue hooks
- **12 collectible fragments** (code files, notes, USB data) with secret entries
- **Living clock** — in-game time advances and drives NPC schedules
- **Progression systems** — code level, focus/wellbeing, objectives, floor unlocks
- **Save / load** — persisted to `user://harrow_library.cfg`
- **Puzzle framework** — extensible validators for coding challenges

---

## Requirements

- [Godot Engine 4.3](https://godotengine.org/download) (4.3.x recommended; project targets 4.3)
- macOS, Windows, or Linux

---

## Getting started

### Run in Godot (recommended for development)

1. Download and install **Godot 4.3**.
2. Open Godot → **Import** → select `project.godot` in this folder.
3. Click **Import & Edit**.
4. Press **F5** (or the ▶ Play button) to run the game.

The main scene is `scenes/Main.tscn`.

### Run the HTML prototype

Double-click `harrow-library-game_16.html` or open it in any modern browser. No install required.

---

## Controls

| Action | Keys |
|--------|------|
| Move | `W` `A` `S` `D` or arrow keys |
| Interact | `E` or `Space` |
| Files panel | `Tab` |
| Pause | `Esc` |

---

## Story & progression (spoiler-free)

- Start on **Floor 1** with three orientation objectives.
- Collect **fragments** scattered across floors to learn about SYSTEM_7 and Kai.
- Raise your **code level** by solving puzzles and engaging with the coding lab.
- Meet key NPCs — including a hidden figure on Floor 2 — to unlock **Floor 3**.
- Floor 3 unlock requires: **10+ fragments**, **code level 3+**, and meeting the **ghost** NPC.

---

## Project structure

```
Harrow Library/
├── autoloads/          # Global singletons (GameState, GameClock, SaveSystem, …)
├── assets/           # Art & audio (folders exist; assets pending)
│   ├── sprites/
│   ├── tilesets/
│   ├── audio/
│   ├── themes/
│   └── shaders/
├── dialogue/         # Dialogue timelines (Dialogic 2, when added)
├── scenes/
│   ├── Main.tscn     # Entry point
│   ├── characters/   # Player, NPCs
│   ├── objects/      # Fragments, doors, terminals, bookshelves
│   ├── ui/           # HUD, pause menu, files panel, puzzles
│   └── world/        # Floor1, Floor2, Floor3
├── scripts/          # GDScript for all gameplay systems
├── project.godot     # Godot project config
└── harrow-library-game_16.html   # Browser prototype
```

### Autoloads

| Singleton | Role |
|-----------|------|
| `GameState` | Run state, fragments, NPCs, objectives, progression |
| `GameClock` | In-game time and schedule lookups |
| `SceneManager` | Floor transitions and world loading |
| `SaveSystem` | Save / load to disk |
| `AudioManager` | Audio bus management |

### Visual Architecture

| File | Role |
|------|------|
| `scripts/world/EnvironmentCatalog.gd` | Room identity, palette, prop dressing, ambient FX per floor |
| `scripts/world/FloorBase.gd` | Converts environment catalog into generated placeholder architecture and collision |
| `ENVIRONMENT_REDESIGN.md` | Room-by-room art direction and implementation notes |
| `assets/tilesets/ART_DIRECTION.md` | Tile production guide based on the reference images |
| `assets/sprites/SPRITE_PLAN.md` | Character/object sprite production plan |
| `assets/shaders/*.gdshader` | CRT, glow, and SYSTEM_7 glitch effects |

---

## Optional: Dialogic 2

Dialogue is wired through `scripts/dialogue/DialogicBridge.gd` and expects the [Dialogic 2](https://github.com/dialogic-godot/dialogic) plugin. It is **not included** in this repository. Without it, dialogue requests log warnings and fall back to console output — the rest of the game still runs.

Install via **Project → Asset Library** in Godot, then add timelines under `dialogue/`.

---

## Exporting

A macOS export preset is configured in `export_presets.cfg` (`edu.harrow.library`, v0.1.0). Set an export path in Godot under **Project → Export** before building.

---

## Roadmap

- [ ] Replace generated block props with final pixel-art sprites
- [ ] Paint `TileMapLayer`s using `floor1_tiles.png`, `floor2_tiles.png`, and `floor3_tiles.png`
- [ ] Add player and NPC sprite sheets
- [ ] Install Dialogic 2 and import/expand `.dtl` timelines
- [ ] Port procedural HTML audio fully into `AudioStreamGenerator`
- [ ] Add ambient animations for monitors, server LEDs, plants, dust, and Floor 3 glitches

---

## Contributing

This is an active work-in-progress. Issues and pull requests are welcome on [GitHub](https://github.com/Cryddd/Harrow-Library).

---

## License

License not yet specified. All rights reserved by default until a `LICENSE` file is added.
