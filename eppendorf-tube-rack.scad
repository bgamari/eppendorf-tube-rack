use <MCAD/boxes.scad>

inch = 25.4;
tube_a_diam = 0.44 * inch;
tube_b_diam = 0.32 * inch;
tube_spacing = 1.3 * tube_a_diam;
ncols = 10;
nrows = 6;
rack_h = 1*inch;
border = 0.2*inch;
text_h = 1;

module tube_grid(spacing, tube_diam, nrows, ncols) {
    translate([spacing/2, spacing/2, 2])
    for (i = [0:ncols-1])
    for (j = [0:nrows-1])
    translate([i*spacing, j*spacing, 0])
    cylinder(r=tube_diam/2, h=2*rack_h);

    translate([0, 0, rack_h]) {
	// Column labels
	for (i = [0:ncols-1])
	translate([(i+0.8)*spacing, 0, 0])
	linear_extrude(2*text_h, center=true)
	scale(0.4) text(text=str(i));

	// Row labels
	for (i = [0:nrows-1])
	translate([0, i*spacing, 0])
	linear_extrude(2*text_h, center=true)
	scale(0.4) text(text=chr(65+i));
    }
}
    
module rack(ncols, nrows, height) {
    body_size = [2*border + ncols*tube_spacing, 2*border + nrows*tube_spacing, height];
    difference() {
	union() {
	    //cube(body_size);
	    translate(body_size/2) roundedBox(body_size, 4, false);

	    scale([-1, 1, 1])
	    translate([-5, 0, rack_h/2])
	    rotate([-90,0,0]) linear_extrude(body_size[1]) handle_profile(15);

	    translate([body_size[0]-5, 0, rack_h/2])
	    rotate([-90,0,0]) linear_extrude(body_size[1]) handle_profile(15);
	}

	translate([border, border, 0])
	tube_grid(tube_spacing, tube_a_diam, nrows, ncols);

	translate([0, body_size[1], rack_h])
	rotate([180, 0, 0])
	translate([border + tube_spacing/2, border + tube_spacing/2, 0])
	tube_grid(tube_spacing, tube_b_diam, nrows-1, ncols-1);
    }
}

module handle_profile(size) {
    translate([size/2, 0])
    difference() {
	square([size, size], center=true);
	translate([size/3, 0])
	for (i = [1, -1]) {
	    translate([0, i*0.6*size])
	    circle(size/2);
	}
    }
}

rack(ncols, nrows, rack_h, $fn=24);
//handle_profile(15);
