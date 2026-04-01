include <dimensions.scad>

$fn=100;

difference() {
	//basic shape
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

	//1" shaft hole
	cylinder( 19, 12.7, 12.7);

	//5mm hole with hex pocket for nut for the
	//cam bearing
	translate( [44.45, 0, 0] ) {
		union() {
			cylinder(10,2.5,2.5);
			translate([0,0,6.525]) {
				rotate([0,0,30]) {
					cylinder(3,4,4,$fn=6);
				}
			}
		}
	}

	//screw hole for attaching label
	translate( [1.125 * inches,0,0] ) {
		cylinder(10,2,2);
	}

	//0.25" hole for the roll pin
	translate([0,0,9.5]) {
		rotate([90,0,0]) {
			cylinder(50,3.175, 3.175, center=true);
		}
	}
}


