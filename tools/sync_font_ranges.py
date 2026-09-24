"""Sync GameMaker font ranges to characters used by GML and supported by TTF."""

from __future__ import annotations

import json
import re
from pathlib import Path

from fontTools.ttLib import TTFont


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


def main() -> None:
    requested = used_codepoints()
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
        resource_path.write_text(
            json.dumps(resource, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
        )

    unsupported = sorted(requested - supported)
    print(f"Selected {len(selected)} characters in {len(ranges)} exact ranges")
    print("Skipped unsupported codepoints: " + ", ".join(f"U+{p:04X}" for p in unsupported))


if __name__ == "__main__":
    main()
