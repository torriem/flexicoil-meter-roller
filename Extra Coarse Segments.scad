include <Flexicoil Meter Segment.scad>

translate([-100,0,0])
	extra_coarse(spiral=false);

translate([0,50,0])
	extra_coarse(spiral=true);

translate([0,-50,0])
	extra_coarse(spiral=true, twist=-36);

translate([100,0,0])
	add_divider()
		extra_coarse(spiral=true);

