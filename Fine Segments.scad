include <Flexicoil Meter Segment.scad>

translate([-100,0,0])
	fine(spiral=false);

fine(spiral=true);

translate([100,0,0])
	add_divider()
		fine(spiral=true);

