run lib.
parameter runmode is 0.
Parameter wpname is "Waypoint Name".
set spot to waypoint(wpname).


if runmode = 0 {

	lock frontalvector to -vcrs(up:vector,vcrs(up:vector,ship:orbit:velocity:orbit)):normalized.
	lock normalvector to vcrs(up:vector,ship:orbit:velocity:orbit):normalized.

	lock frontaldistanz to spot:position * frontalvector.
	lock normaldistanz to spot:position * normalvector.
	lock frontalgeschwindigkeit to ship:orbit:velocity:surface * frontalvector.
	lock frontaltimeto to abs(frontaldistanz/frontalgeschwindigkeit).


	lock steering to -frontalvector * -angleaxis(normaldistanz/abs(normaldistanz) * min(45,abs(normaldistanz)/100),up:vector).


	wait until frontaltimeto*1.5 < burntimeFK(abs(frontalgeschwindigkeit))*2.
	set ship:control:fore to 1.
	wait until frontaltimeto*1.7 < burntimeFK(abs(frontalgeschwindigkeit))*2.
	set ship:control:fore to 0.
	set laststate to frontalgeschwindigkeit + 1.
	print frontalgeschwindigkeit.

	until laststate < frontalgeschwindigkeit {
		if frontaltimeto*1.7 < burntimeFK(abs(frontalgeschwindigkeit))*2 lock throttle to 1.
		else lock throttle to 0.5.
		set laststate to frontalgeschwindigkeit.
		clearscreen.
		print normaldistanz.
		print frontaldistanz.
	}

	lock throttle to 0.
	set runmode to 1.
}


if runmode = 1 {

	//time to impact

		lock currentG to constant:g*body:mass/(altitude+body:radius)^2.
		lock TTI to max(-ppq/2+SQRT(((ppq/2)^2)-qpq),-ppq/2-SQRT(((ppq/2)^2)-qpq)).
		lock ppq to abs(verticalspeed) * 2/currentG.
		lock qpq to -(alt:radar -3)*2/currentG.

	//burntime

		ispcurrentFK().
		lock mfinal to ship:mass * constant:E^(-abs(verticalspeed) / (ISPcurrent * 9.81)).
		lock mpropellant to ship:mass - mfinal.
		lock burnrate to max(0.001,ship:maxthrust) / (ISPcurrent * 9.81).
		lock burntime to mpropellant/burnrate.
		
	//Abbremsen

		lock east to vcrs(north:vector,up:vector).
		
		lock nord	to	spot:position	*	north:vector.
		lock ost 	to 	spot:position	*	east.
		
		lock correctvector to (spot:position + up:vector*alt:radar/2):normalized - ship:orbit:velocity:surface:normalized.
		
		lock correctnorth 	to		correctvector	*	north:vector.
		lock correctoffseteast 		to		correctvector	*	east.
		
		lock steering to lookdirup(-ship:orbit:velocity:surface * -angleaxis(min(2,90*correctnorth),east) * angleaxis(min(2,90*correctoffseteast),north:vector),ship:facing:topvector).

		wait until TTI*1.2 < burntime.
		set ship:control:fore to 1.
		
		wait until TTI*1.5 < burntime.
		lock throttle to 1.
		wait 3.
		set ship:control:fore to 0.
		
		until abs(ship:orbit:velocity:surface:mag) < 1 {

			print nord.
			print ost.
		
			if TTI*1.6 < burntime {
				lock throttle to 1.
			}
			
			else {
				lock throttle to 0.5.
			}

		}

	lock throttle to 0.
}