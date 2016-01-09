$fn=24;

motor();

module motor_shaft() intersection(){ circle(d=5.4); square([3.7,6],true); }

module motor_stub() translate([0,11.5]) circle(r=2);

module motor_body()
{
    linear_extrude(18) hull()
    {
        translate([0,7.5]) square([22,30],true);
        for(i=[-1,1]) translate([8*i,-7]) circle(r=3);
    }
    mirror([0,0,1]) linear_extrude(2) motor_stub();
    translate([0,0,-0.5]) cylinder(d=7,h=0.5);
}

module motor(r=0)
{
    color("White") mirror([0,0,1]) linear_extrude(9) motor_shaft();
    color("Yellow") rotate(r) motor_body();
}