include <dimensions.scad>

$fn=100;

union() {
	//basic shape, imported from a dxf designed in
	//FreeCAD
	rotate_extrude() {
		import("Bearing endcap-Sketch.dxf");
	}

	//add small sealing surface to keep dust out
	//similar to OEM part
	rotate_extrude() {
		translate([16.75, 5.5]) {
			circle(4.25);
		}
	}
}
