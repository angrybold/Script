RCS on.
SAS off.
lock steering to prograde.
wait 1.
wait until ship:angularmomentum:mag < 0.001.

until round(ship:body:rotationperiod) = round(ship:orbit:period) {

	if ship:body:rotationperiod > ship:orbit:period {
		set ship:control:fore to 1.
	}
	
	else {
		set ship:control:fore to -1.
	}
}

until round(ship:body:rotationperiod,3) = round(ship:orbit:period,3) {

	if ship:body:rotationperiod > ship:orbit:period {
		set ship:control:fore to 0.1.
	}
	
	else {
		set ship:control:fore to -0.1.
	}
}