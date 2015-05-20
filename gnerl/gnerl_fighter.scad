FN=30;

spec_length	=	21.6	;	// meters
spec_width		=	12.0	;	// meters
spec_height	=	12.0	;	// meters

scale=	1000/285;
scaled_length	=	spec_length*scale;	// mm
scaled_width	=	spec_width*scale;	// mm
scaled_height	=	spec_height*scale;	// mm

print_rotation_vector=[0,-90,0];

scale_bounding_box=[spec_length*scale, spec_width*scale, spec_height*scale];
echo ("scale_bounding_box",scale_bounding_box);
color("lightblue",0.1)
;//cube(scale_bounding_box, center=true);

//translate([scaled_length*-3/15,0,0])
*	color("red")		rotate (print_rotation_vector)  cube([scaled_length,1,1],center=false);
//color("red")		cube([1,scaled_width,1],center=true);
//color("red")		cube([1,1,scaled_height],center=true);

// Cube to check print bed location
* color("red")	rotate (print_rotation_vector) translate([-25,0,-9])	cube([50,50,50],center=true);

measured_scale=scaled_width/294;
calculated_engine_diameter=58 * measured_scale;
echo("calculated_engine_diameter",calculated_engine_diameter);
echo("20/90", 20/90, "ced/scaled_width",calculated_engine_diameter/scaled_width);
calculated_engine_inset=calculated_engine_diameter*2/3;


module engine_bell(engine_outer){
		echo("bell -- engine_outer:  ",engine_outer);
		cylinder(r1=engine_outer/2, r2=engine_outer*3/8,
			h=engine_outer/4,$fn=60);
	}


module engine_coweling(engine_outer,engine_length){
		echo("coweling -- engine_outer:  ",engine_outer);
		el1=engine_length* 0;			er1=engine_outer* 16/16 /2;
		el2=engine_length* 5/25;		er2=engine_outer* 15/16 /2;
		el3=engine_length* 10/25;		er3=engine_outer* 13/16 /2;
		el4=engine_length* 15/25;		er4=engine_outer* 10/16 /2;
		el5=engine_length* 20/25;		er5=engine_outer* 6/16 /2;
		el6=engine_length* 25/25;		er6=engine_outer* 1/16 /2;
		hull()	{
			translate([0,0,el1])		cylinder(r=er1, h=.1,$fn=60);
			translate([0,0,el2])		cylinder(r=er2, h=.1,$fn=60);
			translate([0,0,el3])		cylinder(r=er3, h=.1,$fn=60);
			translate([0,0,el4])		cylinder(r=er4, h=.1,$fn=60);
			translate([0,0,el5])		cylinder(r=er5, h=.1,$fn=60);
			translate([0,0,el6])		cylinder(r=er6, h=.1,$fn=60);
		}
	}


module exhaust_vent(vent_diameter){
		color("lightgrey")
		difference()		{
			cylinder(r1=vent_diameter, r2=vent_diameter*0.90,
				h=vent_diameter*1.5,$fn=FN);
			cylinder(r1=vent_diameter*0.6, r2=vent_diameter*0.6,
				h=vent_diameter*2,$fn=FN);				
		}
}


module finn(fin_length){
		difference()
{
			cube([fin_length, fin_length * 5/15, 1.], center=true);
			union(){
				translate([-fin_length/2,fin_length * 9/16,-.5])
					rotate([0,0,5])
						cube([fin_length*2,fin_length,5], center=true);

				translate([-fin_length/2,-fin_length * 9/16,-.5])
					rotate([0,0,-5])
						cube([fin_length*2,fin_length,5], center=true);
			}
		}
}


// Let's do some math...
engine_c_measured=135*measured_scale;
engine_a_calculated=engine_c_measured/2;
engine_b_calculated=sqrt(
							engine_c_measured*engine_c_measured  -  
							engine_a_calculated*engine_a_calculated);
echo("engine_c_measured/2", engine_c_measured/2);
echo("engine_a_calculated", engine_a_calculated);
echo("engine_b_calculated", engine_b_calculated);

engine12_y_offset=engine_a_calculated;
engine12_z_offset=engine_b_calculated/-3;
engine3_z_offset=engine_b_calculated*2/3;
e_shift=9/12;

rear_section_length=scaled_length*30/150;
gun_barrel_radius=0.4;



//Rotation for print
rotate (print_rotation_vector){

difference()
{	// The Hull
union(){
	// Engine Cowelings
		translate([0,engine12_y_offset*e_shift, engine12_z_offset*e_shift])
			rotate([0,90,0])		// engine 1 stbd
				color("red")		engine_coweling(calculated_engine_diameter,
									calculated_engine_diameter);
		translate([0,-1*engine12_y_offset*e_shift,engine12_z_offset*e_shift])	
			rotate([0,90,0])		// engine 2 port
				color("green")	engine_coweling(calculated_engine_diameter,
								calculated_engine_diameter);
		translate([0,0,engine3_z_offset*e_shift])							
			rotate([0,90,0])		// engine 3 top
				color("yellow")	engine_coweling(calculated_engine_diameter,
								calculated_engine_diameter);
	// Rear Hull Section
	color ("black")
		polyhedron      (
            	points = [	[0,engine12_y_offset,engine12_z_offset],
						[0,-1*engine12_y_offset,engine12_z_offset],
						[0,0,engine3_z_offset],
						[scaled_length*22/32,0,0] ] ,
			triangles = [   [0,2,1],[0,1,3],[0,3,2],[1,2,3]]        );

	// Middle Hull Section
	color("darkgreen")
	hull()
	{
		color("yellowgreen")		// Upper 1
			translate([calculated_engine_diameter*0,0,5.5])	rotate([0,90,0])
				cylinder(r1=calculated_engine_diameter/4,
						r2=calculated_engine_diameter*0.90/4,
						h=scaled_length* 50/150,$fn=FN);
		color("darkgreen")		// Lower 1
			translate([calculated_engine_diameter*0,0,-1.5])	rotate([0,90,0])
				cylinder(r1=calculated_engine_diameter*5/8,
						r2=calculated_engine_diameter*4/8*0.85,
						h=scaled_length* 50/150,$fn=FN);
	}

	color("darkgreen")	
	hull(){
		color("yellowgreen")		// Upper 2
			translate([calculated_engine_diameter*0,0,2])	rotate([0,90,0])
				cylinder(r1=calculated_engine_diameter/4,
						r2=calculated_engine_diameter*0.90/8,
						h=scaled_length* 100/150,$fn=FN);
		color("darkgreen")		// Lower2
			translate([calculated_engine_diameter*0,0,-1.5])	rotate([0,90,0])
				cylinder(r1=calculated_engine_diameter*5/8,
						r2=calculated_engine_diameter*0.90/4,
						h=scaled_length* 100/150,$fn=FN);
	} 

	// Canopy
	color("lightgreen")
	hull()	{
		color("lightgreen")		// Canopy
			translate([scaled_length* 48/150,0,5.7])	rotate([0,102,0])
			cylinder(r1=calculated_engine_diameter*7/32,
					r2=calculated_engine_diameter*0.70/5,
					h=scaled_length* 50/150,$fn=FN);
		color("red")		// Lower 3
			translate([scaled_length* 48/150,0,2.0])	rotate([0,95,0])
			cylinder(r1=calculated_engine_diameter*5/16,
					r2=calculated_engine_diameter*0.50/4,
					h=scaled_length* 50/150,$fn=FN);

		// Canopy Bubble
		color("red")
			translate([scaled_length* 72/150,0,4])	rotate([0,13,0])
				scale([1,0.2,0.25])
					sphere(r=scaled_length* 54/150/2, $fn=FN);

		// Lower Bubble
		color("lightgreen")
			translate([scaled_length* 70/150,0,-3.4])
				scale([1,0.25,0.25])
					sphere(r=scaled_length* 52/150/2, $fn=FN);
	}

	// Nose Cone
	color("purple")	hull(){
		translate([scaled_length* 100/150,0,2])	rotate([0,90,0])
			cylinder(r1=calculated_engine_diameter*0.90/8,
					r2=calculated_engine_diameter*0.70/8,
					h=scaled_length* 5/150,$fn=FN);
		translate([scaled_length* 100/150,0,-1.5])	rotate([0,90,0])
			cylinder(r1=calculated_engine_diameter*0.90/4,
					r2=calculated_engine_diameter*0.70/4,
					h=scaled_length* 5/150,$fn=FN);		} 

	color("lightgrey"){
		translate([scaled_length* 105/150,0,1.0])	rotate([0,90,0])
			difference()		{
				cylinder(r1=calculated_engine_diameter*0.45/4,
						r2=calculated_engine_diameter*0.40/4,
						h=scaled_length* 5/150,$fn=FN);
				translate([0,0,scaled_length* 3/150])
					cylinder(r1=calculated_engine_diameter*0.25/4,
							r2=calculated_engine_diameter*0.25/4,
							h=scaled_length* 6/150,$fn=FN);
			}
		translate([scaled_length* 105/150,0,-1.5])	rotate([0,90,0])
			cylinder(r1=calculated_engine_diameter*0.65/4,
					r2=calculated_engine_diameter*0.55/4,
					h=scaled_length* 5/150,$fn=FN);				
		} 

	// Gun Barrels
	color("slategrey")	{
		translate([scaled_length* 110/150,0,-1.5])	rotate([0,90,0])
			cylinder(r1=calculated_engine_diameter*0.55/4,
					r2=calculated_engine_diameter*0.45/4,
					h=scaled_length* 3/150,$fn=FN);
		translate([scaled_length* 113/150,0,-1.5])	rotate([0,90,0])	{
			translate([-gun_barrel_radius*2/3,-gun_barrel_radius,0])
				cylinder(r=gun_barrel_radius, h=scaled_length* 7/150,$fn=FN);
			translate([-gun_barrel_radius*2/3,gun_barrel_radius,0])
				cylinder(r=gun_barrel_radius, h=scaled_length* 7/150,$fn=FN);
			translate([gun_barrel_radius,0,0])
				cylinder(r=gun_barrel_radius, h=scaled_length* 7/150,$fn=FN);
			}
		} 
} // End Union
	union(){
		// Big Slots
		translate([vent_rear_position/3+1,-7.25,6])
			rotate([60,0,7])
				cube([5,2,10],center=true);
		translate([vent_rear_position/3+1,-9,3])
			rotate([60,0,11])
				cube([5,2,10],center=true);
		translate([vent_rear_position/3+1,7.25,6])
			rotate([-60,0,-7])
				cube([5,2,10],center=true);
		translate([vent_rear_position/3+1,9,3])
			rotate([-60,0,-11])
				cube([5,2,10],center=true);

		// Vent Slots
		translate([vent_rear_position+2.25,-6.,1])
			rotate([77,0,5])
				cube([7.5,3.25,6],center=true);
		translate([vent_rear_position+2.25,6.,1])
			rotate([-77,0,-5])
				cube([7.5,3.25,6],center=true);

		// Lateral slots
		color("black")
			translate([scaled_length* 68/150,-4,0])
				rotate([0,0,5])
					cube([scaled_length*6.4/15,3,1], center=true);
		color("black")
			translate([scaled_length* 68/150,4,0])
				rotate([0,0,-5])
					cube([scaled_length*6.4/15,3,1], center=true);

	}	// End union
}	// End Difference

}// End print rotation


	// Venty Things
vent_diameter=calculated_engine_diameter/6;
vent_rear_position=scaled_length* 35/150;
vent_z_position=0.5;
color("lightgrey")
	rotate (print_rotation_vector){
		translate([vent_rear_position,-1.5,vent_z_position])
			rotate([90,0,0])
				exhaust_vent(vent_diameter);
		translate([vent_rear_position+2.75*vent_diameter,-1.5,vent_z_position])	
			rotate([90,0,0])
				exhaust_vent(vent_diameter);
		translate([vent_rear_position,1.5,vent_z_position])	
			rotate([-90,0,0])
				exhaust_vent(vent_diameter);
		translate([vent_rear_position+2.75*vent_diameter,1.5,vent_z_position])
			rotate([-90,0,0])
				exhaust_vent(vent_diameter);
	}


//  This block puts the fins in the correct position for rendering the mecha
// Fins are at 40 degrees
// Fins are 3/15
fin_attack_angle=40;
*color("purple")
	rotate (print_rotation_vector)
	{
	rotate([0,fin_attack_angle,0])
		translate([-5,0,15.5])
				finn(scaled_length*4/15); 
	rotate([120,0,0])
		translate([-5,0,15.5])
			rotate([0,fin_attack_angle,0])
				finn(scaled_length*4/15); 
	rotate([-120,0,0])
		translate([-5,0,15.5])
			rotate([0,fin_attack_angle,0])		
				finn(scaled_length*4/15); 
	}


//  This block puts the fins in the correct position for printing the mecha
color("purple")
	rotate (print_rotation_vector)
		translate([0.5,0,0])	// Fix alignment
	{
		translate([0,10,15])
			rotate([0,90,0])
				finn(scaled_length*4/15); 
		 translate([0,20,15])
			rotate([0,90,0])
				finn(scaled_length*4/15); 
		 translate([0,30,15])
			rotate([0,90,0])
				finn(scaled_length*4/15); 
	}
	
// Small Fins
color("LightSteelBlue")
	rotate (print_rotation_vector)
		translate([0.5,0,0])	// Fix alignment
	{
		translate([0,6,15])
			rotate([0,90,0])
				finn(4);
		translate([0,3,15])
			rotate([0,90,0])
				finn(4);
		translate([0,0,15])
			rotate([0,90,0])
				finn(4);
		translate([0,-3,15])
			rotate([0,90,0])
				finn(4);
		translate([0,-6,15])
			rotate([0,90,0])
				finn(4);
		translate([0,-9,15])
			rotate([0,90,0])
				finn(4);
	}
	

// Engine bells
color("blue"){
	rotate (print_rotation_vector)
		translate([+2,-20,9])
	{
		translate([-2,engine12_y_offset*e_shift, engine12_z_offset*e_shift])
			rotate([0,90,0])		// engine 1 stbd
				color("red")		engine_bell(calculated_engine_diameter);
		translate([-2,-1*engine12_y_offset*e_shift,engine12_z_offset*e_shift])	
			rotate([0,90,0])		// engine 2 port		
				color("green")	engine_bell(calculated_engine_diameter);
		translate([-2,0,engine3_z_offset*e_shift])							
			rotate([0,90,0])		// engine 3 top
				color("yellow")	engine_bell(calculated_engine_diameter);
	}
}




