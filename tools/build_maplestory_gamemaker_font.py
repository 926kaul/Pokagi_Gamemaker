"""Add Unicode format-12 cmaps required by GameMaker's font generator."""

from pathlib import Path

from fontTools.ttLib import TTFont
from fontTools.ttLib.tables._c_m_a_p import CmapSubtable


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "art/source/fonts/Maplestory/Maplestory Light.ttf"
OUTPUTS = (
    ROOT / "fonts/Font5/Maplestory GameMaker Light.ttf",
    ROOT / "fonts/Font6/Maplestory GameMaker Light.ttf",
)


def build(output: Path) -> None:
    font = TTFont(SOURCE)
    cmap = font.getBestCmap()
    existing = {(table.platformID, table.platEncID, table.format) for table in font["cmap"].tables}

    for platform_id, encoding_id in ((0, 4), (3, 10)):
        key = (platform_id, encoding_id, 12)
        if key in existing:
            continue
        table = CmapSubtable.newSubtable(12)
        table.platformID = platform_id
        table.platEncID = encoding_id
        table.language = 0
        table.cmap = dict(cmap)
        font["cmap"].tables.append(table)

    names = font["name"]
    replacements = {
        1: "Maplestory GameMaker",
        2: "Light",
        4: "Maplestory GameMaker Light",
        6: "MaplestoryGameMaker-Light",
        16: "Maplestory GameMaker",
        17: "Light",
    }
    names.names = [record for record in names.names if record.nameID not in replacements]
    for name_id, value in replacements.items():
        names.setName(value, name_id, 0, 3, 0)
        names.setName(value, name_id, 3, 1, 0x409)

    font.save(output, reorderTables=False)
    print(f"{output}: renamed family and added format-12 cmap ({len(cmap)} characters)")


if __name__ == "__main__":
    for output_path in OUTPUTS:
        build(output_path)
