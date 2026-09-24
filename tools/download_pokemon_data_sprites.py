"""Build the Gen-1 data-panel sprite from the best PokemonDB game image.

Source gallery: https://pokemondb.net/sprites
Priority: Scarlet/Violet, Brilliant Diamond/Shining Pearl, then Pokemon HOME.

The generated GameMaker sprite is intentionally separate from the battle
sprite. It is used only for the large Pokedex-style preview in the UI.
"""

from __future__ import annotations

from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import re
import shutil
import struct
import urllib.request
import urllib.error
import uuid
import zlib


ROOT = Path(__file__).resolve().parents[1]
SOURCE_SPRITE = ROOT / "sprites" / "Pokemon" / "Pokemon.yy"
OUTPUT_DIR = ROOT / "sprites" / "PokemonData"
GALLERY_URL = "https://pokemondb.net/sprites"
IMAGE_SOURCES = (
    ("scarlet-violet", "https://img.pokemondb.net/sprites/scarlet-violet/normal/{slug}.png"),
    ("brilliant-diamond-shining-pearl", "https://img.pokemondb.net/sprites/brilliant-diamond-shining-pearl/normal/{slug}.png"),
    ("home", "https://img.pokemondb.net/sprites/home/normal/{slug}.png"),
)
USER_AGENT = "Mozilla/5.0 Pokagi GameMaker asset importer"
FRAME_WIDTH = 256
FRAME_HEIGHT = 256


def request_bytes(url: str) -> bytes:
    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(request, timeout=30) as response:
        if response.status != 200:
            raise RuntimeError(f"HTTP {response.status}: {url}")
        return response.read()


def generation_one_slugs() -> list[str]:
    html = request_bytes(GALLERY_URL).decode("utf-8")
    start = html.index('<h2 id="gen1">')
    end = html.index('<h2 id="gen2">')
    slugs = re.findall(r'href="/sprites/([a-z0-9-]+)"', html[start:end])
    if len(slugs) != 151 or len(set(slugs)) != 151:
        raise RuntimeError(f"Expected 151 unique Gen-1 Pokemon; found {len(slugs)}")
    return slugs


def png_dimensions(image: bytes) -> tuple[int, int]:
    if image[:8] != b"\x89PNG\r\n\x1a\n":
        raise RuntimeError("Downloaded asset is not a PNG")
    return int.from_bytes(image[16:20], "big"), int.from_bytes(image[20:24], "big")


def png_chunk(kind: bytes, data: bytes) -> bytes:
    return struct.pack(">I", len(data)) + kind + data + struct.pack(">I", zlib.crc32(kind + data))


def pad_rgba_png(image: bytes, target_width: int, target_height: int) -> bytes:
    """Centre the visible pixels of an RGBA or palette PNG on a transparent canvas."""
    width, height = png_dimensions(image)
    bit_depth = image[24]
    colour_type = image[25]
    if bit_depth != 8 or colour_type not in (3, 6) or image[28] != 0:
        raise RuntimeError("Expected an 8-bit, non-interlaced RGBA or palette PNG")

    chunks: list[tuple[bytes, bytes]] = []
    offset = 8
    compressed = bytearray()
    while offset < len(image):
        length = struct.unpack(">I", image[offset : offset + 4])[0]
        kind = image[offset + 4 : offset + 8]
        data = image[offset + 8 : offset + 8 + length]
        chunks.append((kind, data))
        if kind == b"IDAT":
            compressed.extend(data)
        offset += 12 + length

    packed = zlib.decompress(bytes(compressed))
    source_bpp = 4 if colour_type == 6 else 1
    stride = width * source_bpp
    decoded_rows: list[bytes] = []
    previous = bytearray(stride)
    cursor = 0

    def paeth(a: int, b: int, c: int) -> int:
        estimate = a + b - c
        da, db, dc = abs(estimate - a), abs(estimate - b), abs(estimate - c)
        return a if da <= db and da <= dc else b if db <= dc else c

    for _ in range(height):
        filter_type = packed[cursor]
        filtered = packed[cursor + 1 : cursor + 1 + stride]
        cursor += stride + 1
        row = bytearray(stride)
        for index, value in enumerate(filtered):
            left = row[index - source_bpp] if index >= source_bpp else 0
            up = previous[index]
            upper_left = previous[index - source_bpp] if index >= source_bpp else 0
            if filter_type == 0:
                predictor = 0
            elif filter_type == 1:
                predictor = left
            elif filter_type == 2:
                predictor = up
            elif filter_type == 3:
                predictor = (left + up) // 2
            elif filter_type == 4:
                predictor = paeth(left, up, upper_left)
            else:
                raise RuntimeError(f"Unsupported PNG filter: {filter_type}")
            row[index] = (value + predictor) & 0xFF
        decoded_rows.append(bytes(row))
        previous = row

    if colour_type == 6:
        rows = decoded_rows
    else:
        palette_data = next((data for kind, data in chunks if kind == b"PLTE"), None)
        if palette_data is None:
            raise RuntimeError("Palette PNG is missing its PLTE chunk")
        transparency = next((data for kind, data in chunks if kind == b"tRNS"), b"")
        palette = [
            (
                palette_data[index],
                palette_data[index + 1],
                palette_data[index + 2],
                transparency[index // 3] if index // 3 < len(transparency) else 255,
            )
            for index in range(0, len(palette_data), 3)
        ]
        rows = [
            b"".join(bytes(palette[index]) for index in row)
            for row in decoded_rows
        ]

    # PokemonDB images use different transparent margins depending on the
    # source game. Centre the alpha bounds, not the nominal PNG canvas.
    visible_left = width
    visible_top = height
    visible_right = -1
    visible_bottom = -1
    for source_y, row in enumerate(rows):
        for source_x in range(width):
            if row[source_x * 4 + 3] == 0:
                continue
            visible_left = min(visible_left, source_x)
            visible_top = min(visible_top, source_y)
            visible_right = max(visible_right, source_x)
            visible_bottom = max(visible_bottom, source_y)

    if visible_right < visible_left or visible_bottom < visible_top:
        raise RuntimeError("Downloaded PNG contains no visible pixels")

    visible_width = visible_right - visible_left + 1
    visible_height = visible_bottom - visible_top + 1
    if visible_width > target_width or visible_height > target_height:
        raise RuntimeError(
            f"Cannot fit visible area {visible_width}x{visible_height} "
            f"into {target_width}x{target_height}"
        )

    target_left = (target_width - visible_width) // 2
    target_top = (target_height - visible_height) // 2
    canvas_rows = [bytearray(target_width * 4) for _ in range(target_height)]
    source_left_byte = visible_left * 4
    source_right_byte = (visible_right + 1) * 4
    target_left_byte = target_left * 4
    for content_y in range(visible_height):
        source_row = rows[visible_top + content_y]
        target_row = canvas_rows[target_top + content_y]
        target_row[target_left_byte : target_left_byte + visible_width * 4] = (
            source_row[source_left_byte:source_right_byte]
        )
    raw_canvas = b"".join(b"\x00" + bytes(row) for row in canvas_rows)

    result = bytearray(image[:8])
    wrote_pixels = False
    for kind, data in chunks:
        if kind == b"IHDR":
            updated = bytearray(data)
            updated[0:4] = struct.pack(">I", target_width)
            updated[4:8] = struct.pack(">I", target_height)
            updated[9] = 6  # Output pixels are always RGBA.
            result.extend(png_chunk(kind, bytes(updated)))
        elif kind == b"IDAT":
            if not wrote_pixels:
                result.extend(png_chunk(b"IDAT", zlib.compress(raw_canvas, 9)))
                wrote_pixels = True
        elif colour_type == 3 and kind in (b"PLTE", b"tRNS"):
            continue
        else:
            result.extend(png_chunk(kind, data))
    return bytes(result)


def checked_png(slug: str) -> tuple[str, bytes, str]:
    for source_name, pattern in IMAGE_SOURCES:
        try:
            image = request_bytes(pattern.format(slug=slug))
        except urllib.error.HTTPError as error:
            if error.code == 404:
                continue
            raise
        image = pad_rgba_png(image, FRAME_WIDTH, FRAME_HEIGHT)
        return slug, image, source_name
    raise RuntimeError(f"No preferred image source found for {slug}")


def remap_sprite_resource(frame_count: int) -> tuple[str, list[str], str]:
    source = SOURCE_SPRITE.read_text(encoding="utf-8")
    old_frames = re.findall(
        r'\{"\$GMSpriteFrame":"v1","%Name":"([0-9a-f-]{36})"', source
    )
    if len(old_frames) != frame_count:
        raise RuntimeError(f"Template has {len(old_frames)} frames, expected {frame_count}")

    old_layer_match = re.search(
        r'\{"\$GMImageLayer":"","%Name":"([0-9a-f-]{36})"', source
    )
    if old_layer_match is None:
        raise RuntimeError("Could not find template image layer")

    # Every UUID in a sprite is internal to that resource. Remapping all of
    # them preserves references while keeping the new sprite fully independent.
    unique_ids = set(re.findall(r'(?<![0-9a-f])[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12}(?![0-9a-f])', source))
    id_map = {old: str(uuid.uuid4()) for old in unique_ids}
    for old_id, new_id in id_map.items():
        source = source.replace(old_id, new_id)

    source = source.replace("sprites/Pokemon/Pokemon.yy", "sprites/PokemonData/PokemonData.yy")
    source = source.replace('"Pokemon"', '"PokemonData"')
    replacements = {
        "bbox_bottom": FRAME_HEIGHT - 1,
        "bbox_left": 0,
        "bbox_right": FRAME_WIDTH - 1,
        "bbox_top": 0,
        "height": FRAME_HEIGHT,
        "width": FRAME_WIDTH,
        "xorigin": FRAME_WIDTH // 2,
        "yorigin": FRAME_HEIGHT // 2,
    }
    for key, value in replacements.items():
        source = re.sub(rf'("{key}":)-?\d+(?:\.0)?', rf'\g<1>{value}', source)

    # Normalise the sequence to one frame per Pokedex entry.
    key_index = 0

    def normalise_key(match: re.Match[str]) -> str:
        nonlocal key_index
        result = f'"Key":{key_index}.0,"Length":1.0'
        key_index += 1
        return result

    source = re.sub(r'"Key":\d+\.0,"Length":\d+\.0', normalise_key, source)
    source = re.sub(r'"length":\d+\.0', f'"length":{frame_count}.0', source, count=1)
    if key_index != frame_count:
        raise RuntimeError(f"Normalised {key_index} keys, expected {frame_count}")

    new_frames = [id_map[old_frame] for old_frame in old_frames]
    new_layer = id_map[old_layer_match.group(1)]
    return source, new_frames, new_layer


def existing_sprite_resource(frame_count: int) -> tuple[str, list[str], str]:
    resource_path = OUTPUT_DIR / "PokemonData.yy"
    source = resource_path.read_text(encoding="utf-8")
    frames = re.findall(
        r'\{"\$GMSpriteFrame":"v1","%Name":"([0-9a-f-]{36})"', source
    )
    layer_match = re.search(
        r'\{"\$GMImageLayer":"","%Name":"([0-9a-f-]{36})"', source
    )
    if len(frames) != frame_count or layer_match is None:
        raise RuntimeError("Existing PokemonData resource has an unexpected structure")

    replacements = {
        "bbox_bottom": FRAME_HEIGHT - 1,
        "bbox_left": 0,
        "bbox_right": FRAME_WIDTH - 1,
        "bbox_top": 0,
        "height": FRAME_HEIGHT,
        "width": FRAME_WIDTH,
        "xorigin": FRAME_WIDTH // 2,
        "yorigin": FRAME_HEIGHT // 2,
    }
    for key, value in replacements.items():
        source = re.sub(rf'("{key}":)-?\d+(?:\.0)?', rf'\g<1>{value}', source)
    return source, frames, layer_match.group(1)


def main() -> None:
    slugs = generation_one_slugs()
    with ThreadPoolExecutor(max_workers=8) as pool:
        downloaded = list(pool.map(checked_png, slugs))
    images = {slug: image for slug, image, _ in downloaded}
    selected_sources = {slug: source for slug, _, source in downloaded}

    if OUTPUT_DIR.exists():
        resource, frame_ids, layer_id = existing_sprite_resource(len(slugs))
    else:
        resource, frame_ids, layer_id = remap_sprite_resource(len(slugs))
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    (OUTPUT_DIR / "PokemonData.yy").write_text(resource, encoding="utf-8")

    for slug, frame_id in zip(slugs, frame_ids):
        root_image = OUTPUT_DIR / f"{frame_id}.png"
        root_image.write_bytes(images[slug])
        layer_dir = OUTPUT_DIR / "layers" / frame_id
        layer_dir.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(root_image, layer_dir / f"{layer_id}.png")

    manifest = ["pokedex\tslug\tsource"]
    for pokedex, slug in enumerate(slugs, start=1):
        manifest.append(f"{pokedex:03d}\t{slug}\t{selected_sources[slug]}")
    (ROOT / "tools" / "pokemon_data_sources.tsv").write_text(
        "\n".join(manifest) + "\n", encoding="utf-8"
    )

    source_counts = {
        name: sum(source == name for source in selected_sources.values())
        for name, _ in IMAGE_SOURCES
    }

    print(
        f"Created PokemonData with {len(slugs)} "
        f"{FRAME_WIDTH}x{FRAME_HEIGHT} priority-selected frames: {source_counts}."
    )


if __name__ == "__main__":
    main()
