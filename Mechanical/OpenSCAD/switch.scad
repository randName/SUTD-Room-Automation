$fn=100;

use <servo.scad>

module switch_plate(shell=false)
{
	if(shell)
	{ translate([0,0,4]) cube([85,86.4,8],center=true); }
	translate([0,0,4]) intersection()
	{
		cube([85,85,8],center=true);
		translate([0,0,-296]) rotate([0,90,0])
			cylinder(r=300,h=90,center=true);
	}
	translate([0,0,10]) difference()
	{
		for(i=[-1,1]) translate([14*i,0,0]) cube([27,55,8],center=true);
		translate([0,0,298]) rotate([0,90,0])
			cylinder(r=300,h=80,center=true);
	}
}

difference()
{
	translate([33,0,2]) cube([30,95,4],center=true);
	translate([0,0,-0.01]) switch_plate(true);
}
% switch_plate();

translate([47,5.5,8.5]) difference()
{
	cube([8,33,17],center=true);
	translate([-10,0,6]) rotate([-90,180,90]){ % 9g_servo(); 9g_servo(true); }
	translate([2,0,6]) cube([5,35,10],center=true);
}