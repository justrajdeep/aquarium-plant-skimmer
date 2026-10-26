// SPDX-License-Identifier: CC-BY-SA-4.0
// Copyright (C) 2026 aquarium-skimmer contributors
/*
 This CAD design is licensed under Creative Commons Attribution-ShareAlike
 4.0 International. Attribute justrajdeep and the project repository,
 indicate changes, and share adaptations under the same licence.
 See LICENSE and https://creativecommons.org/licenses/by-sa/4.0/.
 Provided without warranties. Earlier GPL releases retain their permissions.

 Aquarium floating-plant skimmer — a beginner OpenSCAD example.
 Based on reference photos and user-confirmed measurements; see DIMENSIONS.md.
 Units: millimetres. The whole part sits flat on the XY plane, Z >= 0.

 LEARNING PATH
 1. Change head_outer_width below, then press F5 to preview.
 2. Change rib_count to see how a for-loop repeats geometry.
 3. Read bar_2d(): hull() joins two circles into a rounded bar.
 4. Read the bottom: mirror() reverses the opposite fan to face the other way.
 5. At the bottom, linear_extrude() turns the 2D drawing into a 3D part.

 Open this file in OpenSCAD. F5 = preview; F6 = render.
 After rendering, use File > Export > Export as STL for a slicer.
*/

/* [Main dimensions] */
handle_length = 95;   // Shortened for P1S: ~241.9 mm overall, ~7.1 mm end clearance
handle_width = 25;    // 2.5 cm across the handle
head_side_length = 90; // Approximate outer corner-to-corner sloping side from photos
head_outer_width = 90; // 9 cm maximum width, including the edge rails
thickness = 2.43;     // Caliper-confirmed flat base thickness

// Match the measured OUTER trapezoid, rather than subtracting rounded rail caps.
// A 90 mm side and a 32.5 mm half-flare give approximately 83.93 mm of depth.
head_length = sqrt(pow(head_side_length, 2)
                   - pow((head_outer_width - handle_width)/2, 2));

/* [Large fan grid from reference photos] */
rib_count = 17;        // 16 openings across each of four rows
slot_row_count = 4;
large_rim_width = 1.6; // XY perimeter width estimated from photos
large_rib_width = 0.8;
large_brace_width = 0.8;
solid_neck_length = large_rim_width; // Only a small border at the handle junction
brace_count = slot_row_count - 1;
slot_clear_length = (head_length - large_rim_width - solid_neck_length
                     - brace_count * large_brace_width) / slot_row_count;
// With these dimensions, equal rows are ~19.58 mm long, at ~20.38 mm pitch.

/* [Opposite fan] */
second_fan_enabled = true;
second_width_ratio = 0.5; // Wide edge is half the large fan width
second_length_ratio = 0.75; // Handle-to-front depth is three-quarters of large fan
second_slot_count = 8;     // Eight openings per row on the small fan
second_head_outer_width = head_outer_width * second_width_ratio;
second_head_length = head_length * second_length_ratio;

/* [Raised fan lip] */
total_height = 6.40;  // Caliper-confirmed height from underside to top of lip
lip_height = total_height - thickness; // 3.97 mm above the base
lip_handle_clearance = solid_neck_length; // Side lips start exactly where slots start
// Both lips use large_rim_width so their walls are flush with the fan edges.

/* [Hanging hole] */
// The hanging hole is cut in the handle.
hole_enabled = true;
hole_base_offset = 0; // Slot starts this far into the handle from opposite fan base
hole_length = 18;
hole_width = 10;
hole_end_margin = 10; // Material from rear end of handle to rear end of hole

/* [Detail] */
$fn = 48;            // Number of facets used to approximate each circle

// Guard against common invalid edits. assert() explains the problem.
assert(handle_width > 0 && thickness > 0);
assert(handle_length > handle_width);
assert(head_side_length > abs(head_outer_width - handle_width)/2);
assert(large_rim_width > 0 && large_rib_width > 0 && large_brace_width > 0);
assert(head_length > large_rim_width && head_outer_width >= handle_width);
assert(slot_clear_length > 0);
assert(!second_fan_enabled || second_head_outer_width >= handle_width,
       "Opposite fan wide edge must be at least as wide as its handle junction.");
assert(!second_fan_enabled || second_head_length
       > large_rim_width + solid_neck_length + brace_count * large_brace_width,
       "Opposite fan is too short for the requested rows and brace widths.");
assert(!second_fan_enabled || (second_slot_count >= 1
       && second_slot_count == floor(second_slot_count)));
assert(rib_count >= 3 && rib_count == floor(rib_count));
assert(brace_count >= 0 && brace_count == floor(brace_count));
assert(solid_neck_length >= 0 && solid_neck_length < head_length);
assert(lip_height >= 0);
assert(lip_handle_clearance >= large_rim_width && lip_handle_clearance < head_length);
assert(!second_fan_enabled || lip_handle_clearance < second_head_length);
assert(hole_width > 0 && hole_length >= hole_width);
assert(hole_end_margin > 0 && hole_end_margin + hole_length < handle_length);
// Keep the oval entirely inside the rounded rear of the handle.
assert(hole_width < handle_width);
assert(hole_end_margin + hole_width/2 >= handle_width/2);
assert(!second_fan_enabled || !hole_enabled || (
    hole_base_offset >= 0
    && hole_base_offset + hole_length <= handle_length - 2
    && handle_width >= hole_width + 4
), "Keep the hanging slot inside the handle width and clear of the big fan.");

// A function returns a value. This one linearly interpolates between a and b.
// t = 0 gives a; t = 1 gives b; t = 0.5 gives the midpoint.
function lerp(a, b, t) = a + (b - a) * t;

// A module creates geometry, like a reusable drawing command.
// hull() wraps the smallest convex outline around its child shapes.
module bar_2d(p1, p2, width) {
    hull() {
        translate(p1) circle(d = width);
        translate(p2) circle(d = width);
    }
}

module handle_2d() {
    // With two fans, keep the handle full width at both connections.
    if (second_fan_enabled) {
        translate([-handle_length, -handle_width/2])
            square([handle_length, handle_width]);
    } else {
        // The single-ended version keeps its rounded hanging-loop end.
        union() {
            translate([-handle_length + handle_width/2, -handle_width/2])
                square([handle_length - handle_width/2,
                        handle_width]);
            translate([-handle_length + handle_width/2, 0])
                circle(d = handle_width);
        }
    }
}

module hanging_hole_2d() {
    // The opposite fan base is x = -handle_length.
    // Align the oval's end (not its center) with that base, then extend into handle.
    hole_start = -handle_length + (second_fan_enabled
                                  ? hole_base_offset : hole_end_margin);
    bar_2d([hole_start + hole_width/2, 0],
           [hole_start + hole_length - hole_width/2, 0], hole_width);
}

// The photographed large fan has a straight-sided OUTER trapezoid.
module large_outline_2d(outer_width = head_outer_width, length = head_length) {
    polygon([[0, -handle_width/2], [length, -outer_width/2],
             [length, outer_width/2], [0, handle_width/2]]);
}

// Offset the sloping sides inward by the perimeter thickness.
function large_inner_half_width(x, outer_width = head_outer_width,
                                length = head_length) =
    lerp(handle_width/2, outer_width/2, x/length)
    - large_rim_width * sqrt(1 + pow((outer_width-handle_width)
                                      / (2*length), 2));

// Slot boundaries interpolate across the usable width, leaving thin ribs.
function large_slot_y(x, fraction, outer_width = head_outer_width,
                      length = head_length) =
    lerp(-large_inner_half_width(x, outer_width, length),
         large_inner_half_width(x, outer_width, length), fraction);

module large_grid_2d(outer_width = head_outer_width, length = head_length,
                     slots = rib_count - 1) {
    row_clear_length = (length - large_rim_width - solid_neck_length
                        - brace_count * large_brace_width) / slot_row_count;
    assert(row_clear_length > 0);
    difference() {
        large_outline_2d(outer_width, length);
        // Remove one trapezoid for every slot in each row.
        for (row = [0 : slot_row_count - 1]) {
            x0 = solid_neck_length + row * (row_clear_length + large_brace_width);
            x1 = x0 + row_clear_length;
            for (column = [0 : slots - 1]) {
                f0 = column / slots;
                f1 = (column + 1) / slots;
                low_gap = column == 0 ? 0 : large_rib_width/2;
                high_gap = column == slots - 1 ? 0 : large_rib_width/2;
                assert(large_slot_y(x0, f1, outer_width, length) - high_gap
                       > large_slot_y(x0, f0, outer_width, length) + low_gap,
                       "Large fan ribs leave no opening at the neck.");
                polygon([
                    [x0, large_slot_y(x0, f0, outer_width, length) + low_gap],
                    [x1, large_slot_y(x1, f0, outer_width, length) + low_gap],
                    [x1, large_slot_y(x1, f1, outer_width, length) - high_gap],
                    [x0, large_slot_y(x0, f1, outer_width, length) - high_gap]
                ]);
            }
        }
    }
}

module large_lip_2d(outer_width = head_outer_width, length = head_length) {
    // Build only the three wanted walls. Subtracting the rear of an inset ring
    // at exactly the inset boundary can leave a thin face in slicers.
    // Explicit side strips avoid that coincident-edge artifact entirely.
    start = lip_handle_clearance;
    outer_at_start = lerp(handle_width/2, outer_width/2, start/length);
    intersection() {
        large_outline_2d(outer_width, length);
        union() {
            for (side = [-1, 1])
                polygon([
                    [start, side * outer_at_start],
                    [length, side * outer_width/2],
                    [length, side * large_inner_half_width(length, outer_width, length)],
                    [start, side * large_inner_half_width(start, outer_width, length)]
                ]);
            // Clip this front strip to the fan outline at the corners.
            translate([length - large_rim_width, -outer_width/2])
                square([large_rim_width, outer_width]);
        }
    }
}

// Rebuild each head with its own width and depth; preserve neck and material widths.
module large_fan_3d(outer_width = head_outer_width, length = head_length,
                    slots = rib_count - 1) {
    union() {
        linear_extrude(height = thickness) large_grid_2d(outer_width, length, slots);
        if (lip_height > 0)
            linear_extrude(height = thickness + lip_height) large_lip_2d(outer_width, length);
    }
}

// Cut the hanging hole after joining everything so overlapping fan material
// cannot refill the end of the slot where it meets the handle.
difference() {
    union() {
        linear_extrude(height = thickness) handle_2d();
        large_fan_3d();
    
        // Reuse the fan module at half width and three-quarter depth, then mirror X.
        // translate() places its neck at the opposite end of the handle.
        if (second_fan_enabled)
            translate([-handle_length, 0, 0])
                mirror([1, 0, 0])
                    large_fan_3d(second_head_outer_width, second_head_length, second_slot_count);
    }

    if (hole_enabled)
        translate([0, 0, -1])
            linear_extrude(height = thickness + lip_height + 2)
                hanging_hole_2d();
}
