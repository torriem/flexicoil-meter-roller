include <Flexicoil Meter Segment.scad>

translate([-100,0,0])
	fine(spiral=false);

translate([0,50,0])
	fine(spiral=true);

translate([0,-50,0])
	fine(spiral=true, twist = -36);

translate([100,0,0])
	add_divider()
		fine(spiral=true);

