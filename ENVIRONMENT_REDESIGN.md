# Environment Redesign Brief

This Godot migration treats Harrow Library itself as the central character. The current generated geometry is a production scaffold: it establishes room identity, collisions, landmarks, lighting hooks, and prop density before final pixel-art tiles are imported.

## Floor 1: Student Hub

- Entry Hall: reception counter, digital directory, university emblem, trophy display, plants, warm lamps.
- Coding Lab: workstation rows, live dashboard, algorithm whiteboard, debugging stations, monitor glow.
- Archive Wing: dense shelves, secured terminal, locked staff door, purple lighting language.
- Quiet Study and Reading Hall: softer wood tones, lamps, tables, carrels, books, rest points.

## Floor 2: Software Engineering & AI

- Software Engineering Lab: sprint board, clustered development stations, project artifacts.
- AI Research Lab: neural display, GPU cluster, research workstations, purple/cyan lighting.
- Study Lounge: sofas, coffee table, warm reading corners.
- Presentation Bay: projector screen, audience seating, final puzzle terminal.
- Sealed Server Annex: SYSTEM_7 terminal and restricted visual language.

## Floor 3: Classified Research Facility

- Abandoned Lab: dead terminals, redacted whiteboards, scattered research desks.
- SYSTEM_7 Core: central pulsing terminal and high-contrast magenta-purple lighting.
- Restricted Archive: dense shelves and hidden-truth staging.
- Kai's Workstation: personal desk, KAI_ECHO terminal, final narrative focus.

## Implementation Notes

- `scripts/world/EnvironmentCatalog.gd` defines room rects, room palettes, prop dressing, and ambient FX.
- `scripts/world/FloorBase.gd` converts that catalog into placeholder pixel-style geometry and collision.
- Final production should replace generated blocks with `TileMapLayer` painting and sprite assets while keeping catalog IDs as placement references.
- Shaders in `assets/shaders/` cover CRT, glow, and glitch effects.
- UI uses Godot `Control` nodes and `assets/themes/pixel_library_theme.tres`.
