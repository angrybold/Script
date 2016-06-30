//Known State.
	RCS on.
	SAS off.

//Inclination nullen

	if abs(ship:orbit:inclination-target:orbit:inclination) > 0.05 {
	
		Print "Inclination wird angepasst".

		set angulartarget to vcrs(target:velocity:orbit,target:position-ship:body:position).
		lock relpos to body:position * angulartarget:direction:inverse.
		lock relspeed to velocity:orbit * angulartarget:direction:inverse.
		lock timeto to abs(relpos:z)/abs(relspeed:z).
		
		set warp to 5.
		wait until relpos:z/abs(relpos:z)*relspeed:z/abs(relspeed:z) = -1.
		set warp to 0.


		set richtungsflag to -relpos:z/abs(relpos:z).
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

			if abs(relpos:z) < 500 {
				set tempo to 5.
			}
			
			if abs(relpos:z) < 100 {
				set tempo to 2.5.
			}

			if abs(relpos:z) < 20 {
				set tempo to 1.
			}	
			
			if abs(relpos:z) < 5 {
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
		
	}
	
	Print "Inclination im Rahmen".

	
//Abpassen
	
	Print "Passe Ziel ab".
	
	lock steering to lookdirup(ship:orbit:velocity:orbit,ship:facing:topvector).
	
	set tposdif to target:orbit:trueanomaly + target:orbit:argumentofperiapsis - ship:orbit:argumentofperiapsis - ship:orbit:trueanomaly.
	if tposdif > 360 {set tposdif to tposdif - 360.}
	set ttimedif to -ship:orbit:period * tposdif / 360 * (ship:orbit:period /target:orbit:period).
	set ttimeshift to (target:orbit:period - ship:orbit:period) * (ship:orbit:period /target:orbit:period).
	set n to 0.00000000001.


	until abs(ttimedif)/n < ship:orbit:period / 100 or abs(ship:orbit:period-ttimedif)/n < ship:orbit:period / 100{
		
		set n to n + 1.
		set ttimedif to ttimedif + ttimeshift.
		if ttimedif > ship:orbit:period {
			set ttimedif to ttimedif - ship:orbit:period.
		}
		else if ttimedif < 0 {
			set ttimedif to ttimedif + ship:orbit:period.
		}
	}
	
	print ttimedif.
	print abs(ship:orbit:period-ttimedif).
	
	if ttimedif/n < ship:orbit:period / 100 {
		set tvz to 1.
	}

	else {
		set tvz to -1.
	}


	set timechange to min(abs(ship:orbit:period-ttimedif)/n,ttimedif/n).

	print n .
	print timechange.
	set desperiod to ship:orbit:period + tvz*timechange.
	wait 5.
	wait until ship:angularmomentum:mag < 0.01.


	until abs(ship:orbit:period - desperiod) < 0.1 {
		if ship:orbit:period < desperiod {
			set ship:control:fore to 1.
			print abs(ship:orbit:period - desperiod).
		}
		else {
			set ship:control:fore to -1.
			print abs(ship:orbit:period - desperiod).
		}
	}

	set ship:control: neutralize to true.

	wait 2.

	warpto(time:seconds + (n-0.25) * ship:orbit:period ).
	
	
//Abbremsen und in die Nähe bringen
	
	lock trgtspeedvec to (ship:orbit:velocity:orbit-target:orbit:velocity:orbit).
	lock steering to lookdirup(-trgtspeedvec,ship:facing:topvector).
	
	set lastdist to target:position:mag + 1000.
	until lastdist < target:position:mag {
		set lastdist to target:position:mag.
	}
	
	lock throttle to 1.
	wait until trgtspeedvec:mag < 0.5.
	lock throttle to 0.
	
	lock steering to lookdirup(target:position,ship:facing:topvector).
	wait 2.
	wait until ship:angularmomentum:mag < 0.01.
	
	set ship:control:fore to 1.
	wait until trgtspeedvec:mag > 5.
	set ship:control:fore to 0.
	
	lock steering to lookdirup(trgtspeedvec,ship:facing:topvector).
	set lastdist to target:position:mag + 10.
	until lastdist < target:position:mag or target:position:mag < 150{
		set lastdist to target:position:mag.
	}
	
	set ship:control:fore to -1.
	wait until trgtspeedvec:mag < 0.5.
	set ship:control:fore to 0.



