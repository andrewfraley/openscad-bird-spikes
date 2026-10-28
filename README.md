# Humane Deterrent Spikes (bird spikes / cat deterrent)

A customizable OpenSCAD model of a cone-studded strip that keeps birds, cats and other animals off railings, fence tops, ledges and windowsills. Print it in TPU for a flexible strip, or in PETG or ASA for a rigid one, then zip-tie it in place. You don't need screws, glue or holes.

Unlike traditional bird spikes, the cones are **blunt**. They make a surface uncomfortable to land or walk on without injuring the animal. The idea is the same as a "scat mat".

## Features

- **Fully parametric.** Every dimension is adjustable in the OpenSCAD Customizer or with `-D` on the command line.
- **Auto layout.** You set the pitch and the strip size, and the cone count is calculated for you. The rows are centered, the margins are even, and no cone is ever cut off.
- **Zip-tie lanes.** Cone-free bands run across the strip at regular intervals, with a shallow groove in the base so the tie can't slide.
- **Tiling for long runs.** You can split a long run into bed-sized pieces that line up end to end.
- **Printer friendly.** Prints base down with no supports, and the rounded base corners help reduce curling.
- **Single manifold solid.** It slices cleanly with no repairs needed.

## Quick start

1. Install [OpenSCAD](https://openscad.org/) (2021.01 or newer).
2. Open `deterrent_spikes.scad`.
3. Show the Customizer if it's hidden. In 2021.01, open the Window menu and uncheck "Hide Customizer".
4. Set `strip_width` to just under the width of the surface you're protecting. Set `strip_length` to the total run you need.
5. Press F6 to render, then use File → Export → Export as STL.

On the command line:

```sh
openscad -o spikes.stl -D strip_width=90 -D strip_length=200 deterrent_spikes.scad
```

## Parameters

### Strip
| Parameter | Default | Description |
|---|---|---|
| `strip_length` | 210 | Total run length (mm). Each printed piece is `strip_length / num_segments` long. |
| `strip_width` | 125 | Width across the surface (mm). Set it just under the surface's width. |
| `base_thickness` | 2.5 | Base plate thickness (mm). Thinner bases curl and tear, especially in TPU. |
| `corner_radius` | 3 | Base plate corner radius (mm). It reduces corner lifting. |

### Cones
| Parameter | Default | Description |
|---|---|---|
| `cone_height` | 22 | Height above the base (mm). |
| `cone_base_dia` | 9.7 | Base diameter (mm). |
| `cone_tip_dia` | 3 | Tip diameter (mm). Keep it blunt. |
| `cone_fillet` | 0 | Optional flare at the cone base for strength (mm). |
| `cone_pitch_x` / `cone_pitch_y` | 16 | Center-to-center spacing (mm). |
| `stagger` | true | Offsets alternate rows for a hex-like layout. |
| `edge_margin` | 3 | Minimum gap from the cone base to the strip edge (mm). |
| `cone_fn` | 24 | Facets per cone. 24 is finer than a printer can resolve. Use 48 for a smoother final export, though it renders about 5× slower. |

### Zip-tie lanes
| Parameter | Default | Description |
|---|---|---|
| `tie_lane_spacing` | 70 | Distance between lanes (mm). 0 means no lanes. |
| `tie_lane_width` | 10 | Cone-free lane width (mm). Most zip ties are 7–9 mm wide. |
| `tie_lane_offset` | 35 | Position of the first lane from the strip start (mm). |
| `tie_groove_depth` | 0.6 | Depth of the groove under each lane (mm). 0 means no groove. |

### Tiling
| Parameter | Default | Description |
|---|---|---|
| `num_segments` | 1 | Splits the run into this many pieces. |
| `segment_index` | 0 | Which piece to render (0-based). |
| `max_piece_length` | 210 | Your bed's usable length (mm). The console warns you if a piece is longer. |

## Choosing the spacing

The goal is to leave no flat spot big enough to land on or step on comfortably.

- **Cats:** a cat's forepaw is about 25–35 mm across. The default 16 mm pitch leaves no flat spot larger than about 16 mm, even next to the tie lanes.
- **Pigeons and larger birds:** the defaults work.
- **Smaller birds:** reduce the pitch to 12–14 mm. Nothing stops a very small bird from perching between cones. The same limitation applies to traditional spikes.

If you go above an 18 mm pitch, check the gaps next to the tie lanes. A block between two lanes might only fit a few columns, and the leftover space ends up beside the lane. Adjusting `tie_lane_spacing` to roughly a multiple of the pitch fixes this.

## Long runs

Set `strip_length` to the total length you need. Then increase `num_segments` until each piece fits your bed, and export once for each `segment_index`. The layout is computed over the whole run, so the pieces line up seamlessly. If you position the tie lanes so the cuts land inside a lane, the joins lose no cones.

```sh
for i in 0 1 2; do
  openscad -o spikes_$i.stl -D strip_length=600 -D num_segments=3 -D segment_index=$i deterrent_spikes.scad
done
```

## Printing

- **Material:** use whatever suits the job.
  - **TPU (around 95A):** the cones flex and the strip bends to fit curved or uneven surfaces. It's the gentlest option and survives being stepped on. Print it slowly.
  - **PETG or ASA:** the cones are rigid but still blunt, and the strip stays flat. Both are good outdoors and print faster than TPU. For a rigid strip on a flat surface, the base can be thinner.
  - **PLA:** fine indoors, but it goes brittle and warps in sunlight, so avoid it outdoors.
- **Orientation:** as modeled, with the base on the bed and the cones up. No supports are needed.
- **Settings:** 0.2 mm layers and 3 perimeters. A brim helps keep the long edges flat.
- **Mounting:** wrap a zip tie around the railing through each lane and tighten it into the groove.

## License

[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)
