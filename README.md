# Dual-Ended Aquarium Plant Skimmer

A customizable aquarium plant skimmer and beginner-friendly OpenSCAD example.

![Model preview, not a photograph of a physical print](aquarium_skimmer.png)

**Status:** source compiled in OpenSCAD 2021.01; STL preview inspected. The current model has not been test-printed or tested in an aquarium. The reference photographs show an existing printed tool, not a validation print of this version.

## Files

- `aquarium_skimmer.scad`: editable source with learning comments.
- `aquarium_skimmer.stl`: default geometry for your slicer.
- `aquarium_skimmer.3mf`: user-saved Bambu Studio project for P1S / 0.4 mm nozzle; includes print settings, not a verified physical print profile.
- `aquarium_skimmer.png`: illustration generated from the STL.
- `DIMENSIONS.md`: dimensions, photo interpretation, and remaining estimates.
- `LICENSE`: GNU GPL version 3.
- `MAKERWORLD_DESCRIPTION.md`: ready-to-paste listing description.
- `scripts/render_preview.py`: optional preview generator (Python and Pillow).

## Large fan matched to ruler photographs

The large fan has a 90 mm outer front edge, a 25 mm handle junction, approximately 90 mm sloping outer sides, four rows, and 16 slots across each row. The outer trapezoid has approximately 83.93 mm of depth, calculated from its side length and widths using Pythagoras.

The openings extend almost all the way to the handle. A 1.6 mm border replaces the previous oversized solid base. Each row has approximately 19.58 mm clear length along X, with 0.8 mm braces giving approximately 20.38 mm pitch. These are approximate matches to the ruler photos. Equal row length excludes brace material; the openings widen toward the front. Length measured along an angled side of an opening varies with its angle.

`head_side_length`, `head_outer_width`, and `handle_width` describe the outer silhouette directly. `slot_row_count = 4` and `rib_count = 17` produce 4 × 16 openings. `large_rim_width = 1.6`, `large_rib_width = 0.8`, and `large_brace_width = 0.8` are estimates from the photographs, not verified caliper measurements.

## Half-width opposite fan and handle

The opposite fan uses the same mirrored construction with a **45 mm wide front edge**, half the large fan's 90 mm width. `second_width_ratio = 0.5` sets this relationship; changing `head_outer_width` updates both front widths. Its depth is **62.95 mm**, three-quarters of the large fan's 83.93 mm depth, controlled by `second_length_ratio = 0.75`. Both heads keep the same 25 mm handle junction, four rows, 0.8 mm ribs and braces, and raised lip heights. The small fan has **eight slots per row**, set by `second_slot_count = 8`; the large fan retains sixteen slots per row. The small fan has equal clear rows of approximately 14.34 mm along X and sloping sides of approximately 63.73 mm. `second_fan_enabled = false` restores a single-ended tool.

Both fans join a 25 mm wide handle. The handle extends 95 mm between the fan junctions. An 18 × 10 mm oval hanging hole starts at the opposite fan base and extends into the handle. `hole_base_offset` moves it toward the large fan; `hole_enabled = false` removes it. `second_fan_enabled = false` restores a single-ended tool with a rounded hanging-loop end.

The complete default tool is approximately **241.9 × 90 × 6.4 mm**. The user confirmed the caliper measurements: `thickness = 2.43` mm for the flat base and `total_height = 6.40` mm from the underside to the top of the lip. The code calculates `lip_height = total_height - thickness`, giving a 3.97 mm rise above the base. Both lips use these heights and sit flush with the side and front fan edges. `lip_handle_clearance = solid_neck_length` aligns the side lip ends with the slot openings, 1.6 mm from each handle junction. The lips cover the full slotted area, while the rear edge across the handle entry remains flat. Rib and perimeter widths in the XY plane remain estimates.

## Try it

1. Open the SCAD file in OpenSCAD and press **F5** to preview (some Mac keyboards need Fn).
2. Change `head_outer_width` from `90` to `80` and preview again.
3. Change `rib_count` from `17` to `19`; this changes the large fan from 16 to 18 openings across each row.
4. Change `slot_row_count` from `4` to `3` to create three longer rows without leaving a short last row.
5. Render with **F6**, then use **File → Export → Export as STL**. Import the new STL into your slicer.

## How the code works

The large fan starts as an outer trapezoid drawn with `polygon()`. Nested `for` loops subtract four rows of sixteen trapezoidal openings using `difference()`. This keeps the narrow openings at the neck usable with thin ribs.

Both fan drawings use `linear_extrude()` to add thickness, and a second extrusion creates the lip from three explicit strips (two sides and the front), with no rear strip across the handle. At the bottom, the code calls `large_fan_3d()` once for each end. For the second head, `mirror([1, 0, 0])` reverses it and `translate([-handle_length, 0, 0])` places it at the opposite junction. The second call passes `second_head_outer_width` and `second_head_length` to change its wide edge and depth. Geometry and brace positions are rebuilt for these dimensions, so the handle junction, ribs, perimeter, and height stay fixed instead of being scaled. `union()` joins them to the handle, and `difference()` cuts the hanging hole through the combined geometry.

| Construct | Purpose |
|---|---|
| `polygon([...])` | Outline the large fan and its openings |
| `for (...)` | Repeat slot rows, columns, ribs, or braces |
| `difference()` | Remove slots or the hanging hole |
| `intersection()` | Clip the front lip strip to the fan outline |
| `circle()` and `hull()` | Draw rounded bars and the oval hanging hole |
| `linear_extrude()` | Give a 2D drawing thickness |
| `mirror([1, 0, 0])` | Reverse the opposite fan along X |

## P1S build-plate fit

The handle is shortened from 110 mm to 95 mm for a total length of approximately 241.87 mm. On the P1S's nominal 256 × 256 mm build area, center the model flat with its long axis parallel to a plate edge. This leaves approximately 7.06 mm at each end. A 5 mm brim would bring the bounding footprint to approximately 251.87 × 100 mm. These are geometry calculations; inspect the actual sliced plate with your selected printer settings before printing.

## Bambu Studio project

Open `aquarium_skimmer.3mf` as a project to load the saved P1S / 0.4 mm nozzle settings and model placement. The project contains PLA presets, 0.20 mm layers, and a 5 mm outer brim. Its model geometry has been refreshed from the current STL to remove a thin rear-lip artifact; the original user-saved print settings and placement are preserved. It has not been physically test-printed.

The saved project has been re-centered. Its rotated model footprint is approximately X = 83.00–173.00 mm and Y = 6.84–249.16 mm, so the nominal 5 mm brim also fits inside the 256 mm plate. This is a geometry/settings check; inspect the actual sliced brim before printing.

## Before printing

Place the flat underside on the bed with the raised lips facing up. The geometry is intended to print without supports. Check the overall dimensions against your build plate, then inspect the sliced thin ribs and narrow slots near the handle. A successful source render does not establish printability or strength for a particular material or nozzle.

## Contributing and license

Feedback, test prints, and pull requests are welcome. Include parameter values and your OpenSCAD version for geometry reports; include printer, filament, nozzle, layer height, and photographs for print reports. Regenerate the STL and preview when changing default geometry.

The model was developed with AI assistance from visual references and iteratively adjusted. Reference photographs are not included in this repository.

Licensed under **GNU GPL version 3 only** (`GPL-3.0-only`). See [LICENSE](LICENSE). Contributions should use the same license.
