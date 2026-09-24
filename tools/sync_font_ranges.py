"""Keep the GameMaker UI fonts safe for arbitrary modern Korean text.

Historically this script generated ranges from only the Hangul syllables that
were already present in GML.  That made the bitmap small, but every new line of
Korean UI copy could introduce a syllable that was not in the last generated
bitmap.  Both UI fonts now permanently include the complete modern Hangul
syllable block, so editing copy no longer requires updating per-character
ranges.
"""

from __future__ import annotations

import json
import re
import sys
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

ASCII = set(range(32, 127))
MIDDLE_DOT = {0x00B7}
MODERN_HANGUL = set(range(0xAC00, 0xD7A4))
PERMANENT_CODEPOINTS = ASCII | MIDDLE_DOT | MODERN_HANGUL


def used_ui_codepoints() -> set[int]:
    """Return UI-safe characters currently present anywhere in GML."""
    points = set(ASCII)
    for path in ROOT.rglob("*.gml"):
        for char in path.read_text(encoding="utf-8").replace("\ufeff", ""):
            codepoint = ord(char)
            # Maplestory Light advertises a few symbols that GameMaker cannot
            # rasterise and then aborts all subsequent (Korean) ranges. Keep
            # only visible UI punctuation plus Hangul syllables.
            if codepoint == 183 or 0xAC00 <= codepoint <= 0xD7A3:
                points.add(codepoint)
    return points


def covered_codepoints(ranges: list[dict[str, int]]) -> set[int]:
    points: set[int] = set()
    for item in ranges:
        points.update(range(item["lower"], item["upper"] + 1))
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


def supported_codepoints(requested: set[int]) -> set[int]:
    if TTFont is None:
        # Maplestory Light contains the complete modern Hangul syllable block.
        # The requested set is restricted to ASCII, middle dot and Hangul, so
        # the sync remains safe in a bare Python installation.
        print("fontTools unavailable; using the font's complete Hangul coverage")
        return requested
    supported_sets = [set(TTFont(ttf).getBestCmap()) for _, ttf in FONT_JOBS]
    return set.intersection(*supported_sets)


def check() -> None:
    """Fail when source text is outside a font range or finished bitmap."""
    used = used_ui_codepoints()
    failures: list[str] = []
    for resource_path, _ in FONT_JOBS:
        resource = load_yy(resource_path)
        missing_range = sorted(used - covered_codepoints(resource["ranges"]))
        if missing_range:
            failures.append(
                f"{resource_path.name}: range missing "
                + ", ".join(f"U+{point:04X}" for point in missing_range)
            )

        # While regenerateBitmap is true, the checked-in glyph table is
        # intentionally stale. GameMaker refreshes it on the next font build.
        if not resource.get("regenerateBitmap", False):
            glyphs = {int(point) for point in resource.get("glyphs", {})}
            missing_bitmap = sorted(used - glyphs)
            if missing_bitmap:
                failures.append(
                    f"{resource_path.name}: bitmap missing "
                    + ", ".join(f"U+{point:04X}" for point in missing_bitmap)
                )

    if failures:
        raise SystemExit("\n".join(failures))
    print("Font coverage check passed for all Korean text currently in GML")


def sync() -> None:
    requested = PERMANENT_CODEPOINTS | used_ui_codepoints()
    supported = supported_codepoints(requested)
    # Do not force GameMaker's U+25AF missing-glyph marker. Some fonts do not
    # provide it, and GameMaker stops generating all later ranges at that point.
    selected = sorted(requested & supported)
    ranges = exact_ranges(selected)

    for resource_path, _ in FONT_JOBS:
        resource = load_yy(resource_path)
        if resource.get("ranges") != ranges:
            resource["ranges"] = ranges
            resource["regenerateBitmap"] = True
            resource_path.write_text(dump_yy(resource), encoding="utf-8")
            print(f"Updated {resource_path.name}; GameMaker bitmap regeneration required")
        else:
            print(f"{resource_path.name}: ranges already current")

    unsupported = sorted(requested - supported)
    print(f"Selected {len(selected)} characters in {len(ranges)} permanent ranges")
    print("Skipped unsupported codepoints: " + ", ".join(f"U+{p:04X}" for p in unsupported))


if __name__ == "__main__":
    if "--check" in sys.argv[1:]:
        check()
    else:
        sync()
