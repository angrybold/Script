//Parameter.
	
	Parameter runmode is 1.
	set ziel to target.
	set proceedflag to 0.

	

//Known State.

	run lib.
	run lib_gui_box.
	run lib_menu.
	RCS on.
	SAS off.
	
on ag9 {
	set proceedflag to 1.
	preserve.
}	

on ag8 {
	maneuvernode().
	preserve.
}
	
//Inclination nullen - Runmode 1

	if runmode = 1 {
	
		inclination().
		wait until proceedflag = 1.
		set proceedflag to 0.
		set runmode to 2.
	}
	

	
	
//Orbit anpassen - Runmode 2
	
	if runmode = 2 {
		circorbit((ziel:orbit:apoapsis+ziel:orbit:periapsis)/2).
		wait until proceedflag = 1.
		set proceedflag to 0.
		set runmode to 3.
	}

	
//Abpassen - Runmode 3
	
	if runmode = 3 {
		meetup().
		wait until proceedflag = 1.
		set proceedflag to 0.
		set runmode to 4.
	}	
	





