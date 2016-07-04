//
	Parameter phasenverschiebung is 0.
	set ziel to target.
	set zeitverschiebung to ziel:orbit:period/360*phasenverschiebung.
	

//Known State.
	RCS on.
	SAS off.
	
//Orbit anpassen
	
	run circorbit((ziel:orbit:periapsis+ziel:orbit:apoapsis)/2).

//Inclination nullen

	if abs(ship:orbit:inclination-ziel:orbit:inclination) > 0.05 {
	
		Print "Inclination wird angepasst".

		set angulartarget to vcrs(ziel:velocity:orbit,ziel:position-ship:body:position).
		lock relpos to body:position * angulartarget:direction:inverse.
		lock relspeed to velocity:orbit * angulartarget:direction:inverse.
		lock timeto to abs(relpos:z)/abs(relspeed:z).
		
		set warp to 5.
		wait until relpos:z/abs(relpos:z)*relspeed:z/abs(relspeed:z) = -1.
		set warp to 0.


		set richtungsflag to -relpos:z/abs(relpos:z).
		lock steering to lookdirup(richtungsflag * vcrs(ziel:orbit:velocity:orbit,ziel:position-ship:body:position),ship:facing:topvector).


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
		RCS on.
		wait 10.
		wait until ship:angularmomentum:mag < 0.01.


		set tempo to 40.

		until abs(relspeed:z) < 0.01 {

			if abs(relpos:z) < 500 {
				set tempo to 10.
			}
			
			if abs(relpos:z) < 100 {
				set tempo to 2.5.
			}

			if abs(relpos:z) < 20 {
				set tempo to 1.
			}	
			
			if abs(relpos:z) < 10 {
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
		
		set ship:control:neutralize to true.
		
	}
	
	Print "Inclination im Rahmen".

	
//Abpassen
	
	Print "Passe Ziel ab".
	
	lock steering to lookdirup(ship:orbit:velocity:orbit,ship:facing:topvector).
	wait 2.
	wait until ship:angularmomentum:mag < 0.01.
	
	set tposdif to ziel:orbit:trueanomaly + ziel:orbit:argumentofperiapsis - ship:orbit:argumentofperiapsis - ship:orbit:trueanomaly.
	if tposdif > 360 {set tposdif to tposdif - 360.}
	set ttimedif to -ship:orbit:period * tposdif / 360 * (ship:orbit:period /ziel:orbit:period) + zeitverschiebung.
	set ttimeshift to (ziel:orbit:period - ship:orbit:period) * (ship:orbit:period /ziel:orbit:period).
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
	lock steering to lookdirup(ship:orbit:velocity:orbit,ship:facing:topvector).
	wait 5.
	wait until ship:angularmomentum:mag < 0.01.
	RCS on.

	until abs(ship:orbit:period - desperiod) < 0.001 {
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

	warpto(time:seconds + n * ship:orbit:period - 200).
	set warpmark to time:seconds + n * ship:orbit:period - 200.
	
	
//Abbremsen und in die Nähe bringen
	
	wait until time:seconds > warpmark.
	lock trgtspeedvec to (ship:orbit:velocity:orbit-ziel:orbit:velocity:orbit).
	lock steering to lookdirup(-trgtspeedvec,ship:facing:topvector).
	wait 10.
	wait until ship:angularmomentum:mag < 0.01.
	
	set lastdist to ziel:position:mag + 1000.
	until lastdist < ziel:position:mag {
		set lastdist to ziel:position:mag.
	}
	
	lock throttle to 1.
	wait until trgtspeedvec:mag < 0.5.
	lock throttle to 0.
	
	set repeat to 1.
	
	until ziel:position:mag < 190 {
	
		lock steering to lookdirup(ziel:position,ship:facing:topvector).
		wait 2.
		wait until ship:angularmomentum:mag < 0.01.
		
		set ship:control:fore to 1.
		wait until trgtspeedvec:mag > 5/repeat or ziel:position:mag < 200 .
		set ship:control:fore to 0.
		
		lock steering to lookdirup(trgtspeedvec,ship:facing:topvector).
		wait 2.
		wait until ship:angularmomentum:mag <0.01.
		
		set lastdist to ziel:position:mag + 10.
		until lastdist < ziel:position:mag or ziel:position:mag < 180{
			set lastdist to ziel:position:mag.
		}
		
		set warp to 0.
		
		wait 2.
		wait until ship:angularmomentum:mag <0.01.
		set ship:control:fore to -1.
		
		wait until trgtspeedvec:mag < 0.1.
		set ship:control:fore to 0.
		
		set repeat to repeat*2.
	}
	
	


//Andocken

	run portauswahl.ks.
	set portliste to waehleports().
	set meinport to portliste[0].
	set deinport to portliste[1].

	
	set rota to 0.
	
	on ag4 {
		set vorabstand to 0.
	}
	on ag5 {
		set rota to rota - 15.
		preserve.
	}
	on ag6 {
		set rota to rota + 15.
		preserve.
	}
	
	set close to 0.
	set vorabstand to -100.
	set dividentx to 8.
	set dividenty to 8.
	set dividentz to 8.
	set speedx to 1.
	set speedy to 1.
	set speedz to 1.
	
	lock steering to lookdirup(-deinport:portfacing:vector:normalized,deinport:facing:topvector * R(0,0,rota)).
	wait 2.
	wait until ship:angularmomentum:mag < 0.01.
	
	lock relpos to deinport:position * deinport:portfacing:inverse * -R(0,0,rota).
	lock relspeed to (ship:orbit:velocity:orbit-ziel:orbit:velocity:orbit) * deinport:portfacing:inverse * -R(0,0,rota).
	
	lock seitvz to relpos:x/abs(relpos:x).
	lock hochvz to relpos:y/abs(relpos:y).
	lock vorvz to (relpos:z - vorabstand)/abs(relpos:z - vorabstand).
	
	
	if relpos:y > 0 {
		set ship:control:starboard to -relspeed:x/abs(relspeed:x).
		wait until abs(relspeed:x) > 1 or abs(relpos:x) > 100.
		set ship:control:starboard to 0.
		wait until abs(relpos:x) > 100.
		set ship:control:starboard to relspeed:x/abs(relspeed:x).
		wait until abs(relspeed:x) < 0.1.
		set ship:control:fore to -1.
		wait until relspeed:z > 1 or abs(relpos:z-vorabstand/2) < 10.
	}
	
	until false {
	

		//seitwärts
		
			if abs(relpos:x) < 1  {
				set speedx to 0.1.
				set dividentx to 1.
			}
			
			else if abs(relpos:x) < 5  {
				set speedx to 0.5.
				set dividentx to 4.
			}			
			
			else if abs(relpos:x) < 20  {
				set speedx to 1.
				set dividentx to 4.
			}			
		
			else if abs(relpos:x) < 100 {
				set speedx to 2.
				set dividentx to 8.
			}
			


			
			if abs(relspeed:x-speedx * seitvz) > speedx/dividentx {
			
				if relspeed:x > speedx * seitvz {
					set ship:control:starboard to 1.
				}
				
				else {
					set ship:control:starboard to -1.
				}
			}
			
			else {
					set ship:control:starboard to 0.
			}
			
			
		//hoch
		
			if abs(relpos:y) < 1  {
				set speedy to 0.1.
				set dividenty to 1.
			}

			else if abs(relpos:y) < 5  {
				set speedy to 0.5.
				set dividenty to 4.
			}			
			
			else if abs(relpos:y) < 20  {
				set speedy to 1.
				set dividenty to 8.
			}			

			else if abs(relpos:y) < 100 {
				set speedy to 2.
				set dividenty to 8.
			}
			


			
			if abs(relspeed:y-speedy * hochvz) > speedy/dividenty {
			
				if relspeed:y > speedy * hochvz {
					set ship:control:top to -1.
				}
				
				else {
					set ship:control:top to 1.
				}
			}
			
			else {
				set ship:control:top to 0.
			}
			
		
		//vorne
		
			if abs(relpos:z  - vorabstand) < 1   {
				set speedz to 0.1.
				set dividentz to 1.
			}		
			
			else if abs(relpos:z  - vorabstand) < 5   {
				set speedz to 0.2.
				set dividentz to 4.
			}		

			else if abs(relpos:z  - vorabstand) < 20 {
				set speedz to 0.5.
				set dividentz to 8.
			}			
		
			else if abs(relpos:z  - vorabstand) < 100   {
				set speedz to 1.
				set dividentz to 8.
			}
			

			
			if abs(relspeed:z-speedz * vorvz) > speedz/dividentz {
			
				if relspeed:z > speedz * vorvz {
					set ship:control:fore to 1.
				}
				
				else {
					set ship:control:fore to -1.
				}
			}
			
			else {
				set ship:control:fore to 0.
			}
				
	}




