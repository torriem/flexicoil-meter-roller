include <dimensions.scad>

$fn=100;

difference() {
	union() {
		linear_extrude(9.525) {
			hull() {
				translate( [44.45, 0] ) {
					circle(6);
				}
				circle(18.5);
			}
		}
		cylinder( 19, 18.5, 18.5);
	}	
	cylinder( 19, 12.7, 12.7);

	translate( [44.45, 0, 0] ) {
		union() {
			cylinder(10,2.5,2.5);
			cylinder(3,4,4,$fn=6);
		}
	}

	translate([0,0,9.5]) {
		rotate([90,0,0]) {
			cylinder(50,3.175, 3.175, center=true);
		}
	}

}


