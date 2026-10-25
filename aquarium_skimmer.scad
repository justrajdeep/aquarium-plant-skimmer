// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2026 aquarium-skimmer contributors
/*
 This program is free software: you can redistribute it and/or modify it
 under the terms of the GNU General Public License version 3.
 It is distributed without any warranty. See LICENSE for the full terms.

 Aquarium floating-plant skimmer — a beginner OpenSCAD example.
 Inspired by the supplied photos; dimensions are estimates, not measurements.
 Units: millimetres. The whole part sits flat on the XY plane, Z >= 0.

 LEARNING PATH
 1. Change head_width below, then press F5 to preview.
 2. Change rib_count to see how a for-loop repeats geometry.
 3. Read bar_2d(): hull() joins two circles into a rounded bar.
 4. Read the bottom: mirror() reverses the narrow fan to face the other way.
 5. At the bottom, linear_extrude() turns the 2D drawing into a 3D part.

 Open this file in OpenSCAD. F5 = preview; F6 = render.
 After rendering, use File > Export > Export as STL for a slicer.
*/

/* [Main dimensions] */
handle_length = 110;  // Rear end to the fan neck (x = 0)
handle_width = 28;
rim_width = 3.2;      // Shared width of the fan edges and raised lips
head_length = 105;    // Neck to the wide collecting edge
head_width = 130;     // Distance between outer rib centrelines at the tip
neck_width = handle_width - rim_width; // Including rails, base matches handle
thickness = 3.2;

/* [Sieve grid] */
rib_count = 21;       // Includes the two thick outer rails
rib_width = 1.6;
brace_count = 3;      // Interior braces; the tip rim is added separately
brace_width = 1.6;
solid_neck_length = 25; // Fill the narrow slots nearest the handle; 0 disables

/* [Narrow fan at opposite end] */
small_fan_enabled = true;
small_head_length = 70;
small_head_width = 40;
small_neck_width = neck_width; // Both fan bases match the handle width
small_rib_count = 9;
small_brace_count = 2;
small_solid_neck_length = 22; // Meets the first brace with these dimensions

/* [Raised fan lip] */
lip_height = 2;       // Extra height above the sieve; use 0 to disable
// The lip uses rim_width so its walls are flush with the fan edge.

/* [Hanging hole] */
// The hanging hole is cut in the handle.
hole_enabled = true;
hole_base_offset = 0; // Slot starts this far into the handle from narrow fan base
hole_length = 18;
hole_width = 10;
hole_end_margin = 10; // Material from rear end of handle to rear end of hole

/* [Detail] */
$fn = 48;            // Number of facets used to approximate each circle

// Guard against common invalid edits. assert() explains the problem.
assert(handle_width > 0 && thickness > 0);
assert(handle_length > handle_width);
assert(head_length > rim_width && head_width >= neck_width);
assert(neck_width > 0 && neck_width <= handle_width);
assert(rib_width > 0 && rim_width >= rib_width && brace_width > 0);
assert(rib_count >= 3 && rib_count == floor(rib_count));
assert(brace_count >= 0 && brace_count == floor(brace_count));
assert(solid_neck_length >= 0 && solid_neck_length < head_length);
assert(lip_height >= 0);
assert(!small_fan_enabled || (
    small_head_length > rim_width && small_head_width >= small_neck_width
    && small_neck_width > 0 && small_neck_width <= handle_width
    && small_rib_count >= 3 && small_rib_count == floor(small_rib_count)
    && small_brace_count >= 0 && small_brace_count == floor(small_brace_count)
    && small_solid_neck_length >= 0
    && small_solid_neck_length < small_head_length
));
assert(hole_width > 0 && hole_length >= hole_width);
assert(hole_end_margin > 0 && hole_end_margin + hole_length < handle_length);
// Keep the oval entirely inside the rounded rear of the handle.
assert(hole_width < handle_width);
assert(hole_end_margin + hole_width/2 >= handle_width/2);
assert(!small_fan_enabled || !hole_enabled || (
    hole_base_offset >= 0
    && hole_base_offset + hole_length <= handle_length - 2
    && handle_width >= hole_width + 4
), "Keep the hanging slot inside the handle width and clear of the big fan.");

/* [Hidden] */
// A small overlap makes the neck and handle one connected solid.
neck_overlap = 2;

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
    if (small_fan_enabled) {
        translate([-handle_length - neck_overlap, -handle_width/2])
            square([handle_length + 2 * neck_overlap, handle_width]);
    } else {
        // The single-ended version keeps its rounded hanging-loop end.
        union() {
            translate([-handle_length + handle_width/2, -handle_width/2])
                square([handle_length - handle_width/2 + neck_overlap,
                        handle_width]);
            translate([-handle_length + handle_width/2, 0])
                circle(d = handle_width);
        }
    }
}

module hanging_hole_2d() {
    // The narrow fan base is x = -handle_length.
    // Align the oval's end (not its center) with that base, then extend into handle.
    hole_start = -handle_length + (small_fan_enabled
                                  ? hole_base_offset : hole_end_margin);
    bar_2d([hole_start + hole_width/2, 0],
           [hole_start + hole_length - hole_width/2, 0], hole_width);
}

// Parameters let both heads share the same code without scaling rib thickness.
module fan_2d(length = head_length, tip_width = head_width,
              neck = neck_width, ribs = rib_count,
              braces = brace_count, solid_length = solid_neck_length) {
    // Fill the first section with a solid trapezoid instead of tiny slots.
    // polygon() connects the listed [x, y] corners in order.
    if (solid_length > 0) {
        fraction = (solid_length + neck_overlap)
                   / (length + neck_overlap);
        half_width = lerp(neck/2, tip_width/2, fraction);
        polygon(points = [
            [-neck_overlap, -neck/2],
            [solid_length, -half_width],
            [solid_length, half_width],
            [-neck_overlap, neck/2]
        ]);
    }

    // Repeat ribs across the fan. Their endpoints spread out toward the tip.
    for (i = [0 : ribs - 1]) {
        fraction = i / (ribs - 1);
        neck_y = lerp(-neck/2, neck/2, fraction);
        tip_y = lerp(-tip_width/2, tip_width/2, fraction);
        // The ternary operator is: condition ? value_if_true : value_if_false.
        width = (i == 0 || i == ribs - 1) ? rim_width : rib_width;
        bar_2d([-neck_overlap, neck_y], [length, tip_y], width);
    }

    // Close the wide collecting edge with a rounded rim.
    bar_2d([length, -tip_width/2],
           [length, tip_width/2], rim_width);

    // Cross-braces connect the ribs and divide the long slots.
    // The if() avoids an OpenSCAD descending range when braces = 0.
    if (braces > 0) {
        for (j = [1 : braces]) {
            fraction = j / (braces + 1);
            x = lerp(-neck_overlap, length, fraction);
            half_width = lerp(neck/2, tip_width/2, fraction);
            bar_2d([x, -half_width], [x, half_width], brace_width);
        }
    }
}

// The lip follows both sides and the wide collecting edge of the fan.
// Leave the neck open so the lip does not cross the handle.
module lip_2d(length = head_length, tip_width = head_width, neck = neck_width) {
    for (side = [-1, 1])
        bar_2d([-neck_overlap, side * neck/2],
               [length, side * tip_width/2], rim_width);
    bar_2d([length, -tip_width/2],
           [length, tip_width/2], rim_width);
}

// Build either fan with the same full-width raised perimeter.
module fan_3d(length = head_length, tip_width = head_width,
              neck = neck_width, ribs = rib_count,
              braces = brace_count, solid_length = solid_neck_length) {
    union() {
        linear_extrude(height = thickness)
            fan_2d(length, tip_width, neck, ribs, braces, solid_length);
        if (lip_height > 0)
            linear_extrude(height = thickness + lip_height)
                lip_2d(length, tip_width, neck);
    }
}

// Cut the hanging hole after joining everything so overlapping fan material
// cannot refill the end of the slot where it meets the handle.
difference() {
    union() {
        linear_extrude(height = thickness) handle_2d();
        fan_3d();
    
        // mirror([1, 0, 0]) reverses X, so this head points the other way.
        // translate() places its neck at the opposite end of the handle.
        if (small_fan_enabled)
            translate([-handle_length, 0, 0])
                mirror([1, 0, 0])
                    fan_3d(small_head_length, small_head_width, small_neck_width,
                           small_rib_count, small_brace_count,
                           small_solid_neck_length);
    }

    if (hole_enabled)
        translate([0, 0, -1])
            linear_extrude(height = thickness + lip_height + 2)
                hanging_hole_2d();
}
