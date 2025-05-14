/*
 * Library to create 3D-printable Flexicoil meter roller segments
 * Copyright 2025 Michael Torrie
 * 
 * Licensed under the terms of the GPLv3
 */

include <dimensions.scad>

//make cylinders smoother
$fn=100;

module bottom_chamfer(diameter) {
	rotate_extrude() {
		polygon( points = [[diameter / 2 + 1,0.364], [diameter /2.0 + 1, -7.28],
				   [diameter / 2 - 20, -7.28]]);
	}
}

module top_chamfer(diameter) {
	rotate_extrude() {
		polygon( points = [[diameter / 2 + 1,-0.364], [diameter /2.0 + 1, 7.28],
				   [diameter / 2 - 20, 7.28]]);
	}
}

module segment_part(segment_width = segment_width, segment_diameter = segment_diameter, start_percent=0, end_percent=0, bottom_chamfer = 0, top_chamfer = 0) {
	/* renders a specific part of a segment, defined by a start 
	   and end percent of the segment's width.  Additionally can
	   apply a chamfer to the top and/or bottom outside edges,
	   defined by the inner radius of the bevel (always a 20
	   degree chamfer).
	*/

	//calculate how far into the segment to cut the chamfer bevel
	chamfer_up = tan(20) * bottom_chamfer;
	chamfer_down = tan(20) * top_chamfer;

	//do a bottom chamfer if requested and if there's room below 
	//the start_percent to apply it
	do_bottom_chamfer = (bottom_chamfer>0 && (start_percent * segment_width / 100) >= chamfer_up ? true : false);

	//do a top chamfer if requested and if there's room above the cut
	do_top_chamfer = (top_chamfer>0 && (end_percent * segment_width / 100 + chamfer_down) < segment_width ? true : false);

	//flag to indicate whether we will be doing any cuts at all
	do_cut = (end_percent > start_percent ? true : false);
	cut_width = (end_percent-start_percent) * segment_width / 100;

	//calculate the start slice
	start = (do_cut 
	             ? (do_bottom_chamfer 
				       ? start_percent * segment_width / 100 - chamfer_up 
					   : start_percent * segment_width / 100)
			     : 0);

	//calculate the end slice
	end = (do_cut
	           ? (do_top_chamfer
			            ? end_percent * segment_width / 100 + chamfer_down
						: end_percent * segment_width / 100)
			   : segment_width);

	if (do_cut) {
		difference() {
			//cut the segment to get the piece we want
			make_segment_part() children();

			//apply the chamfer bevels
			if (do_bottom_chamfer) {
				bottom_chamfer(segment_diameter);
			}
			if (do_top_chamfer) {
				echo ("hmmm");
				translate([0,0,cut_width])
					top_chamfer(segment_diameter);
			}
		}
	} else {
		//we're not cutting anything, return the entire
		//segment
		children();
	}

	module make_segment_part() {
		//get the part of the segment by intersecting
		//the segment with a cylinder
		translate([0,0,-start-(do_bottom_chamfer ? chamfer_up : 0)]) {
			intersection() {
				children();
				translate([0,0,start])
					cylinder(end-start,100,100);
			}
		}
	}
}


module blank(segment_width = segment_width, segment_diameter = segment_diameter_tight) {
	difference() {
		cylinder(segment_width, segment_diameter/2, segment_diameter/2);
		cylinder(segment_width+1,hex_radius_cylinder,hex_radius_cylinder,$fn=6);
	}
}

module extra_fine_fluted(segment_width = segment_width, 
                         spiral = true, 
						 divider = false, divider_width = 3, 
						 flute_depth = 3) {
	//alternate extra fine roller with angled flutes instead of scallops
	num_flutes = 15;
	root_width = 5;
	tip_width = 3;
	inner_diameter = segment_diameter_tight - flute_depth*2;
	//assume larger diameter

    if (divider) {
        union() {
            create_extra_fine();
            blank(divider_width);
        }
    } else {
       	create_extra_fine(segment_width);
    }

    module create_extra_fine(width = segment_width, start=0, end=segment_width) {

		difference() {
			linear_extrude(width,twist=(spiral ? 360/num_flutes : 0),slices=slices,convexity=10) {
				angled_flutes(segment_diameter_tight / 2, inner_diameter / 2, num_flutes, root_width, tip_width);
			}
			cylinder(width+1,hex_radius_cylinder,hex_radius_cylinder,$fn=6);
		}
	}
}

module extra_fine(segment_width = segment_width, 
                  spiral = true, 
				  divider = false, 
				  divider_width = 3,
				  scallop_depth = 3) {
    //extra fine roller
    num_flutes = 15;
    scallop_width = 13.5;
	//assume larger diameter
    
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
				rounded_flutes(segment_diameter_tight/2, num_flutes=num_flutes, 
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
    //echo (root_distance, inner_radius);
    //echo (segment_radius - root_distance);
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
