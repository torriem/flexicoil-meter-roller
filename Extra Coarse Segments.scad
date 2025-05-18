include <Flexicoil Meter Segment.scad>

translate([-100,0,0])
	extra_coarse(spiral=false);

extra_coarse(spiral=true);

translate([100,0,0])
	add_divider()
		extra_coarse(spiral=true);

