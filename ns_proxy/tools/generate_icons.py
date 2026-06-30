#!/usr/bin/env python3
"""Generate NS Proxy app icons from the brand logo geometry."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "assets" / "images"

GREEN_TOP = (74, 222, 128)
GREEN_MID = (34, 197, 94)
GREEN_BOTTOM = (4, 120, 87)
BLACK = (0, 0, 0)

# SVG viewBox 0 0 200 200
N_PATH = [(24, 164), (24, 36), (104, 144), (104, 36), (144, 36), (144, 164), (64, 56), (64, 164)]
S_PATH = [
    (116, 44),
    (176, 44),
    (176, 76),
    (136, 76),
    (136, 92),
    (176, 92),
    (176, 164),
    (116, 164),
    (116, 132),
    (156, 132),
    (156, 116),
    (116, 116),
]


def _lerp(a: int, b: int, t: float) -> int:
    return int(a + (b - a) * t)


def gradient_color(y: float, height: float) -> tuple[int, int, int]:
    t = max(0.0, min(1.0, y / height))
    if t < 0.5:
        tt = t / 0.5
        return (
            _lerp(GREEN_TOP[0], GREEN_MID[0], tt),
            _lerp(GREEN_TOP[1], GREEN_MID[1], tt),
            _lerp(GREEN_TOP[2], GREEN_MID[2], tt),
        )
    tt = (t - 0.5) / 0.5
    return (
        _lerp(GREEN_MID[0], GREEN_BOTTOM[0], tt),
        _lerp(GREEN_MID[1], GREEN_BOTTOM[1], tt),
        _lerp(GREEN_MID[2], GREEN_BOTTOM[2], tt),
    )


def draw_logo(size: int, padding: float = 0.12) -> Image.Image:
    image = Image.new("RGBA", (size, size), BLACK + (255,))
    draw = ImageDraw.Draw(image)

    scale = size * (1 - padding * 2) / 200
    offset = size * padding

    def transform(points: list[tuple[int, int]]) -> list[tuple[float, float]]:
        return [(offset + x * scale, offset + y * scale) for x, y in points]

    for path in (N_PATH, S_PATH):
        transformed = transform(path)
        ys = [p[1] for p in transformed]
        avg_y = sum(ys) / len(ys)
        color = gradient_color(avg_y, size)
        draw.polygon(transformed, fill=color + (255,))

    return image


def save_master_icons() -> None:
    ASSETS.mkdir(parents=True, exist_ok=True)
    master = draw_logo(1024, padding=0.1)
    master.save(ASSETS / "app_icon.png")

    foreground = draw_logo(1024, padding=0.18)
    transparent = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
    transparent.paste(foreground, (0, 0), foreground)
    transparent.save(ASSETS / "app_icon_foreground.png")

    Image.new("RGBA", (1024, 1024), BLACK + (255,)).save(ASSETS / "app_icon_background.png")
    print(f"Generated icons in {ASSETS}")


if __name__ == "__main__":
    save_master_icons()
