/****************************************************
 * General dimensions, including printing tolerance *
 ****************************************************/
//units
inches = 25.4; //mm

//common variables to all segment types

tolerance = 0.2; //mm add to hex width (enlarge hole)
bearing_tolerance = 0; //mm
segment_width = 80.15; //mm
segment_diameter = 79.5; //mm
segment_diameter_tight = 85.5; //mm
divider_width = 3; //mm

extra_fine_flute_depth = 3; //mm

//when extruding and rotating, number of steps. More is smoother
//but takes longer to generate.
slices = 40; 

//hex should be 1.125" across, flat to flat.
hex_radius = 1.125 * inches;

//calculate size of hex hole to print.  Circle circumsribes the 
//hexagon, so we adjust the radius by dividing by cos(30) so that 
//the actual width between flats is what we want.  Also we add width
//to account for the printer's tolerances
hex_radius_cylinder = (hex_radius / 2  + tolerance / 2) / cos(30);

