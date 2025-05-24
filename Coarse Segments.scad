include <Flexicoil Meter Segment.scad>

translate([-100,0,0])
	coarse(spiral=false);

translate([0,50,0])
	coarse(spiral=true);

translate([0,-50,0])
	coarse(spiral=true, twist=-36);

translate([100,0,0])
	add_divider()
		coarse(spiral=true);

