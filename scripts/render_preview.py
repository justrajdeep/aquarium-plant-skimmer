# SPDX-License-Identifier: GPL-3.0-only
# See LICENSES/GPL-3.0-only.txt for this utility's licence.
# Copyright (C) 2026 aquarium-skimmer contributors
"""Draw the exported ASCII STL with Pillow, without requiring OpenGL.

Usage: python3 scripts/render_preview.py
Dependency: Pillow. This produces a model illustration, not a print photograph.
"""

from pathlib import Path
from math import sqrt
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent


def dot(a, b):
    return sum(x * y for x, y in zip(a, b))


def normalize(v):
    length = sqrt(dot(v, v))
    return tuple(x / length for x in v)


def read_triangles(path):
    triangles = []
    for line in path.read_text().splitlines():
        parts = line.split()
        if parts[:2] == ["facet", "normal"]:
            normal = tuple(map(float, parts[2:]))
            vertices = []
        elif parts[:1] == ["vertex"]:
            vertices.append(tuple(map(float, parts[1:])))
        elif parts[:1] == ["endfacet"]:
            triangles.append((normal, vertices))
    return triangles


def main():
    triangles = read_triangles(ROOT / "aquarium_skimmer.stl")
    vertices = [v for _, tri in triangles for v in tri]
    bounds = [(min(v[i] for v in vertices), max(v[i] for v in vertices))
              for i in range(3)]
    print("STL dimensions (mm):", [round(b-a, 3) for a, b in bounds])

    # An orthonormal camera basis gives an oblique view of both fan heads.
    right = normalize((1, -0.28, 0))
    camera = normalize((0.28, 1, 2.4))
    up = (camera[1]*right[2] - camera[2]*right[1],
          camera[2]*right[0] - camera[0]*right[2],
          camera[0]*right[1] - camera[1]*right[0])
    projected = [(dot(v, right), dot(v, up)) for v in vertices]
    xmin, xmax = min(p[0] for p in projected), max(p[0] for p in projected)
    ymin, ymax = min(p[1] for p in projected), max(p[1] for p in projected)
    width, height, supersample = 1600, 950, 3
    scale = min((width - 160) / (xmax-xmin), (height - 250) / (ymax-ymin))

    def screen(v):
        return ((width/2 + (dot(v, right) - (xmin+xmax)/2)*scale)*supersample,
                (height/2 + 15 - (dot(v, up) - (ymin+ymax)/2)*scale)*supersample)

    image = Image.new("RGB", (width*supersample, height*supersample), "#f4f7fa")
    draw = ImageDraw.Draw(image)
    light = normalize((-0.3, -0.5, 1))
    for normal, tri in sorted(triangles, key=lambda t: sum(dot(v, camera) for v in t[1])):
        if dot(normal, camera) <= 0:
            continue
        brightness = 0.48 + 0.52 * max(0, dot(normal, light))
        color = tuple(round(channel*brightness) for channel in (48, 170, 157))
        draw.polygon([screen(v) for v in tri], fill=color)
    image = image.resize((width, height), Image.Resampling.LANCZOS)
    draw = ImageDraw.Draw(image)
    draw.text((50, 35), "DUAL-ENDED AQUARIUM PLANT SKIMMER", fill="#173747", font_size=30)
    draw.text((50, height-65), "MODEL PREVIEW  |  NOT A PRINT PHOTO  |  DIMENSIONS IN MM", fill="#526879", font_size=20)
    image.save(ROOT / "aquarium_skimmer.png")


if __name__ == "__main__":
    main()
