# Printables listing

## Title

Bird Spikes & Cat Deterrent Strip – Customizable, Humane, Zip-Tie Mount

## Summary

Humane bird spikes and cat deterrent strip. Blunt cones, zip-tie mount, print in TPU or PETG, fully customizable in OpenSCAD.

## Description

Keep birds, cats, squirrels and other animals off railings, fence tops, ledges and windowsills. This is a strip of blunt cones that makes the surface uncomfortable to land on or walk across, without the sharp needles of traditional bird spikes.

**Why it's different**

- **Humane.** The cones have blunt 3 mm tips, so they deter animals without hurting them.
- **Your choice of material.** Print it in TPU for a flexible strip that bends to fit curved surfaces, or in PETG or ASA for a rigid, weather-resistant one.
- **No drilling or glue.** Zip ties wrap around the railing through built-in cone-free lanes. A shallow groove keeps each tie from sliding.
- **Fits your surface.** The included OpenSCAD file lets you set the width, length, cone height and spacing, the zip-tie lane positions and more. The cone layout is generated automatically.
- **Any length.** Long runs split into bed-sized pieces that line up end to end.

**Included files**

- `deterrent_spikes.scad`: the customizable model.
- A ready-to-print STL, 210 × 125 mm with the default settings. It fits most 220 mm-class beds.

The latest version of the model is always on GitHub: https://github.com/andrewfraley/openscad-bird-spikes

**Customizing**

1. Install OpenSCAD (free, openscad.org) and open `deterrent_spikes.scad`.
2. Show the Customizer panel (Window menu, uncheck "Hide Customizer").
3. Set `strip_width` to just under the width of your surface, and `strip_length` to your run.
4. If the run is longer than your bed, raise `num_segments` and export each `segment_index`.
5. Render (F6) and export to STL.

The README on GitHub explains every parameter and has tips on choosing the spacing for different animals. Issues and pull requests are welcome there.

**Spacing tips**

- The default 16 mm pitch leaves no flat spot larger than about 16 mm. That works for cats, whose forepaws are 25–35 mm across, and for pigeons.
- For smaller birds, reduce the pitch to 12–14 mm.

## Print settings

- **Material:** TPU (around 95A) for a flexible strip, or PETG or ASA for a rigid one. Avoid PLA outdoors because it degrades in sunlight.
- **Supports:** none
- **Orientation:** as modeled, base down
- **Layer height:** 0.2 mm
- **Perimeters:** 3
- **Infill:** 15–20%
- **Brim:** recommended to keep the long edges flat
- **Speed:** slow for TPU; normal for PETG and ASA

## Mounting

You need zip ties long enough to wrap around your railing, up to 9 mm wide. Thread one through each cone-free lane, around the railing, and tighten it into the groove. Trim the tails.

## Tags

bird spikes, bird deterrent, pigeon spikes, cat deterrent, cat repellent, scat mat, pest control, animal deterrent, garden, fence, railing, TPU, PETG, humane, customizable, OpenSCAD, parametric

## Category

Household → Outdoor & Garden

## License

Creative Commons — Attribution — Share Alike (CC BY-SA 4.0)
