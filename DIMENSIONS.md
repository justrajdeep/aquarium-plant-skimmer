# Dimension interpretation

The user supplied four ruler photographs and two caliper photographs of an existing single-ended printed skimmer. They clarify that the large fan's openings continue almost to the handle; a long solid neck section was an incorrect earlier interpretation.

| Feature | Reference evidence | Current model |
|---|---|---|
| Large fan outer front width | About 9 cm across the ruler | 90 mm |
| Handle / fan junction width | About 2.5 cm | 25 mm |
| Handle length between fans | Shortened at user request to fit a P1S plate | 95 mm |
| Sloping outer side | About 9 cm; also specified by the user | 90 mm between outer corners |
| Fan depth | Roughly 8.4 cm in the longitudinal ruler photo | 83.93 mm, calculated from widths and side length |
| Rows of openings | Four visible rows | Four |
| Openings across front row | User specified 16; consistent with the reference | 16 |
| Brace spacing | Roughly 2 cm along the fan | 20.38 mm centre-to-centre; 19.58 mm clear opening |
| Border at handle | Thin strip; openings reach almost to junction | 1.6 mm |
| Perimeter width | Not measured directly | 1.6 mm estimate for large fan |
| Internal ribs / braces | Not measured directly | 0.8 mm estimate for large fan |
| Flat base thickness | Caliper reads 2.43 mm; user confirmed interpretation | 2.43 mm |
| Total height at lip | Caliper reads 6.40 mm; user confirmed interpretation | 6.40 mm |
| Lip rise above flat base | Difference between total and base heights | 3.97 mm |
| Side lip start at handle | User requested lip along the full slotted area, without a rear wall | 1.6 mm from the junction, aligned with the slot openings |

Dimensions read from perspective photographs are approximate. The model is a reconstruction, not a metrologically exact copy. Rounded slot corners in the reference have not been reproduced; the current large fan openings have straight polygonal corners.

At the user's request, the opposite fan reuses the mirrored large-fan construction with half the front width: 45 mm. Its depth is three-quarters of the large fan's depth: approximately 62.95 mm, while its handle junction stays 25 mm wide. Both fans have four rows, the same material widths, and the same vertical dimensions. The large fan has sixteen slots per row; the smaller fan has eight, set by `second_slot_count = 8`. The narrower fan's sloping sides are approximately 63.73 mm; this head is a custom addition, not independently measured by the photographs.


## P1S fit calculation

[Bambu Lab lists a 256 × 256 × 256 mm build volume for the P1S](https://store.bblcdn.com/7032c40b1ca64c70bcb3239d46cc72aa.pdf). The default fans extend 83.927 mm and 62.945 mm beyond their junctions. With a 95 mm handle the complete tool is approximately 241.872 × 90 × 6.4 mm. Centering it along a plate axis gives 7.064 mm clearance at each end, or 2.064 mm beyond a nominal 5 mm brim. This is a bounding-box calculation, not a verified Bambu Studio sliced profile.


The user-saved `aquarium_skimmer.3mf` contains the same approximately 241.872 × 90 × 6.4 mm mesh, configured for P1S / 0.4 mm nozzle. In its updated centered, rotated placement, model bounds are approximately X = 82.999–172.997 mm and Y = 6.842–249.158 mm. A nominal 5 mm outer brim spans approximately X = 77.999–177.997 mm and Y = 1.842–254.158 mm, within the 256 mm plate. These are archive geometry/settings checks, not a toolpath simulation or physical print test.


The raised lip is built from three explicit strips, without a rear strip across the handle. This avoids the thin surface created when subtracting the rear of a perimeter ring at its inset boundary. The 3MF mesh has been refreshed from the corrected STL while preserving the saved project settings and placement. Geometry checks confirm that a centerline at Z = 4 mm passes unobstructed from either handle junction until the front lip. Bambu Studio's command-line reader accepted and re-exported the corrected project; no physical print test was performed.
