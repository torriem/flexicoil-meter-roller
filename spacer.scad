include <dimensions.scad>

bearing_tolerance = 0;
$fn = 100;

	spacer(width = 2.5 * inches, nub = true);

module spacer(width = 2.5 * inches, nub = true, nub_position = -1) {

	difference() {
		make_spacer_and_nub();
		translate([0,0,11/16*inches])
			chamfer();
	}
	//make_nub(0);

	module chamfer() {
		translate([0,0,-6.1739])
			rotate_extrude()
				translate([33,0,0])
					rotate([0,0,45])
						square([11/32*inches,11/32 *inches]);

	}

	module make_nub(position)
		translate([85/2-1,0,position])
			union() {
				translate([0,0,-4])
						rotate([90,0,0])
							linear_extrude(8, center = true)
								polygon( points = [ [0,0], [10,0], [0,-5] ]);
								
				translate([5,0,0])
					cube([10,8,8],center=true);
			}

	module make_spacer() {
		difference() {
			//outer
			cylinder (width, 86 / 2, 86 / 2);
			//inner
			cylinder (width, 74 / 2, 74/2);

			//bottom bearing
			cylinder (11/16 * 25.4, (80 + bearing_tolerance)/ 2, (80 + bearing_tolerance) / 2);
			
			//top bearing
			translate([0,0, width - 11/16 * inches])
				cylinder (11/16 * 25.4, (80 - bearing_tolerance)/ 2, (80 - bearing_tolerance) / 2);
		}
	}

	module make_spacer_and_nub() {
		if (nub) {
			union() {
				make_spacer();
				if (nub_position == -1) {
					make_nub(width / 2); //put it in the middle
				} else {
					make_nub(nub_position);
				}
			}
		} else {
			make_spacer();
		}
	}
}
