/****************************************************
 * General dimensions, including printing tolerance *
 ****************************************************/
//units
inches = 25.4; //mm

//common variables to all segment types

//hex tolerances:
//tpu = 0.1
//petg = 0.4
//abs with 1% shrink profile = 0.2
segment_tolerance = 0.1; //mm add to hex width (enlarge hole)
bushing_tolerance = 0.2;

//for ABS, inner tolerance -0.2, outer tolerance 0.2
//for PETG, inner tolerance -0.1, outer tolerance 0.2
bearing_inner_tolerance = -0.2; //smaller for tighter fit
bearing_outer_tolerance = 0.15; //smaller for tighter fit

segment_width = 80.45; //mm
segment_diameter = 79.5; //mm
segment_diameter_tight = 85.5; //mm
divider_width = 3; //mm

extra_fine_flute_depth = 3; //mm

//when extruding and rotating, number of steps. More is smoother
//but takes longer to generate.
slices = 40; 

//hex should be 1.125" across, flat to flat.
hex_width = 1.125 * inches;

//calculate size of hex hole to print.  Circle circumsribes the 
//hexagon, so we adjust the radius by dividing by cos(30) so that 
//the actual width between flats is what we want.  Also we add width
//to account for the printer's tolerances
segment_hex_radius_cylinder = (hex_width / 2  + segment_tolerance / 2) / cos(30);
bushing_hex_radius_cylinder = (hex_width / 2  + bushing_tolerance / 2) / cos(30);

oring_hex_width = 1.25 * inches;
oring_hex_radius_cylinder = (oring_hex_width / 2  + bushing_tolerance / 2) / cos(30);


