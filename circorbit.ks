parameter orbitx is (((ship:body:rotationperiod^2)*constant:g*ship:body:mass/(4*(constant:pi^2)))^(1/3))-ship:body:radius.

add node(0,0,0,0).

wait 0.01.


if abs(apoapsis-orbitx) > orbitx/500 and abs(periapsis-orbitx) > orbitx/500 {
	
	set nextnode:eta to eta:periapsis.

	if apoapsis < orbitx {
		set ticker to 1.
	}

	else {
		set ticker to -1.
	}

	until abs(nextnode:orbit:apoapsis-orbitx) < orbitx/500 or abs(nextnode:orbit:periapsis-orbitx) < orbitx/500 {
		set nextnode:prograde to nextnode:prograde + ticker * random().
	}

	run maneuvernode.

	add node(0,0,0,0).

	wait 0.01.
	
}
	
if abs(apoapsis-orbitx) < abs(periapsis-orbitx) {
	set nextnode:eta to eta:apoapsis.
}

else {
	set nextnode:eta to eta:periapsis.
}



if abs(apoapsis-orbitx) > orbitx/500 or abs(periapsis-orbitx) > orbitx/500 {

	until abs(nextnode:orbit:apoapsis-orbitx) < orbitx/500 and abs(nextnode:orbit:periapsis-orbitx) < orbitx/500 {
		set nextnode:prograde to nextnode:prograde - random() * ((((nextnode:orbit:periapsis+nextnode:orbit:apoapsis)/2)-orbitx)/abs(((nextnode:orbit:periapsis+nextnode:orbit:apoapsis)/2)-orbitx)).
	}
	
	run maneuvernode.
	
}

remove nextnode.
