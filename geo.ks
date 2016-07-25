
//Parameter
	parameter orbitx is (((ship:body:rotationperiod^2)*constant:g*ship:body:mass/(4*(constant:pi^2)))^(1/3)).
	parameter desperiod is body:rotationperiod.
	parameter proceedflag is 0.

//Known-State
	run lib.


lock steering to -up:vector.
stillstand().
	
	
lock foredir to (desperiod-ship:orbit:period) / abs(desperiod-ship:orbit:period).

lock topvecgeschwindigkeit 	to ship:orbit:velocity:orbit * up:vector.
lock topvecpos 				to -(body:position * up:vector) - orbitx .
lock topdir					to (ship:orbit:velocity:orbit * up:vector)/abs(ship:orbit:velocity:orbit * up:vector).

lock starvecgeschwindigkeit to ship:orbit:velocity:orbit 	* heading(0,latitude):vector.
lock starvecpos  			to -body:position 				* heading(0,latitude):vector.
lock stardir 				to (ship:orbit:velocity:orbit 	* north:forevector)/abs(ship:orbit:velocity:orbit 	* north:forevector).



set forestash 	to 0.
set starstash 	to 0.
set topstash 	to 0.



set pretime to -5.



on ag9 {

	set proceedflag to 1.

}


until proceedflag = 1 {

	if abs(desperiod-ship:orbit:period) > 1 				set foreflag to 1.
	else if abs(desperiod-ship:orbit:period) > 0.1			set foreflag to 0.1.
	else													set foreflag to 0.

	set timeto to timetoFK(topvecpos,topvecgeschwindigkeit)/abs(topvecgeschwindigkeit).
	if timeto > pretime  	and 	timeto < 0				set topflag to 1.
	else 													set topflag to 0.
	if orbit:eccentricity < 0.00001							set topflag to 0.
	
	clearscreen.
	print timeto.	
	
		
	set timeto to timetoFK(starvecpos,starvecgeschwindigkeit)/abs(starvecgeschwindigkeit).
	if timeto > pretime 	and 	timeto < 0 				set starflag to 1.
	else 													set starflag to 0.
	if ship:orbit:inclination < 0.001						set starflag to 0.
	
	

	print timeto.
	
	
	set transvec to (up:forevector:normalized * topflag * -topdir) + (ship:orbit:velocity:orbit:normalized * foreflag * foredir) + (vcrs(ship:orbit:velocity:orbit, body:position):normalized * starflag * stardir).
	translate(transvec).
	
	SET anArrow TO VECDRAW(
      V(0,0,0),
      transvec,
      RGB(1,0,0),
      "",
      2,
      TRUE,
      0.2
    ).

}









