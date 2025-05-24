include <Flexicoil Meter Segment.scad>

flute_depth = 3; //common depth for all versions below

translate([-150,50,0])
	extra_fine(spiral=false, scallop_depth = flute_depth);
translate([-50,50,0])
	extra_fine(spiral=true, scallop_depth = flute_depth);
translate([50,50,0])
	extra_fine_fluted(spiral=false, flute_depth = flute_depth);
translate([150,50])
	extra_fine_fluted(spiral=true, flute_depth = flute_depth);
translate([-150,-50,0])
	add_divider(tight=true)
		extra_fine(spiral=true, scallop_depth = flute_depth);
translate([-50,-50,0])
	extra_fine_halfwidth(flute_depth);
translate([50,-50,0])
	canola_experimental(flute_depth);
translate([150,-50,0])
	add_divider(tight=true)
		extra_fine_fluted(spiral=true, flute_depth = flute_depth);
	
translate([-50,150,0])
	extra_fine(spiral=true, scallop_depth = flute_depth, twist = -24);

translate([150,150,0])
	extra_fine_fluted(spiral=true, flute_depth = flute_depth, twist = -24);

/* An experimental segment design for canola that uses
   flutes like the OEM fine roller, but very shallow,
   and only half width.
*/
module canola_experimental(flute_depth = extra_fine_flute_depth) {

	union() {
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
}

/* A half-width roller segment using OEM-style, but spiraled segments */
module extra_fine_halfwidth(flute_depth = extra_fine_flute_depth) {

	union() {
		segment_part(segment_width, segment_diameter_tight, 0, 25, top_chamfer = 3)
			blank(segment_width);

		translate([0,0,segment_width / 4])
			segment_part(segment_width, segment_diameter_tight, 0, 25, top_chamfer = flute_depth)
				extra_fine(segment_width, spiral=true, scallop_depth=flute_depth);
				//extra_fine(segment_width, spiral=true, scallop_depth=flute_depth);
		translate([0,0,segment_width / 4 * 2])
			segment_part(segment_width, segment_diameter_tight, 75, 100, bottom_chamfer = flute_depth)
				extra_fine(segment_width, spiral=true, scallop_depth=flute_depth);
				//extra_fine(segment_width, spiral=true, scallop_depth=flute_depth);
		translate([0,0,segment_width / 4 * 3])
			segment_part(segment_width, segment_diameter_tight, 75, 100, bottom_chamfer = flute_depth)
				blank(segment_width);
	}
}
