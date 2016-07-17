sas off.
RCS on.
lock steering to lookdirup(-vcrs(up:vector,vcrs(ship:velocity:orbit,up:vector)),ship:facing:topvector).
wait 2.
wait until ship:angularmomentum:mag < 0.01.

set ship:control:fore to 1.
wait 5.
set ship:control:fore to 0.
lock throttle to 1.
wait 2.

set laststate to ship:groundspeed + 1.
until laststate < ship:groundspeed {
	set laststate to ship:groundspeed.
}
lock throttle to 0.

lock steering to lookdirup(-orbit:velocity:surface,ship:facing:topvector).





//time to impact

	lock currentG to constant:g*body:mass/(altitude+body:radius)^2.
	lock TTI to max(-ppq/2+SQRT(((ppq/2)^2)-qpq),-ppq/2-SQRT(((ppq/2)^2)-qpq)).
	lock ppq to abs(verticalspeed) * 2/currentG.
	lock qpq to -(alt:radar -3)*2/currentG.

//burntime

	run ispcurrent.
	lock mfinal to ship:mass * constant:E^(-abs(verticalspeed) / (ISPcurrent * 9.81)).
	lock mpropellant to ship:mass - mfinal.
	lock burnrate to max(0.001,ship:maxthrust) / (ISPcurrent * 9.81).
	lock burntime to mpropellant/burnrate.
	
//Abbremsen

	wait until TTI*1.2 < burntime.
	set ship:control:fore to 1.
	
	wait until TTI*1.6 < burntime.
	set ship:control:fore to 0.
	
	until abs(ship:orbit:velocity:surface:mag) < 1 {

		if TTI*1.6 < burntime {
			lock throttle to 1.
		}
		
		else {
			lock throttle to 0.9.
		}

	}



lock throttle to 0.