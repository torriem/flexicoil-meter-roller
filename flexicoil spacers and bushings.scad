include <Flexicoil Meter Segment.scad>

$fn = 100;

module spacer_print_test() {
	union() {
		//translate([0,0,22])
		//	cylinder(3, segment_diameter_tight / 2, segment_diameter_tight / 2);
		intersection() {
			cube([100,100,44], center = true);
			spacer(width = 2.5 * inches, nub = true);
		}
	}
}



translate([60,-60,0])
	bearing_end_bushing();
translate([-60,60,0])
	bearing_bushing();
//spacer_print_test();
//translate([60,60])
//	spacer(width = 2.5 * inches, nub = 0);
translate([-60,-60])
	spacer(width = 2.5 * inches, nub_width = -1);
	//spacer_print_test();

shaft_spacer(2.5*inches - 45);
