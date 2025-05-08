include <dimensions.scad>

//make cylinders smoother
$fn=100;

module blank(segment_width = segment_width) {
    difference() {
        cylinder(segment_width, segment_diameter/2, segment_diameter/2);
        cylinder(segment_width+1,hex_radius_cylinder,hex_radius_cylinder,$fn=6);
        
    }
}

module extra_fine(segment_width = segment_width, spiral = true, divider = false, divider_width = 3) {
    //extra fine roller
    num_flutes = 15;
    scallop_width = 13.5;
    scallop_depth = 3;
    
    if (divider) {
        union() {
            create_extra_fine();
            blank(divider_width);
        }
    } else {
        create_extra_fine();
    }

    module create_extra_fine() {
		difference() {
			linear_extrude(segment_width,twist=(spiral ? 360/num_flutes/2 : 0), slices=slices) {
				rounded_flutes(segment_diameter/2, num_flutes=num_flutes, 
							   width=scallop_width, depth=scallop_depth);
			}
			cylinder(segment_width+1,hex_radius_cylinder,hex_radius_cylinder,$fn=6);
		}
	}
}

module coarse(segment_width = segment_width, spiral = true, twist = 36, divider = false, divider_width = 3) {
    num_flutes = 10;
    root_width = 9;
    tip_width = 3;
    inner_diameter = 51;

    if (divider) {
        union() {
            create_coarse();
            blank(divider_width);
        }
    } else {
        create_coarse();
    }

    module create_coarse() {
        difference() {
            linear_extrude(segment_width,twist=(spiral ? twist : 0), slices=slices) {
                angled_flutes(segment_diameter / 2, inner_diameter /2, num_flutes, root_width, tip_width);
            }
            cylinder(segment_width+1,hex_radius_cylinder,hex_radius_cylinder,$fn=6);
        }
    }
}

module extra_coarse(segment_width = segment_width, spiral = true, twist = 36, divider = false, divider_width = 3) {
    num_flutes = 6;
    root_width = 10;
    tip_width = 3;
    inner_diameter = 44;
    
    if (divider) {
        union() {
            create_extra_course();
            blank(divider_width);
        }
    } else {
        create_extra_course();
    }

    module create_extra_course() {
        difference() {
            linear_extrude(segment_width,twist=(spiral ? twist : 0),slices=slices) {
                angled_flutes(segment_diameter / 2, inner_diameter / 2, num_flutes, root_width, tip_width);
            }
            cylinder(segment_width+1,hex_radius_cylinder,hex_radius_cylinder,$fn=6);
        }
    }
}

module fine(segment_width = segment_width, spiral = true, divider = false, divider_width = 3) {
    num_flutes = 10;
    root_width = 8;
    tip_width = 6;
    inner_diameter = 63.5;

    if (divider) {
        union() {
            create_fine();
            blank(divider_width);
        }
    } else {
        create_fine();
    }

	module create_fine() {
		difference() {
			linear_extrude(segment_width,twist=(spiral ? 360/num_flutes : 0),slices=slices,convexity=10) {
				angled_flutes(segment_diameter / 2, inner_diameter / 2, num_flutes, root_width, tip_width);
			}
			cylinder(segment_width+1,hex_radius_cylinder,hex_radius_cylinder,$fn=6);
		}
	}
}

/***********************
 * 2d profile creators *
 ***********************/

module rounded_flutes(segment_radius, num_flutes, width, depth) {

    //Calculate the position and radius of the cutout to create the pocket.
    //This is based on how wide the pocket should be (linear measurement peak
    //edge to peak edge across the pocket), and the depth of the pocket from
    //the outer radius of the segment, down to the bottom of the pocket.
    
    bigchordlength = segment_radius - sqrt(segment_radius^2 - (width / 2) ^ 2);
    //echo(bigchordlength);
    fluteradius = ((width / 2)^2 + (depth - bigchordlength)^2) / (2 * depth - bigchordlength * 2);
    //echo (fluteradius);
    flutelocation = segment_radius + fluteradius - depth;
    
    
    difference() {
        circle(segment_radius);
        //cylinder(80,79/2,79/2, true);
   
        for(fi = [0 : num_flutes-1]) {
            rotate([0,0,360/num_flutes * fi])
                translate([flutelocation,0,0])
                    circle(fluteradius);
                    //cylinder(80+1,fluteradius, fluteradius,true);
        
        }
    }
}

module angled_flutes(segment_radius, inner_radius, num_flutes, root_width, tip_width) {
    root_distance_from_circle = inner_radius - sqrt(inner_radius^2 - (root_width / 2) ^ 2);
    
    root_distance = inner_radius - (inner_radius - sqrt(inner_radius^2 - (root_width / 2) ^ 2));
    echo (root_distance, inner_radius);
    echo (segment_radius - root_distance);
    //echo ( ((tip_width / 2) - (root_width / 2)) / (segment_radius - root_distance));

    //y=mx+b, x = (y-b)/m
    slope = ((tip_width / 2) - (root_width / 2)) / (segment_radius - root_distance);
    b = root_width / 2 - slope * root_distance;
    
    triangle_point = -b / slope;
        
    //echo (slope, b, triangle_point);
    
    intersection() {
        union () {
            circle(inner_radius);
            for(fi = [0 : num_flutes-1]) {
                rotate([0,0,360/num_flutes * fi])
                    polygon([[root_distance, root_width /2],
                             [root_distance, -root_width /2],
                             [triangle_point, 0]]);
            }
        }
        circle(segment_radius);
    } 
}
