// deterrent_spikes.scad
// Blunt cone-studded strip to keep birds, cats and other animals off railings, fence tops and ledges.
// Print base down, cones up, no supports. TPU gives flexible cones; PETG/ASA give rigid ones.
// Zip-tie it to the railing through the cone-free tie lanes.

/* [Strip] */
// Total run length along X (mm). Each printed piece is strip_length / num_segments and must fit your bed
strip_length = 210; // [40:1:2000]
// Width across the surface being protected (mm). Set just under its width
strip_width = 125; // [20:1:300]
// Base plate thickness (mm)
base_thickness = 2.5; // [0.8:0.1:6]
// Base plate corner radius (mm), which reduces corner lifting
corner_radius = 3; // [0:0.5:20]

/* [Cones] */
// Cone height above the base top surface (mm)
cone_height = 22; // [5:0.5:50]
// Cone base diameter (mm)
cone_base_dia = 9.7; // [3:0.1:20]
// Cone tip diameter (mm). Keep it blunt
cone_tip_dia = 3; // [0.5:0.1:10]
// Optional flare at the cone base for strength (mm, added to radius). 0 = none
cone_fillet = 0; // [0:0.25:3]
// Center-to-center pitch along the strip (mm)
cone_pitch_x = 16; // [5:0.5:40]
// Center-to-center pitch across the strip (mm)
cone_pitch_y = 16; // [5:0.5:40]
// Offset alternate rows by half a pitch (hex-ish layout)
stagger = true;
// Minimum distance from cone base edge to strip edge (mm)
edge_margin = 3; // [0:0.5:20]
// Facets per cone (24 is finer than the printer resolves; 48 for a smoother final export, at ~5x render time)
cone_fn = 24; // [8:1:64]

/* [Zip-tie lanes] */
// Distance between lanes along X (mm). 0 = no lanes
tie_lane_spacing = 70; // [0:1:500]
// Cone-free lane width (mm)
tie_lane_width = 10; // [0:0.5:30]
// X position of the first lane centre from the strip start (mm)
tie_lane_offset = 35; // [0:1:500]
// Depth of the recessed groove in the base top under each lane (mm). 0 = none
tie_groove_depth = 0.6; // [0:0.1:2]

/* [Tiling] */
// Split the run into this many pieces
num_segments = 1; // [1:1:20]
// Which piece to render (0-based)
segment_index = 0; // [0:1:19]
// Longest piece your printer bed fits (mm). Only used for a warning
max_piece_length = 210; // [50:1:500]

/* [Hidden] */
eps = 0.01;
foot = cone_base_dia + 2 * cone_fillet;  // cone footprint diameter
seg_len = strip_length / num_segments;
seg_x0 = segment_index * seg_len;
seg_x1 = seg_x0 + seg_len;

lanes = tie_lane_spacing > 0
    ? [for (x = [tie_lane_offset : tie_lane_spacing : strip_length]) x]
    : [];
cuts = [for (k = [1 : 1 : num_segments - 1]) k * seg_len];

// Cone-free X intervals: strip ends, tie lanes and segment cuts
function qsort(v) = len(v) <= 1 ? v :
    let (p = v[floor(len(v) / 2)][0])
    concat(qsort([for (e = v) if (e[0] < p) e]),
           [for (e = v) if (e[0] == p) e],
           qsort([for (e = v) if (e[0] > p) e]));

keepouts = qsort(concat(
    [[-1e9, edge_margin], [strip_length - edge_margin, 1e9]],
    [for (x = lanes) [x - tie_lane_width / 2, x + tie_lane_width / 2]],
    [for (c = cuts) [c - edge_margin, c + edge_margin]]));

// Cone blocks are the gaps between keep-outs; each is filled with its own centred grid
blocks = [for (k = [0 : len(keepouts) - 2])
              let (a = keepouts[k][1], b = keepouts[k + 1][0])
              if (b - a >= foot) [a, b]];

ny = floor((strip_width - 2 * edge_margin - foot) / cone_pitch_y) + 1;
y0 = strip_width / 2 - (ny - 1) * cone_pitch_y / 2;

// Columns per row in a block of width w. When staggered, odd rows shift by half a
// pitch, or by whatever slack the block has if that is less (never drop a column,
// which would leave paw-sized holes next to the lanes)
function block_n(w) = floor((w - foot) / cone_pitch_x) + 1;
function block_shift(w) = stagger
    ? min(cone_pitch_x / 2, (w - foot) - (block_n(w) - 1) * cone_pitch_x)
    : 0;

// Cone centres for the full run, before segment selection
all_cones = [
    for (blk = blocks)
        let (w = blk[1] - blk[0],
             n = block_n(w),
             shift = block_shift(w),
             x0 = (blk[0] + blk[1]) / 2 - ((n - 1) * cone_pitch_x + shift) / 2)
        for (j = [0 : ny - 1], i = [0 : n - 1])
            [x0 + i * cone_pitch_x + (j % 2 == 1 ? shift : 0),
             y0 + j * cone_pitch_y]
];

cones = [for (c = all_cones) if (c[0] >= seg_x0 && c[0] < seg_x1) c];
seg_lanes = [for (x = lanes) if (x + tie_lane_width / 2 > seg_x0
                                 && x - tie_lane_width / 2 < seg_x1) x];

echo(str("deterrent_spikes: segment ", segment_index + 1, "/", num_segments,
         ", ", seg_len, " x ", strip_width, " x ", base_thickness + cone_height,
         " mm, ", len(cones), " cones, lanes at X = ", seg_lanes,
         " (run coordinates)"));
if (seg_len > max_piece_length)
    echo(str("WARNING: piece length ", seg_len, " mm exceeds max_piece_length (",
             max_piece_length, " mm). Increase num_segments"));

module base_plate() {
    r = max(min(corner_radius, seg_len / 2 - eps, strip_width / 2 - eps), eps);
    hull()
        for (x = [seg_x0 + r, seg_x1 - r], y = [r, strip_width - r])
            translate([x, y, 0]) cylinder(r = r, h = base_thickness, $fn = 32);
}

module cone() {
    translate([0, 0, base_thickness - eps]) {
        cylinder(h = cone_height + eps, d1 = cone_base_dia, d2 = cone_tip_dia, $fn = cone_fn);
        if (cone_fillet > 0)
            cylinder(h = cone_fillet + eps, d1 = foot, d2 = cone_base_dia, $fn = cone_fn);
    }
}

translate([-seg_x0, 0, 0])
union() {
    difference() {
        base_plate();
        if (tie_groove_depth > 0)
            for (x = seg_lanes)
                translate([x - tie_lane_width / 2, -1, base_thickness - tie_groove_depth])
                    cube([tie_lane_width, strip_width + 2, tie_groove_depth + 1]);
    }
    for (c = cones) translate([c[0], c[1], 0]) rotate(180 / cone_fn) cone();
}
