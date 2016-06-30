
RCS on.
SAS off.


lock angulartarget to vcrs(target:velocity:orbit,target:position-ship:body:position).
lock relpos to body:position * angulartarget:direction:inverse.
lock relspeed to velocity:orbit * angulartarget:direction:inverse.
lock timeto to abs(relpos:z)/abs(relspeed:z).


print relspeed:z.
set richtungsflag to relpos:z/abs(relpos:z).
lock steering to lookdirup(richtungsflag * vcrs(target:orbit:velocity:orbit,target:position-ship:body:position),ship:facing:topvector).


if timeto  > 2000 {
	set warp to 4.
}
wait until timeto  < 2000.

if timeto > 200 {
	set warp to 3.
}
wait until timeto < 200.

if timeto > 100 {
	set warp to 2.
}
wait until timeto < 100.

set warp to 0.
wait 10.
wait until ship:angularmomentum:mag < 0.01.


set tempo to 40.

until abs(relspeed:z) < 0.01 {

	if abs(relpos:z) < 200 {
		set tempo to 5.
	}
	
	if abs(relpos:z) < 50 {
		set tempo to 2.5.
	}

	if abs(relpos:z) < 20 {
		set tempo to 1.
	}	
	
	if abs(relpos:z) < 2 {
		set tempo to 0.2.
	}
	
	if abs(relpos:z) < 1 {
		set tempo to 0.
	}	
	
	if abs(relspeed:z) > tempo {
		
		if abs(relspeed:z) < 5 {
			set ship:control:fore to 1.
		}
		
		else {
			lock throttle to 1.
		}
	}
	
	else {
		set ship:control:fore to 0.
		lock throttle to 0.
	}
	
	clearscreen.
	print abs(relspeed:z).
	print abs(relpos:z).
}

set ship:control:fore to 0.
lock throttle to 0.