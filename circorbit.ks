parameter orbitx is (((ship:body:rotationperiod^2)*constant:g*ship:body:mass/(4*(constant:pi^2)))^(1/3))-ship:body:radius.

add node(0,0,0,0).

wait 0.01.


if abs(apoapsis-orbitx) > 1000 and abs(periapsis-orbitx) > 1000 {
	
	set nextnode:eta to eta:periapsis.
	set avorbit to (periapsis+orbitx)/2.
	set ticker to 100.
	set vz to 1.
	set laststate to 0.

	until abs(nextnode:orbit:apoapsis-orbitx) < 1000 or abs(nextnode:orbit:periapsis-orbitx) < 1000 {
	
		if laststate < abs(((nextnode:orbit:apoapsis+nextnode:orbit:periapsis)/2) - avorbit) {
			set ticker to ticker/2.
			set vz to vz * -1.
		}
		
		set laststate to abs(((nextnode:orbit:apoapsis+nextnode:orbit:periapsis)/2) - avorbit).
		set nextnode:prograde to nextnode:prograde + vz * ticker.
		
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



if abs(apoapsis-orbitx) > 1000 or abs(periapsis-orbitx) > 1000 {

	set ticker to 100.
	set vz to 1.
	set laststate to 0.
	
	until abs((nextnode:orbit:apoapsis + nextnode:orbit:periapsis)/2 - orbitx) < 1000 {
	
		if laststate < abs((nextnode:orbit:apoapsis + nextnode:orbit:periapsis)/2 - orbitx) {
		
			set ticker to ticker/2.
			set vz to vz * -1.
			
		}
		
		set laststate to abs((nextnode:orbit:apoapsis + nextnode:orbit:periapsis)/2 - orbitx).
		set nextnode:prograde to nextnode:prograde + vz * ticker.
	}
	
	run maneuvernode.
	
}

remove nextnode.
