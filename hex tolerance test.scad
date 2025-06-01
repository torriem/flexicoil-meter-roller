include <dimensions.scad>

$fn=100;

difference() {
	cylinder(segment_width,20,20);
	cylinder(segment_width, hex_radius_cylinder, hex_radius_cylinder, $fn=6);
}
