set ziel to target.
parameter orbitx is (ziel:orbit:periapsis+ziel:orbit:apoapsis)/2.
RCS on.
SAS off.
run lib.


lock steering to up.
lock throttle to 1.
stage.
wait 5.
lock steering to lookdirup(angleaxis(30,vcrs(ship:orbit:velocity:orbit,up:vector)) * vcrs(up:vector,vcrs(up:vector,-ziel:orbit:velocity:orbit)) ,ship:facing:topvector).
wait until apoapsis/orbitx > 0.9.
lock throttle to 0.1.
add node(0,0,0,0).
wait 0.1.
set nextnode:eta to eta:apoapsis.

set tvz to 1.
set ticker to 64.
set laststate to abs(nextnode:orbit:apoapsis/nextnode:orbit:periapsis) + 1.

until ticker < 0.5 {

	if laststate < abs(nextnode:orbit:apoapsis-nextnode:orbit:periapsis) {
		set ticker to ticker/2.
		set tvz to tvz * -1.
	}
	set laststate to abs(nextnode:orbit:apoapsis-nextnode:orbit:periapsis).
	set nextnode:prograde to nextnode:prograde + ticker * tvz.
	
}

lock steering to nextnode:deltav.
burntimeFK().
set laststate2 to abs(apoapsis-periapsis)+1.

until burntime/3*2 > nextnode:eta or abs(apoapsis-periapsis) > laststate2 {

	if abs(eta:apoapsis-nextnode:eta) > 5 {
	
		set nextnode:eta to eta:apoapsis.
		set tvz to 1.
		set ticker to 8.
		set laststate to abs(nextnode:orbit:apoapsis/nextnode:orbit:periapsis) + 1.

		until ticker < 0.5 {

			if laststate < abs(nextnode:orbit:apoapsis-nextnode:orbit:periapsis) {
				set ticker to ticker/2.
				set tvz to tvz * -1.
			}
			
		set laststate to abs(nextnode:orbit:apoapsis-nextnode:orbit:periapsis).
		set nextnode:prograde to nextnode:prograde + ticker * tvz.
	
		}

	}
	
	burntimeFK().									
	set laststate2 to abs(apoapsis-periapsis).
}

if burntime/3*2 > nextnode:eta {
	lock throttle to 1.
	set laststate to abs(apoapsis-periapsis) + 1.
	until abs(apoapsis-periapsis) > laststate{
		set laststate to abs(apoapsis-periapsis).
	}
}

lock throttle to 0.
unlock steering.
remove nextnode.





