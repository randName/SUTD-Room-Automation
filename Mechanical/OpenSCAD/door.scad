$fn=100;

// takes forever to render so I replaced them with the rendered STLs
// If you want the library, go to http://www.thingiverse.com/thing:3575
// The file I used is here: http://www.thingiverse.com/download:10581
// uncomment the line below and the 2 bevel_gear() lines later
//use <parametric_involute_gear_v5.0.scad>

use <servo.scad>

module door_cap_frame(padding=5)
{
	cap_r = 27.5; // radius of cap
	cap_d = 80; // distance between caps
	
	frame_w = (cap_r+padding)*2;
	frame = [cap_d+frame_w,frame_w];
	
	translate([-cap_d/2,0,0]) difference()
	{
		linear_extrude(3) difference()
		{
			square(frame,center=true);
			for(i=[-1,1]) translate([i*cap_d/2,0,0]) circle(r=cap_r);
			translate([-(cap_d+frame_w/2)/2,0,0]) square([frame_w/2,frame_w],center=true);
		}
	}
	
	translate([50,0,3]) difference()
	{
		cube([40,65,6],center=true);
		for(i=[-3,-1,1,3]) for(j=[-1.25,-1,-0.75,0.75,1,1.25]) translate([j*8,i*8,-3]) {
			cylinder(r=3.5,h=6,$fn=6,center=true);
			cylinder(r=1.5,h=20,center=true);
		}
		translate([-20,0,3]) rotate([0,45,0]) cube([4,70,4],center=true);
	}
	
	intersection()
	{
		translate([-25,0,0]) cube([50,62,50],center=true);
		difference(){ cylinder(r=32,h=19); cylinder(r=28,h=50,center=true); }
	}
}

module knob_hub(radius=20, height=20, shell=false)
{
	tab = [12.5,3,5];
	knob_r = 15.5;
	
	if ( shell )
	{
		cylinder(r=radius+0.75,h=height,$fn=6);
	}
	else
	{
		linear_extrude(height) difference()
		{
			circle(r=radius,$fn=6); circle(r=knob_r);
		}   
		for(i=(tab[1]/2+sqrt(knob_r*knob_r-(tab[0]*tab[0])/4))*[-1,1])
			translate([0,i,tab[2]/2]) cube(tab,center=true);
	}
}

gear1_teeth = 16;
gear2_teeth = 10;
axis_angle = 90;
outside_circular_pitch=800;
outside_pitch_radius1 = gear1_teeth * outside_circular_pitch / 360;
outside_pitch_radius2 = gear2_teeth * outside_circular_pitch / 360;
pitch_apex1 = outside_pitch_radius2 * sin (axis_angle) + (outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));

module knob_gear(test=false)
{
	if(test){ difference(){ cylinder(r=35,h=10); knob_hub(height=25,shell=true); } }
	else
	{	
		difference()
		{
			translate([0,0,5]) import("knob_gear_raw.stl",convexity=3);
			//bevel_gear(number_of_teeth=gear1_teeth,cone_distance=cone_distance,pressure_angle=20,outside_circular_pitch=outside_circular_pitch);
			knob_hub(height=25,shell=true);
			for(i=[-10,25]) translate([0,0,i]) cube([100,100,20],center=true);
			difference(){ cylinder(r=60,h=40,center=true); cylinder(r=35,h=50,center=true); }
		}
	}
}

module servo_gear(test=false)
{
	if(test){ cylinder(r=24,h=5); }
	else
	{
		difference()
		{
			union(){ import("servo_gear_raw.stl",convexity=3); cylinder(r=10,h=5); }
			//bevel_gear(number_of_teeth=gear2_teeth,cone_distance=cone_distance,pressure_angle=20,outside_circular_pitch=outside_circular_pitch,bore_diameter=12);
			//for(i=[0:3]) rotate(a=i*90) translate([0,13,0]) cylinder(r=1,h=40);
			difference(){ cylinder(r=60,h=40,center=true); cylinder(r=24,h=50,center=true); }
			cylinder(r=1.5,h=15,center=true);
			translate([0,0,-0.5]) import("involute.stl",convexity=3);
		}
	}
}

servo_gear();
/*
door_cap_frame();

translate([-10,0,20])
{
	knob_gear(); //% knob_gear(true);
	difference(){ knob_hub(height=20); cube([0.5,100,50],center=true); }
}

translate([30,0,48.5]) rotate([90,0,-90])
{
	servo_gear(); //% servo_gear(true);
	rotate([0,0,90]) translate([-10,0,-20]) { % servo(); rotate([0,180,0]) servo_mount(); }
}
*/