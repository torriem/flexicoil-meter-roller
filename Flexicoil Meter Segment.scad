/*
 * Library to create 3D-printable Flexicoil meter roller segments
 * Copyright 2025 Michael Torrie
 * 
 * Licensed under the terms of the GPLv3
 */

include <dimensions.scad>

//make cylinders smoother
$fn=100;

module
shaft_spacer(length) {
	difference()
	{
		cylinder(length, bushing_hex_radius_cylinder + 6, bushing_hex_radius_cylinder + 6, $fn=6);
		cylinder(length, bushing_hex_radius_cylinder + 1, bushing_hex_radius_cylinder + 1, $fn=6);
	}
}

module bearing_bushing() {
	difference() {
		//bottom larger diameter part, plus body that goes inside bearing
		union() {
			cylinder (6, 57/2, 57/2);
			translate( [0,0,6] ) {
				cylinder (16, 25 - bearing_inner_tolerance / 2, 25 - bearing_inner_tolerance / 2);
			}
		}
		//hex hole to slide over shaft
		cylinder(22,bushing_hex_radius_cylinder,bushing_hex_radius_cylinder,$fn=6);
		translate([0,0,22-1.5]) {
			cylinder(1.5,oring_hex_radius_cylinder,oring_hex_radius_cylinder,$fn=6);
		}

		//chamfer top bearing surface
		translate([0,0,21.5])
			top_chamfer(50 , 45);

		//chamfer top hex hole
		translate([0,0,21]){
			rotate([180,0,0]){
				intersection()  {
					cylinder(bushing_hex_radius_cylinder+1,bushing_hex_radius_cylinder+1, 0, $fn=6);
					cylinder(5,25,25);
				}
			}
		}

		//chamfer bottom hex hole
		intersection()  {
			cylinder(bushing_hex_radius_cylinder+2,bushing_hex_radius_cylinder+2, 0, $fn=6);
			cylinder(5,25,25);
		}

	}
}

module bearing_end_bushing() {
	difference() {
		translate( [ 0,0,-3] ) {
			difference() {
				bearing_bushing();
				//beveled the bottom larger diameter part
				rotate_extrude() {
					polygon( points = [ [ 25, 3], [25+6, 3], [25+6, 6] ]);
				}
				//make the bottom part thinner
				cylinder(3, 25+6, 25+6);
			}
		}
		//groove for roll pin
		translate([0,0,2.5]) {
			rotate([0,0,90]) {
				rotate([0,90,0]) {
					cylinder(60, 2.5, 2.5, center=true);
					translate([2.5,0,0]) {
						cube([5,5,60], center=true);
					}
				}
			}
		}
	}
}

module spacer(width = 2.5 * inches, nub = true, nub_width = 0) {

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

	module make_nub(height) {
		difference() {
			translate( [0,0,width/2] ) {
				linear_extrude(height, center=true) {
					polygon( points = [ [85/2-2,10], [85/2 + 12, 6], [85/2 + 12, -6], [85/2-2,-10] ] );

				}
			}

			//confusing variable names I know.  width is actually total height of spacer
			//if the nub doesn't reach to the build plate, chamfer the underside for 3D
			//printing.
			if (height < width) {
				rotate_extrude() {
					offset = (width - height) / 2;
					polygon( points = [ [85/2,offset], [85/2 + 14,offset], [85/2+14,offset + 5] ]);
				}
			}
		}
	}

	module make_spacer() {
		difference() {
			//outer
			cylinder (width, segment_diameter_tight / 2, segment_diameter_tight / 2);
			//inner
			cylinder (width, segment_diameter_tight / 2 - 6, segment_diameter_tight / 2 - 6);

			//bottom bearing
			cylinder (11/16 * 25.4, (80 + bearing_outer_tolerance)/ 2, (80 + bearing_outer_tolerance) / 2);
			
			//top bearing
			translate([0,0, width - 11/16 * inches])
				cylinder (11/16 * 25.4, (80 + bearing_outer_tolerance)/ 2, (80 + bearing_outer_tolerance) / 2);
		}
	}

	module make_spacer_and_nub() {
		echo (nub_width);
		if (nub_width) {
			union() {
				make_spacer();
				if (nub_width == -1) {
					make_nub(width); //put across whole length
				} else {
					make_nub(nub_width);
				}
			}
		} else {
			make_spacer();
		}
	}
}

module bottom_chamfer(diameter, chamfer_angle) {
	rotate_extrude() {
		polygon( points = [[diameter / 2 + 1,tan(chamfer_angle)], [diameter /2.0 + 1, -tan(chamfer_angle) * 20],
				   [diameter / 2 - 20, -tan(chamfer_angle) * 20]]);
	}
}

module top_chamfer(diameter, chamfer_angle) {
	rotate_extrude() {
		polygon( points = [[diameter / 2 + 1,-tan(chamfer_angle)], [diameter /2.0 + 1, tan(chamfer_angle) * 20],
				   [diameter / 2 - 20, tan(chamfer_angle) * 20]]);
	}
}

module segment_part(segment_width = segment_width, segment_diameter = segment_diameter, start_percent=0, end_percent=0, bottom_chamfer = 0, top_chamfer = 0, chamfer_angle=20) {
	/* renders a specific part of a segment, defined by a start 
	   and end percent of the segment's width.  Additionally can
	   apply a chamfer to the top and/or bottom outside edges,
	   defined by the inner radius of the bevel (always a 20
	   degree chamfer).
	*/

	//calculate how far into the segment to cut the chamfer bevel
	chamfer_up = tan(chamfer_angle) * bottom_chamfer;
	chamfer_down = tan(chamfer_angle) * top_chamfer;

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
				bottom_chamfer(segment_diameter, chamfer_angle);
			}
			if (do_top_chamfer) {
				translate([0,0,cut_width])
					top_chamfer(segment_diameter, chamfer_angle);
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

module add_divider(divide_width = divider_width, tight=false) {
	union() {
		children();
		if (!tight)
			blank(divider_width, segment_diameter=segment_diameter);
		else
			blank(divider_width);
	}
}

module extra_fine(segment_width = segment_width, 
                  spiral = true,
				  twist = 24,
				  scallop_depth = extra_fine_flute_depth) {
    //extra fine roller
    num_flutes = 15;
    scallop_width = 13.5;
	//assume larger diameter
    
	difference() {
		linear_extrude(segment_width,twist=(spiral ? twist : 0), slices=slices) {
			rounded_flutes(segment_diameter_tight/2, num_flutes=num_flutes, 
						   width=scallop_width, depth=scallop_depth);
		}
		cylinder(segment_width+1,hex_radius_cylinder,hex_radius_cylinder,$fn=6);
	}
}

module extra_fine_fluted(segment_width = segment_width, 
                         spiral = true, 
						 twist = 24,
						 flute_depth = extra_fine_flute_depth) {
	//alternate extra fine roller with angled flutes instead of scallops
	num_flutes = 15;
	root_width = 5;
	tip_width = 3;
	inner_diameter = segment_diameter_tight - flute_depth*2;
	//assume larger diameter

	difference() {
		linear_extrude(segment_width,twist=(spiral ? twist : 0),slices=slices,convexity=10) {
			angled_flutes(segment_diameter_tight / 2, inner_diameter / 2, num_flutes, root_width, tip_width);
		}
		cylinder(segment_width+1,hex_radius_cylinder,hex_radius_cylinder,$fn=6);
	}
}

module fine(segment_width = segment_width, 
            spiral = true,
			twist = 36) {
    num_flutes = 10;
    root_width = 8;
    tip_width = 6;
    inner_diameter = 63.5;

	difference() {
		linear_extrude(segment_width,twist=(spiral ? twist : 0),slices=slices,convexity=10) {
			angled_flutes(segment_diameter / 2, inner_diameter / 2, num_flutes, root_width, tip_width);
		}
		cylinder(segment_width+1,hex_radius_cylinder,hex_radius_cylinder,$fn=6);
	}
}

module coarse(segment_width = segment_width, spiral = true, twist = 36) {
    num_flutes = 10;
    root_width = 9;
    tip_width = 3;
    inner_diameter = 51;

	difference() {
		linear_extrude(segment_width,twist=(spiral ? twist : 0), slices=slices) {
			angled_flutes(segment_diameter / 2, inner_diameter /2, num_flutes, root_width, tip_width);
		}
		cylinder(segment_width+1,hex_radius_cylinder,hex_radius_cylinder,$fn=6);
	}
}

module extra_coarse(segment_width = segment_width, spiral = true, twist = 36) {
    num_flutes = 6;
    root_width = 10;
    tip_width = 3;
    inner_diameter = 44;
    
	difference() {
		linear_extrude(segment_width,twist=(spiral ? twist : 0),slices=slices) {
			angled_flutes(segment_diameter / 2, inner_diameter / 2, num_flutes, root_width, tip_width);
		}
		cylinder(segment_width+1,hex_radius_cylinder,hex_radius_cylinder,$fn=6);
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
