$fn=100;

module servo(shell=false)
{
	cube([56,20.5,2.5],center=true);
	translate([0,0,-10])
		if(shell){ cube([44,21.5,40],true); } else { cube([42,20.5,40],true); }
	translate([11,0,10]){ cylinder(r=6,h=1.5); cylinder(r=3,h=5); }
	for(i=25*[-1,1]) for(j=5*[-1,1]) translate([i,j,0])
		cylinder(r=2.25,h=30,center=true);
}

module 9g_servo()
{
	l = 23.28; // length
	w = 12.5; // width (or depth)
	h = 23.3; // height of main body
	c = 6; // bottom "cap" height
	f = 5; // length of flange
	fz = 2.36; // thickness of flange
	fh = 16.44 + (fz/2); // position of flange
	
	mc = 3.75; // main cyl height
	ax = 2.75; // axle height
	ar = 2.455; // axle radius
	ah = h+ax; // axle pos
	sx = -0.89; // sub cyl center
	sr = 2.905; // sub cyl radius

	l2 = l/2;
	l4 = l/4;
	w2 = w/2;
	
	difference()
	{
		union() {
			translate( [-l2, -w2,  c] ) cube([l,w,h-c]); // main body
			translate( [-l2, -w2,  0] ) cube([l,w,  c]); // bottom cap
			translate( [  0,   0, fh] ) cube([l+f+f,w,fz], center=true); // flange
			translate( [ l4,   0,  h] ) cylinder(r=l4, h=mc); // main cyl
			translate( [ sx,   0,  h] ) cylinder(r=sr, h=mc); // sub cyl
			translate( [ l4,   0, ah] ) cylinder(r=ar, h=ax); // axle
		}
		translate([ 13.89,0,16.44]) cylinder(r=1, h=10, center=true);
		translate([-13.89,0,16.44]) cylinder(r=1, h=10, center=true);
		translate([ 13.89+1.5,0,16.44]) cube([3,1,10], center=true);
		translate([-13.89-1.5,0,16.44]) cube([3,1,10], center=true);
	}	
}

module servo_mount()
{
	//translate([0,0,16])
	difference()
	{
		translate([1,0,2]) cube([60,32,4],center=true);
		translate([0,0,6]) servo(true);
	}
	
	translate([30.5,0,10])
	{
		cube([4,32,20],center=true);
		translate([0,0,-6]) intersection()
		{
			rotate([0,45,0]) cube([17.5,32,17.5],true);
			for(i=[-1,1]) translate([-7,i*14,7]) cube([17.5,4,17.5],true);
		}
	}

	for(i=[-1,1]) translate([1,14.5*i,5.5]) cube([60,3,3],center=true);
}

difference()
{
	servo_mount();
	for(i=[-1,1]) for(j=[-1.25,-1,-0.75,0.75,1,1.25])
	translate([27,i*8,j+12.5]) rotate([0,90,0])
	{
        cylinder(r=3.5,h=6,$fn=6,center=true);
        cylinder(r=1.5,h=20,center=true);
    }
}

//% 9g_servo();

//servo_mount();
% translate([0,0,6]) rotate([0,180,0]) servo();