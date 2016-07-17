
//Parameter
	parameter desperiod is body:rotationperiod.

//Known-State
	run lib.

lock steering to lookdirup(body:position,ship:orbit:velocity:orbit).
	
lock foredir to (desperiod-ship:orbit:period) / abs(desperiod-ship:orbit:period).

lock upvecgeschwindigkeit 	to -ship:orbit:velocity:orbit * up:forevector.
lock upvecpos 				to (body:position * up:forevector) + 500000 + body:radius.
lock updir 					to (ship:orbit:velocity:orbit * up:forevector)/abs(ship:orbit:velocity:orbit * up:forevector).

lock sidevecgeschwindigkeit to -ship:orbit:velocity:orbit 	* north:forevector.
lock sidevecpos  			to (body:position 				* north:forevector).
lock sidedir 				to (ship:orbit:velocity:orbit 	* north:forevector)/abs(ship:orbit:velocity:orbit 	* north:forevector).



set forestash 	to 0.
set starstash 	to 0.
set topstash 	to 0.



set pretime to -100.

until false {

	if warp > 0 {
		RCS off.
		SAS on.
	}
	
	else {
		RCS on.
		SAS off.
	}
	
	

	timetoFK(upvecpos,upvecgeschwindigkeit).
	if timeto > pretime  	and 	timeto < 0				set upflag to 1.
	else 													set upflag to 0.
	
	if abs(desperiod-ship:orbit:period) > 0.01 				set foreflag to 1.
	else 													set foreflag to 0.
	
	timetoFK(sidevecpos,sidevecgeschwindigkeit).
	if timeto > pretime 	and 	timeto < 0 				set sideflag to 1.
	else 													set sideflag to 0.
	
	
	
	
	set transvec to (up:forevector:normalized * upflag * -updir) + (ship:orbit:velocity:orbit:normalized * foreflag * foredir) + (ship:orbit:velocity:orbit:direction:starvector * sideflag * sidedir).
	translate(transvec).
	
	SET anArrow TO VECDRAW(
      V(0,0,0),
      transvec,
      RGB(1,0,0),
      "See the arrow?",
      2,
      TRUE,
      0.2
    ).

}









