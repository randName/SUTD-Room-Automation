$fn=100;
use <../MCAD/involute_gears.scad>
use <servo.scad>

r_gap = 0.05;
knob_or = 16.5;
ring_or = 25;
hold_or = 23;
gear_j = 20;
gear1_t = 24;
gear2_t = 22;

assembly(.5);

//translate([100,105]) border([200,210]);
//translate([0,210]) rotate(-90) translate([32,32]) layout();

//3mm
//delay_ring(); 
//delay_ring_holder();

module layout()
{    
    case(); gear_ring(hold_or); gear2_lock();
    translate([0,61.5]){ case(); knob_ring(hold_or); corners(14.5) spacer_ring(); }

    translate([-20,123]) board_mount();
    
    translate([75,4.5]) gear2();
    translate([75,12.5]) door_cap_frame();
    translate([75,85]){ gear2_lock(); rotate(90) gear_ring(l=true); }
    
    for(i=[-15,143]) translate([134.5,i])
    {
        servo_holder();
        for(j=[-1,0,1]) translate([j*13+11,0]) spacer_ring();
    }
    
    translate([146,63.5])
    {
        corners(14.5) spacer_ring(nut=false);
        rotate(90) knob_ring(l=true);
        gear2_holder();
        rotate(180) servo_holder(full=true);
        for(j=[-1,0,1]) translate([j*13-11,47]) spacer_ring(nut=false);
    }
    
    translate([83,138]) gear1();
    translate([31,123]){ knob_ring(l=true); corners(14.5) spacer_ring(); }
}

module assembly(s=0.01)
{
    h = [ 2, 2, 2, 3, 2, 2, 2, 2 ];
    
    translate([0,0,-10]) acrylic(2) door_cap_frame();
    
    translate([0,-60,-5]) rotate(90) acrylic(2) board_mount();
    
    put_layer(0,h,s)
    {
        gear1();
        gear2_pos() gear2();
    }
    
    put_layer(1,h,s)
    {
        case();
        gear_ring(hold_or);
        gear2_pos() gear2_lock();
    }
    
    put_layer(2,h,s)
    {
        gear_ring(l=true);
        gear2_holder();
        for(i=[-1,1]) translate(24*[i,1]) spacer_ring(nut=false);
    }
    
    translate([0,0,sum(h,2)+s*3])
    {
        knob_hub_split();
        microswitch_pos() microswitch();
        acrylic(2) gear2_pos() gear2_lock();
    }
    
    translate([0,0,sum(h,3)+s*3])
    {
        mirror([0,1,0]) microswitch_pos() microswitch();
    }
    
    put_layer(3,h,s) // 3mm
    {
        delay_ring();
        for(i=[-1,1]) rotate(i*90) delay_ring_holder();
    }
    
    put_layer(4,h,s)
    {
        knob_ring(l=true);
        corners(48) spacer_ring();
    }
    
    put_layer(5,h,s)
    {
        case();
        knob_ring(hold_or);
    }
    
    put_layer(6,h,s)
    {
        rotate([0,180,0]) knob_ring(l=true);
        corners(48) spacer_ring();
    }
    
    translate([0,0,sum(h,6)+s*7])
    {
         microswitch_pos(75) microswitch();
    }

    put_layer(7,h,s)
    {
         servo_holder(full=true);
    }
    
    translate([0,0,sum(h,7)+s*8])
    {
        gear2_pos() servo_assembly(s);
    }
    
    // rotate(-abs($t-0.5)*2820)
    // rotate(abs($t-0.5)*1410)
    // rotate(floor($t*4)%2?abs($t-0.5)*1410:0)
}

module servo_assembly(s=0.01)
{
    h = [ 2, 2, 1 ];
    translate([11,0,sum(h,2)+s*3]) rotate([0,180,0]) servo();
    put_layer(1,h,s) servo_holder();
    put_layer(0,h,s) servo_holder();
}


// Functions

function sum(a,i,s=0) = ( i==s ? a[i] : a[i] + sum(a,i-1,s) );

module put_layer(n,ts,spacing=0.01) translate([0,0,n>0?sum(ts,n-1)+n*spacing:0]) acrylic(ts[n]) children();

module ring(n=4) for(i=[0.5/n:1/n:1]) rotate(i*360) children();

module corners(d) for(i=[-1,1],j=[-1,1]) translate(len(d)?.5*[i*d[0],j*d[1]]:(d/2)*[i,j]) children();

module acrylic(thick=2,col="White",center=false)
{
	color(col,0.4) translate([0,0,center?(-thick/2):0]) linear_extrude(thick) children();
}

module rotate_gear(r,g1,g2) rotate(r*g1/g2-((g2%2)?90:(g2%4?0:180/g2))) children();

module border(frame) difference(){ square(frame+0.1*[1,1],true); square(frame,true); }

module sgear(num_teeth, gear_cp=360) gear(num_teeth,gear_cp,bore_diameter=0,flat=true);

// Objects

module knob_hub(radius=20, height=20, flat=false)
{
	clr = 3;
	tab = [12,3,4.5];
	knob_r = 15.5;
	
	if ( flat )
	{
		circle(r=radius+0.75,$fn=6);
	}
	else
	{
		difference()
		{
			union()
			{
				translate([0,0,clr]) cylinder(r=radius,h=height-clr,$fn=6);
				cylinder(r=sqrt(3)*radius/2,h=clr);
			}
			cylinder(r=knob_r,h=height*3,center=true);
		}
		for(i=(tab[1]/2+sqrt(knob_r*knob_r-(tab[0]*tab[0])/4))*[-1,1])
			translate([0,i,tab[2]/2]) cube(tab,true);
	}
}

module knob_hub_split() color("White") difference(){ knob_hub(height=10); cube([0.5,100,50],true); }

module microswitch_pos(r=105,t=33.5) rotate(r) translate([0,-t]) children();

module microswitch(flat=false)
{
    if( flat )
    {
        for(i=3.25*[-1,1]) translate([i,0,0]) circle(r=1);
    }
    else
    {
        color("DimGray") difference()
        {
            translate([-6.4,-1.5,-2.9]) cube([12.8,6.2,5.8]);
            for(i=3.25*[-1,1]) translate([i,0,0]) cylinder(r=1,h=6,center=true);
        }
        color("Silver") translate([4.3,7.1,0]) rotate(9) translate([-5,-0.8,0])
        {
            cube([10,0.1,3],true);
            translate([5,0.8,0]) cylinder(r=1.3,h=3,center=true);
        }
        color("Gold") for(i=[-1,0,1]) translate([i*5,-3.4]) cube([1,4,.5],true);
    }
}

module door_caps(flat=false,center=false)
{
    cap_r = 27.5; // radius of cap
	cap_d = 80; // distance between caps

    for(i=[-1,1]) translate([0,(center?0:31.5)+(cap_d/2)*i])
        if ( flat ){ circle(r=cap_r); } else { color("Silver") cylinder(r=cap_r,h=5); }
}

// Knob case

module limit_protrusion() translate([0,-ring_or+1]) polygon([[2,-2.5],[5,0],[-5,0],[-2,-2.5]]);

module spacer_ring(nut=true)
{
    difference()
    {
        circle(d=11);
        if ( nut ){ circle(d=6.1,$fn=6); } else { circle(d=3); }
    }
}

module hole(o,p=2,nut=false)
{
    translate([0,o]) if ( nut ){ circle(d=(p==2)?4.4:p,$fn=6); } else { circle(d=p); }
}

module dpin(t=21.75,s=1.9) hole(t,s);

module microswitch_extension()
{
    difference()
    {
        translate([30,0]) hull() corners([10,50]) circle(r=5);
        translate([29,0]) corners([10,48]) circle(d=3);
        circle(r=hold_or+r_gap);
        for(i=[-1,1]) microswitch_pos(90+i*15) microswitch(flat=true);
    }
}

module case()
{
    difference()
    {
        hull() corners(50) circle(d=10);
        corners(48) circle(d=3);
        circle(r=hold_or+r_gap);
    }
    microswitch_extension();
}

module knob_ring(rd=ring_or,l=false)
{
    hd = 21;
	difference()
	{
		circle(r=rd);
        dpin();
        knob_hub(flat=true);
        for(i=[1,2,4,5]) rotate(i*60) hole(hd,nut=l&&(i+1)%3);
	}
    if ( l ) ring(12) limit_protrusion();
}

module delay_ring(t=1.5)
{
	difference()
    {
        circle(r=ring_or);
        circle(r=ring_or-t);
    }
    translate([0,22.5]) square([3.5,3.25],true);
}

module delay_ring_holder()
{
    difference()
    {
        translate([23.5,0]) hull()
        {
            for(i=[-1,1]) translate([0,i*23.5]) circle(r=6.5);
            square([5,50],true);
        }
        circle(r=ring_or);
        corners(48) circle(r=2);
    }
}

module gear_ring(rd=ring_or,l=false)
{
	difference()
	{
		circle(r=rd);
        dpin();
        circle(r=knob_or);
        for(i=[1:2:7]) rotate(i*45) hole(gear_j,nut=l&&((i+1)%4));
	}
    if ( l ) ring(12) limit_protrusion();
}

module gear1()
{
	difference()
	{
        sgear(gear1_t);
        dpin();
        circle(r=knob_or);
		for(i=[1:2:7]) rotate(i*45) hole(gear_j,nut=((i-1)%4));
	}
}

module gear2_pos(r=0) rotate(r) translate([0,-gear1_t-gear2_t]) rotate_gear(r,gear1_t,gear2_t) children();

module gear2_key()
{
    ring() for(i=[7.5,10,13]) hole(i);
    rotate(45) ring() for(i=[8,12]) hole(i);
    circle(d=6);
}

module gear2()
{
	difference()
	{
        sgear(gear2_t);
        gear2_key();
	}
}

module gear2_lock(sz=32)
{
    difference()
    {
        circle(d=sz);
        gear2_key();
    }
}

module gear2_holder()
{
    inr = 15;
    difference()
    {
        translate([0,-40]) hull() corners([50,34]) circle(d=10);
        circle(r=ring_or+2.5);
        corners(48) circle(d=3);
        gear2_pos() circle(r=inr+r_gap);
    }
    gear2_pos() gear2_lock(inr*2);
}

module servo_holder(full=false)
{   
    if ( full )
    {
        difference()
        {
            translate([5,-40]) hull() corners([60,34]) circle(d=10);
            circle(r=ring_or+2.5);
            corners(48) circle(d=3);
            gear2_pos() translate([11,0]) servo(shell=true);
        }
    }
    else
    {
        translate([11,0]) difference()
        {
            hull() corners([48,20]) circle(d=10);
            servo(shell=true);
        }
    }
}

module door_cap_frame()
{	
	difference()
    {
        translate([3,10]) hull() corners([63,95]) circle(d=10);
        for(i=[-1,1],j=[0,90]) rotate(j) translate([34.5,i*24]) circle(d=3);
        corners(48) circle(d=3);
        translate([0,-12]) corners(48) circle(d=3);
        door_caps(flat=true);
	}
}

module board_mount()
{
    difference()
    {
        translate([10,0]) hull() corners([30,50]) circle(d=10);
        corners(48) circle(d=3);
        for(i=[-1:1],j=[-1:1]) translate((27.9/2)*[i,j]) circle(d=3);
        translate([50,0]) circle(d=55);
    }
}