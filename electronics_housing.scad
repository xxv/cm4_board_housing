use <shapes.scad>


$fa=0.5;
$fs=0.5;

standoff_height = 2.5;

m2_heatset_depth = 3.3;
m2_heatset_dia = 3.25;
m2_standoff_wall = 1;

m3_heatset_depth = 4.5;
m3_heatset_dia = 4;

m4_heatset_depth = 5.5;
m4_heatset_dia = 5.6;

housing_screw_head_dia = 6.2; // m3
housing_screw_hole_dia = 3.3; // m3
housing_screw_inset = 6;
housing_screw_body_dia = 26;

interior = [132, 120, 25];
radius = 5;

housing_wall = 2;
baseplate_thickness = 4;

cm4_hole_spacing = [104, 104];
cm4_hole_margin = [3, 3];

cm4_mount_holes = [
  cm4_hole_margin,
  cm4_hole_margin + [cm4_hole_spacing.x, 0],
  cm4_hole_margin + [0, cm4_hole_spacing.y],
  cm4_hole_margin + cm4_hole_spacing,
  ];

cm4_rotation = 0;
cm4_position = [11, 0];
cm4_bounds = [110, 110, 20];
cm4_standoff_depth = standoff_height;
cm4_standoff_dia = 1.5;
cm4_standoff_wall = 1.7;


exterior = interior + [housing_wall * 2, housing_wall * 2, baseplate_thickness];

smidge = 0.01;

function in_to_mm(in) = 25.4 * in;

module housing_top() {
  difference() {
    rounded_cube(exterior, radius + housing_wall);

    difference() {
      translate([housing_wall, housing_wall, -smidge])
        rounded_cube(interior + [0, 0, smidge], radius);

      translate([exterior.x/2, exterior.y/2, standoff_height])
        for (y=[-1, 1])
          for (x=[-1, 1])
              translate([exterior.x/2 * x, exterior.y/2 * y])
                cylinder(d=housing_screw_body_dia, h=exterior.z);
    }

    translate([housing_screw_body_dia/2, housing_wall +  smidge, housing_wall])
      rotate([90, 0, 0])
      linear_extrude(height=housing_wall + smidge * 2)
        port_cutouts_2d();

    translate([-5, 97.5, 7])
    rotate([90, 0, 90])
      cylinder(d=10, h=20);

    *for (y=[0, interior.y + housing_wall])
      translate([housing_screw_body_dia/2, y + housing_wall + smidge, housing_wall])
        rotate([90, 0, 0])
          vent_holes([exterior.x - housing_screw_body_dia, interior.z - housing_wall, housing_wall + smidge * 2]);


    // mounting screw holes
    translate([exterior.x/2, exterior.y/2, baseplate_thickness])
      for (y=[-1, 1])
        for (x=[-1, 1])
            translate([exterior.x/2 * x - housing_screw_inset * x,
                       exterior.y/2 * y - housing_screw_inset * y, standoff_height]) {
              cylinder(d=housing_screw_head_dia, h=exterior.z);
              translate([0, 0, -baseplate_thickness - smidge])
                cylinder(d=housing_screw_hole_dia, h=exterior.z);
            }
  }
}

module port_cutouts_2d() {
  // USB-C
  translate([5.5, 1.8])
    square([10, 4]);

  // HDMI
  translate([18.5, 2.4])
    square([16, 6.5]);

  // USB BEEES
  translate([39, 2])
    square([15, 16.4]);

  translate([57, 2])
    square([15, 16.4]);

  // Ethernet
  translate([74, 1.5])
    square([17, 14.5]);

  // Barrel jack power
  translate([93.5, 1.8])
    square([10, 12]);
}

module rotate_around_center(angle, bounds) {
  translate([bounds.x/2, bounds.y/2, 0])
  rotate(angle)
  translate([-bounds.x/2, -bounds.y/2, 0])
    children();
    }

module housing_top_base_form() {
  difference() {
    rounded_cube(exterior, radius + housing_wall);

    translate([housing_wall, housing_wall, -smidge])
      rounded_cube(interior + [0, 0, smidge], radius);
  }
}

module housing_bottom() {
  difference() {
    union() {
      rounded_cube([interior.x, interior.y, 0] + [housing_wall * 2, housing_wall * 2, baseplate_thickness], radius + housing_wall);

      translate([housing_wall, housing_wall, baseplate_thickness]) {
        translate(cm4_position)
        rotate_around_center(cm4_rotation, cm4_bounds)
          cm4_standoffs();

      }

    // mounting screw holes
    translate([exterior.x/2, exterior.y/2, baseplate_thickness])
      for (y=[-1, 1])
        for (x=[-1, 1])
            translate([exterior.x/2 * x - housing_screw_inset * x,
                       exterior.y/2 * y - housing_screw_inset * y])
              cylinder(d=m3_heatset_dia + housing_wall * 2, h=standoff_height);
    }

    translate([0, 0, baseplate_thickness])
      housing_top_base_form();

    translate([housing_wall, housing_wall, -smidge]) {

      translate(cm4_position)
        rotate_around_center(cm4_rotation, cm4_bounds)
          for (pos = cm4_mount_holes)
            translate(pos)
              cylinder(d=cm4_standoff_dia, h=baseplate_thickness + cm4_standoff_depth);

    }

    // mounting screw holes
    translate([exterior.x/2, exterior.y/2, -smidge]) {
      for (y=[-1, 1])
        for (x=[-1, 1])
            translate([exterior.x/2 * x - housing_screw_inset * x,
                       exterior.y/2 * y - housing_screw_inset * y])
              cylinder(d=m3_heatset_dia, h=exterior.z);

    }
  }
}

module mounting_bracket() {
  size = [in_to_mm(4.0), 16, m4_heatset_depth];
  hole_spacing = in_to_mm(3.5);
  hole_dia = 5;

  translate(-size/2)
      difference() {
        rounded_cube(size, size.y/2 - smidge);

        translate([size.x/2, size.y/2, -smidge])
          rotate(0) {
            for (x=[-1, 1])
              translate([x * hole_spacing/2, 0]) {
                cylinder(d=hole_dia, h=size.z + smidge * 2);
                translate([0, 0, size.z/2])
                  cylinder(d1=hole_dia, d2=hole_dia * 2, h=size.z/2 + smidge * 2);
              }

          cylinder(d=m4_heatset_dia, h=size.z + smidge * 2);
        }
      }
}

// size is [x, y, depth] laid out on the x/y plane
module vent_holes(size) {
  hole_size = 3;
  hole_rough_spacing = 3;
  y_scale = 0.5;

  raw_spacing = (hole_size * sqrt(2)) + hole_rough_spacing;
  spacing = size.x/floor(size.x / raw_spacing);

  intersection() {
    cube(size);
    for (y = [0 : floor(size.y/(spacing * y_scale))])
      for (x = [0 : floor(size.x/spacing) + 1])
        translate([x * spacing + (y % 2 == 0 ? spacing/2 : 0), y * spacing * y_scale])
          rotate([0, 0, 45])
            cube([hole_size, hole_size, size.z]);
  }
}

module cm4_standoffs() {
  for (pos = cm4_mount_holes)
    translate(pos)
      standoff(cm4_standoff_depth, cm4_standoff_dia, cm4_standoff_wall);

  *%translate([0, 0, standoff_height])
    cube(cm4_bounds);
}

module standoff(depth, id, wall=2) {
  linear_extrude(height=depth)
    difference() {
      circle(d=id + wall * 2);
      circle(d=id);
    }
}

module m4_socket_screw(length) {
  cylinder(d=7, h=4);
  translate([0, 0, -length])
    cylinder(d=4, h=length);
}
