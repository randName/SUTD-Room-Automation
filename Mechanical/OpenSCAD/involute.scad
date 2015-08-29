$fn=100;

* translate([0,-25,0]) //translate([0,0,2])
linear_extrude(2) difference()
{
	circle(r=20); circle(r=1.5);
	translate([0,-10,0]) square([2.2,10],center=true);
	for(i=[5,15]) translate([0,-i,0]) circle(r=1.1);
}

module involute(rad,rounds=2,startq=3)
{
	res = 90;
	for(i=[startq:startq+360*rounds/res-1]) for(j=[i*res:6/i:(i+1)*res])
		translate(rad*([cos(j),sin(j)]-j*3.1416/180*[sin(j),-cos(j)])) children();
}

linear_extrude(3) involute(0.8) circle(r=1.5);