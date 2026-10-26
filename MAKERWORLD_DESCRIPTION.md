# Dual-Ended Aquarium Plant Skimmer — Parametric OpenSCAD

A double-ended skimmer intended to collect floating aquarium plants, with a wide fan and a half-width fan facing opposite directions.

## Features

- Large fan reconstructed from ruler photographs of an existing printed tool.
- Four rows of sixteen slots on the large fan, extending almost to the handle.
- Approximately 20 mm brace pitch on the large fan, with equal clear row lengths.
- Mirrored construction at the opposite end with a 45 mm front edge, half the large fan width and three-quarters of its depth, with four rows of eight slots.
- Raised lips merged flush with the side and front edges and extending to the start of the slots; no rear lip across either handle junction.
- Both fan bases match the 25 mm handle width.
- Oval hanging hole in the handle at the opposite fan junction.
- Commented, editable OpenSCAD source for learning and customization.

## Dimensions

- Overall: approximately 256.9 × 90 × 6.4 mm.
- Large fan: 90 mm front width, 25 mm neck width, 90 mm sloping outer sides, approximately 83.93 mm depth.
- Large fan rows: approximately 19.58 mm clear length along the fan, 20.38 mm brace pitch.
- Large fan ribs / braces: estimated 0.8 mm; perimeter: estimated 1.6 mm.
- Opposite fan: 45 mm front width, 25 mm neck width, approximately 62.95 mm depth; four rows of eight slots with approximately 14.34 mm clear row length, and the same material widths and lip heights.
- Handle: 110 mm between fan junctions, 25 mm wide.
- Base thickness: 2.43 mm; total height at lip: 6.40 mm; lip rise above base: 3.97 mm (user-confirmed caliper measurements).
- Hanging hole: 18 × 10 mm.

The ruler photographs establish approximate in-plane dimensions. The user confirmed the base thickness and total height from caliper photographs. Rib and perimeter widths in the XY plane remain design estimates. The model is not an exact dimensional copy of the reference.

## Source and files

Source: https://github.com/justrajdeep/aquarium-plant-skimmer

- `aquarium_skimmer.stl`: default printable geometry.
- `aquarium_skimmer.scad`: editable source.
- `README.md`: beginner workflow.
- `DIMENSIONS.md`: measurement interpretation and estimates.

## Printing and status

Compiled in OpenSCAD 2021.01. This version has not been test-printed or tested in an aquarium. The preview is a model illustration, not a photograph of a validation print.

Place the flat underside on the bed with the lips facing up. The geometry is intended to need no supports. Check build-area fit and inspect sliced ribs and narrow neck slots before printing. No tested Bambu Studio print profile is included.

## Customization and license

Edit parameters in OpenSCAD, preview with F5, render with F6, and export a new STL. Feedback and test-print results are welcome.

Developed with AI assistance from visual references and iterative user feedback. Licensed under GNU GPL version 3 only (`GPL-3.0-only`); source and license are included. Retain the license and provide source when redistributing modified versions under these terms.
