include <Flexicoil Meter Segment.scad>

flute_depth = 3; //not ideal, since we also have this in the included scad file

union() {
	flute_depth = 3;
	segment_part(segment_width, segment_diameter_tight, 0, 25, top_chamfer = 3)
		blank(segment_width);

	translate([0,0,segment_width / 4])
		segment_part(segment_width, segment_diameter_tight, 0, 25, top_chamfer = flute_depth)
			extra_fine_fluted(segment_width, spiral=true, flute_depth=flute_depth);
			//extra_fine(segment_width, spiral=true, scallop_depth=flute_depth);
	translate([0,0,segment_width / 4 * 2])
		segment_part(segment_width, segment_diameter_tight, 75, 100, bottom_chamfer = flute_depth)
			extra_fine_fluted(segment_width, spiral=true, flute_depth=flute_depth);
			//extra_fine(segment_width, spiral=true, scallop_depth=flute_depth);
	translate([0,0,segment_width / 4 * 3])
		segment_part(segment_width, segment_diameter_tight, 75, 100, bottom_chamfer = flute_depth)
			blank(segment_width);
}
