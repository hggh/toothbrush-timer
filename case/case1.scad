
difference() {
    union() {
        cube([55, 50, 30], center=true);
        translate([0, -25, 7]) {
            roundtop();
        }
    }
    translate([-5, -10, -10]) {
        cube([30.5, 14.5, 30], center=true);
    }
    translate([20,-10,0]) {
        cylinder(d=8, h=80, center=true, $fn=80);
    }

    // spare out inner part
    cube([52.6, 47.6, 27.6], center=true);
    
    // spare out back side to load battery
    translate([- 26.3, -15, 13]) {
        cube([52.6,, 35, 5]);
    }
}



module roundtop() {
    difference() {
        cylinder(d=10, h=3, $fn=80);
        translate([-5, 0, 0]) {
            cube([10, 10, 4]);
        }
        cylinder(d=5, h=3, $fn=80);
    }
}