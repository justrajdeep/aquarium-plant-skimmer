# Dual-Ended Aquarium Plant Skimmer — Parametric OpenSCAD

A double-ended skimmer designed to collect floating aquarium plants. The wide fan covers open areas, while the narrower fan is intended for reaching between plants and into confined spaces.

## Features

- Wide fan and narrow fan on opposite ends of one handle.
- Raised lips merged flush with both fans' perimeter edges.
- Solid fan bases replace the smallest slots near the handle.
- Both fan bases match the handle width.
- Oval hanging hole in the handle, starting at the narrow fan base.
- Editable OpenSCAD source with comments for learning and customization.

## Default dimensions

- Overall: approximately 288.2 × 133.2 × 5.2 mm.
- Handle width: 28 mm.
- Wide fan length: 105 mm; outer width: 133.2 mm.
- Narrow fan length: 70 mm; outer width: 43.2 mm.
- Base thickness: 3.2 mm; raised lips: an additional 2 mm.
- Hanging hole: 18 × 10 mm.

## Source code

https://github.com/justrajdeep/aquarium-plant-skimmer

## Files

- `aquarium_skimmer.stl`: default printable geometry.
- `aquarium_skimmer.scad`: editable, parameterized source.
- `README.md`: beginner guide and parameter explanations.

## Printing and status

This design has compiled and exported successfully in OpenSCAD 2021.01. It has not yet been test-printed or tested in an aquarium. The preview image is a model illustration, not a photograph of a physical print.

Place the flat underside on the build plate with the raised lips facing up. The geometry is intended to print without supports. Check the model's size against your printer's build area and inspect the sliced ribs and slots before printing. Confirm material, layer height, adhesion, and strength with your own test print; no tested print profile is included.

## Customization

Open the SCAD file in OpenSCAD. Edit the dimensions near the top, preview with F5, render with F6, and export a fresh STL. Both heads share reusable modules, so their dimensions can change without scaling the rib and edge thicknesses.

The design was developed with AI assistance from visual references and iteratively adjusted. Feedback, test-print results, and improvements are welcome.

## License

GNU General Public License version 3 only (GPL-3.0-only). The complete editable source and license are included with the model files. Keep the source and license available when redistributing modified versions under these terms.
