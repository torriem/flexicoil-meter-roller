include <dimensions.scad>

$fn=100;

difference() {
	cylinder(30,20,20);
	cylinder(30, hex_radius_cylinder, hex_radius_cylinder, $fn=6);
}
