use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
use <hggh/tp4056_breakout_holder.scad>


BOX_SIZE_X = 55;
BOX_SIZE_Y = 50;
BOX_SIZE_Z = 30;

module box() {
    difference() {
        union() {
            cube([BOX_SIZE_X, BOX_SIZE_Y, BOX_SIZE_Z], center=true);
            translate([0, -25, 5]) {
                roundtop();
            }
        }
        // usb connector
        translate([BOX_SIZE_X/2 -20, BOX_SIZE_Y/2 -0.2 , -2.2]) {
            rotate([90, 0, 0]) cube([80, 8, 4.2]);
        }
        translate([-5, -10, -10]) {
            cube([30.5, 14.5, 30], center=true);
        }
        translate([20,-10,0]) {
            cylinder(d=8, h=80, center=true, $fn=80);
        }
        // spare out inner part
        translate([0, 0, 2]) {
            cube([52.6, 47.6, 31], center=true);
        }
    }      
}



module roundtop() {
    difference() {
        cylinder(d=35, h=3, $fn=80);
        translate([-5, 0, 0]) {
            cube([10, 10, 4]);
        }
        translate([0, 0, -1]) {
            cylinder(d=30, h=5, $fn=80);
        }
    }
}

union() {
    box();
    translate([BOX_SIZE_X/2 - 1.2, BOX_SIZE_Y/2 - 5, -8.5]) {
        rotate([90, 0, 180]) tp4056_breakout_holder();
    }
    translate([-BOX_SIZE_X/2, - BOX_SIZE_Y/2, BOX_SIZE_Z/2 -1.2]) {
        cube([BOX_SIZE_X, 5, 1.2]);
    }
    // halteschienen
    translate([BOX_SIZE_X/2 - 2.4, -15, BOX_SIZE_Z/2 -2.4]) {
        cube([1.2, 30, 1.2]);
    }
    translate([- BOX_SIZE_X/2 + 1.2, -15, BOX_SIZE_Z/2 -2.4]) {
        cube([1.2, 30, 1.2]);
    }
    translate([- BOX_SIZE_X/2 +9.5 +1.2 +0.4 , BOX_SIZE_Y/2 -1.2 -1, BOX_SIZE_Z/2 -0.6]) {
        difference() {
            cuboid([7, 3, 1.2]);
            translate([0, 0, 0]) {
                cuboid([4.5, 4, 5]);
            }
        }
        
    }
}

translate([- BOX_SIZE_X/2 + 1.2, - BOX_SIZE_Y/2 +5, 50]) {
    LID_SIZE_X = BOX_SIZE_X - 1.2 - 1.2 - 0.2;
    LID_SIZE_Y = BOX_SIZE_Y -5 - 1.2 - 0.4;
    difference() {
        cube([LID_SIZE_X, LID_SIZE_Y, 1.2]);
        translate([10, LID_SIZE_Y -1.6 , 0]) {
            cuboid([8, 8, 3]);
        }
    }
    // Nase
    translate([5, -2.5, -1.2]) { 
        cube([LID_SIZE_X - 10,  5, 1.2]);
    }
    
    translate([10, LID_SIZE_Y -4.1, 0.1]) {
        rotate([180,0,-90]) {
            lid_conn();
        }
    }
}





module lid_conn() {
    difference() {
        union() {
            translate([0,6/2,7.5]) rotate([90,0,0]) cylinder(h=6, d=3.5, $fn=100);
            prismoid(size1=[4.8,6], size2=[3.5,6], h=7.5);
        }
        union() {
            translate([0,6,7.5]) rotate([90,0,0]) cylinder(h=12, d=2, $fn=100);
            down(0.1) prismoid(size1=[3,12], size2=[2,12], h=7.5);
        }
    }
    translate([-2.79, 0, -0.55]) cuboid([2.6, 4, 1.1]);
}