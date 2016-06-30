sas off.
RCS on.
lock steering to -ship:velocity:surface.
run burntime(groundspeed).
warpto(time:seconds + ETA:periapsis - timeto - 30).

wait until eta:periapsis < timeto + 10.
set ship:control:fore to 1.

wait until ETA:periapsis < timeto .
set ship:control:fore to 0.
lock Throttle to 1.

wait until ship:groundspeed < 1.
lock throttle to 0.
wait 5.
stage.
wait 10.


lock steering to lookdirup(-orbit:velocity:surface,ship:facing:topvector).





//time to impact

	lock currentG to constant:g*body:mass/(altitude+body:radius)^2.
	lock TTI to max(-ppq/2+SQRT(((ppq/2)^2)-qpq),-ppq/2-SQRT(((ppq/2)^2)-qpq)).
	lock ppq to abs(verticalspeed) * 2/currentG.
	lock qpq to -alt:radar*2/currentG.

//burntime

	run ispcurrent.
	lock mfinal to ship:mass * constant:E^(-abs(verticalspeed) / (ISPcurrent * 9.81)).
	lock mpropellant to ship:mass - mfinal.
	lock burnrate to max(0.001,ship:maxthrust) / (ISPcurrent * 9.81).
	lock burntime to mpropellant/burnrate.
	
 

wait until TTI*1.6 < burntime.
lock throttle to 1.

wait until abs(verticalspeed) < 10.
lock throttle to 0.

set threshold to 10.


until round(verticalspeed,1) = 0 and alt:radar < 10  {

	if alt:radar < 100 {
		set threshold to 5.
	}
	
	if alt:radar < 40 {
		set threshold to 2.5.
	}
	
	if abs(verticalspeed) >  threshold {
		lock throttle to 1.
	}
	
	else {
		lock throttle to 0.
	}
}


lock throttle to 0.