include <electronics_housing.scad>

mockup();


module mockup() {
    translate([-exterior.x/2, -exterior.y/2, 0]) {

  translate([cm4_position.x, cm4_position.y, 0] + [2, 2, baseplate_thickness + cm4_standoff_depth])
  cm4_board();
    *housing_bottom();
    color("red")
      translate([0, 0, baseplate_thickness])
        housing_top();

    }
  }

module cm4_board() {
  color("purple")
    translate([110/2, 110/2, 0])
    rotate([0, 0, -90])
    translate([-110/2, -110/2, 0])
    translate([-85.4, 145.7, -0.2])
      import("cm4_board.stl");
}