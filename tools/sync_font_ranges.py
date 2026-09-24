"""Sync GameMaker font ranges to characters used by GML and supported by TTF."""

from __future__ import annotations

import json
import re
from pathlib import Path

try:
    from fontTools.ttLib import TTFont
except ModuleNotFoundError:
    TTFont = None


ROOT = Path(__file__).resolve().parents[1]
FONT_JOBS = (
    (ROOT / "fonts/Font5/Font5.yy", ROOT / "fonts/Font5/Maplestory GameMaker Light.ttf"),
    (ROOT / "fonts/Font6/Font6.yy", ROOT / "fonts/Font6/Maplestory GameMaker Light.ttf"),
)


def used_codepoints() -> set[int]:
    points = set(range(32, 128))
    for path in ROOT.rglob("*.gml"):
        for char in path.read_text(encoding="utf-8").replace("\ufeff", ""):
            codepoint = ord(char)
            # Maplestory Light advertises a few symbols that GameMaker cannot
            # rasterise and then aborts all subsequent (Korean) ranges. Keep
            # only visible UI punctuation plus Hangul syllables.
            if codepoint == 183 or 0xAC00 <= codepoint <= 0xD7A3:
                points.add(codepoint)
    return points


def exact_ranges(points: list[int]) -> list[dict[str, int]]:
    ranges: list[dict[str, int]] = []
    start = end = points[0]
    for point in points[1:]:
        if point == end + 1:
            end = point
        else:
            ranges.append({"lower": start, "upper": end})
            start = end = point
    ranges.append({"lower": start, "upper": end})
    return ranges


def load_yy(path: Path) -> dict:
    raw = path.read_text(encoding="utf-8")
    return json.loads(re.sub(r",(?=\s*[}\]])", "", raw))


def compact_object(value: dict) -> str:
    body = ",".join(
        f"{json.dumps(key, ensure_ascii=False)}:{json.dumps(item, ensure_ascii=False, separators=(',', ':'))}"
        for key, item in value.items()
    )
    return "{" + body + ",}"


def dump_yy(resource: dict) -> str:
    """Write GameMaker's compact .yy style without reformatting every glyph."""
    lines = ["{"]
    for key, value in resource.items():
        prefix = f"  {json.dumps(key, ensure_ascii=False)}:"
        if key == "glyphs":
            lines.append(prefix + "{")
            for glyph_key, glyph in value.items():
                lines.append(f"    {json.dumps(glyph_key)}:{compact_object(glyph)},")
            lines.append("  },")
        elif key == "ranges" or (isinstance(value, list) and value and all(isinstance(item, dict) for item in value)):
            lines.append(prefix + "[")
            for item in value:
                lines.append(f"    {compact_object(item)},")
            lines.append("  ],")
        elif isinstance(value, dict):
            lines.append(prefix + "{")
            for child_key, child_value in value.items():
                child = json.dumps(child_value, ensure_ascii=False, separators=(",", ":"))
                lines.append(f"    {json.dumps(child_key, ensure_ascii=False)}:{child},")
            lines.append("  },")
        else:
            encoded = json.dumps(value, ensure_ascii=False, separators=(",", ":"))
            lines.append(prefix + encoded + ",")
    lines.append("}")
    return "\n".join(lines) + "\n"


def main() -> None:
    requested = used_codepoints()
    if TTFont is None:
        # Maplestory Light contains the complete modern Hangul syllable block.
        # The requested set is already restricted to ASCII, middle dot and
        # Hangul, so the sync remains safe in a bare Python installation.
        supported = requested
        print("fontTools unavailable; using the font's complete Hangul coverage")
    else:
        supported_sets = [set(TTFont(ttf).getBestCmap()) for _, ttf in FONT_JOBS]
        supported = set.intersection(*supported_sets)
    # Do not force GameMaker's U+25AF missing-glyph marker. Some fonts do not
    # provide it, and GameMaker stops generating all later ranges at that point.
    selected = sorted(requested & supported)
    ranges = exact_ranges(selected)

    for resource_path, _ in FONT_JOBS:
        resource = load_yy(resource_path)
        resource["ranges"] = ranges
        resource["regenerateBitmap"] = True
        resource_path.write_text(dump_yy(resource), encoding="utf-8")

    unsupported = sorted(requested - supported)
    print(f"Selected {len(selected)} characters in {len(ranges)} exact ranges")
    print("Skipped unsupported codepoints: " + ", ".join(f"U+{p:04X}" for p in unsupported))


if __name__ == "__main__":
    main()
