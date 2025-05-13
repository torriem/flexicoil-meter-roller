include <Flexicoil Meter Segment.scad>

flute_depth = 3; //not ideal, since we also have this in the included scad file

module percent_width_segment(start, end) {
	width = end - start;

	translate([0,0,-segment_width * start / 100])
		intersection() {
			extra_fine_fluted(spiral = true);
			translate([0,0,segment_width * start / 100])
				cylinder(segment_width * width / 100,50,50);
		}

}

module chamferred_percent_width_segment(start, end) {
	chamfer_up = tan(20) * flute_depth;
	width = end - start + chamfer_up;

	difference() {
		translate([0,0,-segment_width * start / 100])
			intersection() {
				extra_fine_fluted(spiral = true);
				translate([0,0,segment_width * start / 100 - chamfer_up])
					cylinder(segment_width * width / 100 + chamfer_up ,50,50);
			}
		print_chamfer();
	}
}

module print_chamfer() {
	rotate_extrude() {
		polygon( points = [[segment_diameter_tight / 2 + 1,0.364], [segment_diameter_tight /2.0 + 1, -7.28],
				   [segment_diameter_tight / 2 - 20, -7.28]]);

	}
}

module chamfered_blank(width) {
	chamfer_up = tan(20) * flute_depth;

	translate([0,0,-chamfer_up])
		difference() {
			//flute depth is 3 in this case

			blank(width + chamfer_up);
			translate([0,0,chamfer_up])
				print_chamfer();
		}
}

union() {
	blank(segment_width / 4);
	translate([0,0,segment_width / 4])
		percent_width_segment(0,25);
	translate([0,0,segment_width / 4 * 2])
		chamferred_percent_width_segment(75,100);
	translate([0,0,segment_width / 4 * 3])
		chamfered_blank(segment_width / 4);
}
