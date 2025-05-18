include <Flexicoil Meter Segment.scad>

translate([-100,0,0])
	coarse(spiral=false);

coarse(spiral=true);

translate([100,0,0])
	add_divider()
		coarse(spiral=true);

