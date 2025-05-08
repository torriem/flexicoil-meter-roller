include <Flexicoil Meter Segment.scad>

//demo of various meter roller segment generators.  See each module
//below for various variables to adjust for different sizes and shapes.
//It's also easy to change the width of each segment to make smaller
//extremely fine rollers for example.

//for whatever reason extra_course doesn't want to render here, but
//without the translate it does render, so I guess this file is for
//demonstration purposes only.

translate( [-54, 54, 0])
    extra_fine(spiral = true, divider = true, divider_width = 53);

translate( [54, 54, 0])
    coarse(spiral = true);

translate( [-54, -54, 0])
    extra_coarse(spiral = true, divider=true);

translate( [54, -54, 0])
    fine(spiral = false);
    
translate( [0, 160, 0])
    blank(segment_width=50);


