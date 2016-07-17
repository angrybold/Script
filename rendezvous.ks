//Parameter.
	
	Parameter runmode is 1.
	Parameter sicherheitsabstand is 20.
	set ziel to target.

	

//Known State.

	run lib.
	RCS on.
	SAS off.
	

	
//Inclination nullen - Runmode 1

	if runmode = 1 {
	
		Print "Inclination wird angepasst".

		set angulartarget to vcrs(ziel:velocity:orbit,ziel:position-ship:body:position).
		lock relpos to body:position * angulartarget:direction:inverse.
		lock relspeed to velocity:orbit * angulartarget:direction:inverse.
		lock timeto to abs(relpos:z)/abs(relspeed:z).
		set relspeedvz to 1.
		if ship:orbit:inclination > 90 {
			set relspeedvz to -1.
		}
		
		set warp to 4.
		wait until relpos:z/abs(relpos:z)*relspeed:z/abs(relspeed:z) = relspeedvz * -1.
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
		stillstandFK.


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
				
				set ship:control:fore to 1.
				
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
		set runmode to 2.
		
		Print "Inclination im Rahmen".
	}
	
	
	

//Orbit anpassen - 		Runmode 2
	
	if runmode = 2 {
		print "Passe Orbits an".
		run circorbit((ziel:orbit:periapsis+ziel:orbit:apoapsis)/2).
		set runmode to 3.
	}

	
//Abpassen - 			Runmode 3
	
	if runmode = 3 {
		Print "Passe Ziel ab".
		
		lock steering to lookdirup(ship:orbit:velocity:orbit,ship:facing:topvector).
		stillstandFK.
		
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
		RCS on.
		lock steering to lookdirup(ship:orbit:velocity:orbit,ship:facing:topvector).
		stillstandFK.
	

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
		set warpmark to time:seconds + n * ship:orbit:period - 50.
		wait until time:seconds > warpmark.
		set runmode to 4.
	}	
	

//Abbremsen und in die Nähe bringen - Runmode 4
	
	lock relgeschwindigkeit to (ship:orbit:velocity:orbit-ziel:orbit:velocity:orbit).
	lock zielvector to ziel:position.
	
	if runmode = 4 {
		
		lock steering to lookdirup(-relgeschwindigkeit,ship:facing:topvector).
		stillstandFK.
		
		wait until zielvector:mag < 10000.
		set maneuvergeschwindigkeit to relgeschwindigkeit:mag.
		lock differenzvector to zielvector:normalized - relgeschwindigkeit/maneuvergeschwindigkeit.
		
		
		
		until relgeschwindigkeit:mag < 0.5 {	
		
			if vang(relgeschwindigkeit, zielvector) < 1 and abs(relgeschwindigkeit:mag-maneuvergeschwindigkeit) < 0.1 {
				set ship:control:neutralize to true.
			}
	
			else {
				translate(differenzvector).
			}
	
			if 	zielvector:mag 	< 200 	lock throttle to 1.	
			
		}
		
		lock throttle to 0.
		unlock steering.
		set ship:control:neutralize to true.
		set runmode to 5.
	}


//Andocken - Runmode 5
	
	if runmode = 5 {
		set portliste to waehleports().
		set meinport to portliste[0].
		set deinport to portliste[1].
		set maneuvergeschwindigkeit to 1.
		lock nodevector to deinport:nodeposition-meinport:nodeposition.
		lock relpos to -nodevector * deinport:portfacing:inverse.
		lock differenzvector to zielvector:normalized - relgeschwindigkeit/maneuvergeschwindigkeit.
		
		lock steering to lookdirup(-deinport:portfacing:vector:normalized,deinport:facing:topvector).
		wait 20.
		
		if nodevector:mag < sicherheitsabstand {
			
			print "check1".
			lock zielvector to nodevector - nodevector:normalized * sicherheitsabstand.
			
			until zielvector:mag < 1 {
				if vang(relgeschwindigkeit, zielvector) < 1 and abs(relgeschwindigkeit:mag-maneuvergeschwindigkeit) < 0.1 {
					set ship:control:neutralize to true.
				}
				
				else {
					translate(differenzvector).
				}
				
				maneuvergeschwindigkeitFK(zielvector).
			}
		}
		
		set ship:control:neutralize to true.
		
		if relpos:z < 0 {
      
            print "check2".
			lock zielvector to nodevector + vcrs(deinport:portfacing:forevector, vcrs(deinport:portfacing:forevector,nodevector)):normalized * sicherheitsabstand.
			until zielvector:mag < 1 {
				if vang(relgeschwindigkeit, zielvector) < 1 and abs(relgeschwindigkeit:mag-maneuvergeschwindigkeit) < 0.1 {
					set ship:control:neutralize to true.
				}
				
				else {
					translate(differenzvector).
				}
				
				maneuvergeschwindigkeitFK(zielvector).
			}
		}
        
        set ship:control:neutralize to true.
           
			print "check3".
         	lock zielvector to nodevector + deinport:portfacing:forevector:normalized * sicherheitsabstand.
			until zielvector:mag < 0.5 {
				if vang(relgeschwindigkeit, zielvector) < 1 and abs(relgeschwindigkeit:mag-maneuvergeschwindigkeit) < 0.1 {
					set ship:control:neutralize to true.
				}
				
				else {
					translate(differenzvector).
				}
				
				maneuvergeschwindigkeitFK(zielvector).
			}
			
			set ship:control:neutralize to true.

			print "check4".
         	lock zielvector to nodevector.
			until nodevector:mag < 0.1 {
				if vang(relgeschwindigkeit, zielvector) < 1 and abs(relgeschwindigkeit:mag-maneuvergeschwindigkeit) < 0.1 {
					set ship:control:neutralize to true.
				}
				
				else {
					translate(differenzvector).
				}
				
				maneuvergeschwindigkeitFK(zielvector).
			}			
		
		set ship:control:neutralize to true.
	}



