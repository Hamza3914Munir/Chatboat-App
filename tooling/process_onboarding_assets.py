#!/usr/bin/env python3
"""Process onboarding illustration sources: remove only edge-connected background."""

from __future__ import annotations

import sys
from collections import deque
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = ROOT / "assets" / "onboarding" / "source"
OUT_DIR = ROOT / "assets" / "onboarding"

SOURCES = [
    ("onboarding_1_source.png", "onboarding_1.png"),
    ("onboarding_2_source.png", "onboarding_2.png"),
    ("onboarding_3_source.png", "onboarding_3.png"),
    ("onboarding_4_source.png", "onboarding_4.png"),
]

TOLERANCE = 22


def _is_background(r: int, g: int, b: int, mode: str) -> bool:
    if mode == "white":
        return r >= 255 - TOLERANCE and g >= 255 - TOLERANCE and b >= 255 - TOLERANCE
    # black
    return r <= TOLERANCE and g <= TOLERANCE and b <= TOLERANCE


def _detect_mode(corners: list[tuple[int, int, int]]) -> str:
    white = sum(
        1 for r, g, b in corners if r >= 255 - TOLERANCE and g >= 255 - TOLERANCE and b >= 255 - TOLERANCE
    )
    black = sum(1 for r, g, b in corners if r <= TOLERANCE and g <= TOLERANCE and b <= TOLERANCE)
    if white >= 3:
        return "white"
    if black >= 3:
        return "black"
    return "white"


def remove_background(img: Image.Image) -> Image.Image:
    rgb = img.convert("RGB")
    w, h = rgb.size
    px = rgb.load()
    corners = [px[0, 0], px[w - 1, 0], px[0, h - 1], px[w - 1, h - 1]]
    mode = _detect_mode(corners)

    bg_mask = [[False] * w for _ in range(h)]
    q: deque[tuple[int, int]] = deque()

    def try_seed(x: int, y: int) -> None:
        r, g, b = px[x, y]
        if _is_background(r, g, b, mode) and not bg_mask[y][x]:
            bg_mask[y][x] = True
            q.append((x, y))

    for x in range(w):
        try_seed(x, 0)
        try_seed(x, h - 1)
    for y in range(h):
        try_seed(0, y)
        try_seed(w - 1, y)

    while q:
        x, y = q.popleft()
        for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
            if 0 <= nx < w and 0 <= ny < h and not bg_mask[ny][nx]:
                r, g, b = px[nx, ny]
                if _is_background(r, g, b, mode):
                    bg_mask[ny][nx] = True
                    q.append((nx, ny))

    out = Image.new("RGBA", (w, h))
    out_px = out.load()
    for y in range(h):
        for x in range(w):
            r, g, b = px[x, y]
            if bg_mask[y][x]:
                out_px[x, y] = (r, g, b, 0)
            else:
                out_px[x, y] = (r, g, b, 255)

    return out


def validate(name: str, img: Image.Image) -> None:
    w, h = img.size
    px = img.load()
    transparent = sum(1 for y in range(h) for x in range(w) if px[x, y][3] == 0)
    total = w * h
    ratio = transparent / total

    hair_h = int(h * 0.28)
    dark_hair = sum(
        1
        for y in range(hair_h)
        for x in range(w)
        if px[x, y][3] > 0 and px[x, y][0] <= 45 and px[x, y][1] <= 45 and px[x, y][2] <= 45
    )

    print(f"  {name}: transparent={ratio:.1%}, dark_pixels_in_hair_band={dark_hair}")

    if name == "onboarding_1.png" and dark_hair < 4000:
        print(f"  WARNING: expected more opaque dark hair pixels in {name}", file=sys.stderr)
    if ratio > 0.88:
        print(f"  WARNING: unusually high transparency in {name}", file=sys.stderr)


def main() -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    if not SOURCE_DIR.is_dir():
        print(f"Missing {SOURCE_DIR}", file=sys.stderr)
        return 1

    for src_name, out_name in SOURCES:
        src = SOURCE_DIR / src_name
        if not src.is_file():
            print(f"Missing source {src}", file=sys.stderr)
            return 1
        result = remove_background(Image.open(src))
        dst = OUT_DIR / out_name
        result.save(dst, "PNG")
        validate(out_name, result)
        print(f"Wrote {dst.relative_to(ROOT)}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
