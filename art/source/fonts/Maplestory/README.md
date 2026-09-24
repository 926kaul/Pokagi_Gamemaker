# Maplestory Light

Source font supplied from the local `MaplestoryFont_TTF` download and copied
into the project for the GameMaker UI font assets `Font5` and `Font6`.

The original font file is `Maplestory Light.ttf`.

GameMaker LTS stops at the first Hangul glyph when the font only exposes its
Unicode characters through a format-4 cmap. `tools/build_maplestory_gamemaker_font.py`
keeps the outlines unchanged, adds equivalent Unicode format-12 cmap tables,
and renames the generated family to `Maplestory GameMaker` so it can coexist
with the installed original. The generated copies are stored beside `Font5`
and `Font6`.
