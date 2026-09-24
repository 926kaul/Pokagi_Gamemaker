# Pokagi Remaster UI Direction

The remaster uses a premium retro-futuristic tabletop language. The board stays quiet enough for the original 40x40 creature sprites, while the frame communicates state through shape and colour.

## Core palette

- Ink `#09101B`: room background and modal dimming
- Panel `#121F2F`: primary surface
- Panel highlight `#1B2F41`: inset borders
- Ivory `#EBD5A6`: primary text and grid landmarks
- Muted `#8B979D`: secondary text
- Coral `#CF5B4E`: rival state and danger
- Cyan `#4AB0B8`: player state and collection
- Gold `#DEB160`: neutral focus and progress

## Layout rules

- Use a 1280x960 (4:3) logical canvas rendered at a minimum of 2560x1920.
- Preserve the 720x720 arena at `(120, 120)` through `(840, 840)` in the left play area.
- Reserve the rightmost 320 logical pixels for the persistent command rail.
- Keep the arena center free of permanent UI.
- Use the top rail for battle state and turn order.
- Use the bottom dock for stage, primary action, and volume.
- Use coral and cyan to identify sides; never rely on colour alone for essential state.
- Draw interface geometry from shared helpers in `scripts/ui_theme`.

## Generated concept prompt

> Create a polished square 1:1 game UI concept sheet for an original creature-battling tabletop strategy game. Do not render any title, words, letters, numbers, logos, Poké Balls, Pokémon, copyrighted characters, or recognizable franchise symbols. The game board is the focus: a large centered square tactical tabletop arena with a precise elegant grid, subtle circular node markers, and two opposing color zones. Surround it with a cohesive HUD: slim top status rail with abstract icon placeholders, compact turn-order tokens, and a bottom command dock. Visual direction: premium retro-futuristic arcade tabletop, clean geometric shapes, tactile layered panels, dark midnight navy and deep slate base, warm ivory grid lines, muted coral red and cool cyan accents, restrained golden highlights, very subtle paper/grain texture, strong hierarchy, generous spacing, readable silhouette at 960x960. Orthographic front-on game screenshot, no perspective distortion. Avoid glossy gradients, mobile-game clutter, photorealism, and neon cyberpunk. The center arena must remain visually quiet so small colorful 40x40 creature sprites will stand out.

The generated image is a visual target only. Runtime layout is rendered in GML so it remains aligned with gameplay coordinates and can scale independently.
