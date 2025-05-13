/****************************************************
 * General dimensions, including printing tolerance *
 ****************************************************/
//units
inches = 25.4; //mm

//common variables to all segment types

tolerance = 0.2; //add to hex width
bearing_tolerance = 0;
segment_width = 80.15; //mm
segment_diameter = 79.5; //mm
segment_diameter_tight = 85.5; //mm
divider_width = 3; //in mm

//when extruding and rotating, number of steps. More is smoother
//but takes longer to generate.
slices = 40; 

//hex should be 1.125" across, flat to flat.
hex_radius = 1.125;

//calculate size of hex hole to print.  Circle circumsribes the 
//hexagon, so we adjust the radius by dividing by cos(30) so that 
//the actual width between flats is what we want.  Also we add width
//to account for the printer's tolerances
hex_radius_cylinder = (1.125 * 25.4 / 2  + tolerance / 2) / cos(30);

