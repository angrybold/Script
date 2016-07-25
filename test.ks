	run lib.
	parameter ziel is target.
	lock steering to lookdirup(ship:orbit:velocity:orbit,ship:facing:topvector).
	stillstand().
	
	add node(time:seconds+30,0,0,0).

	lock abstand to positionat(target,time:seconds + turns * nextnode:orbit:period):mag.
	set turnticker to 1.
	set turns to 1.
	set laststate to abstand + 1.
	
	until false {
		
		set ticker to 1.
		until abs(ticker) < 0.001 or abs(nextnode:prograde) > 20	{
			if laststate < abstand {
				set ticker to ticker / -2.
			}
			set laststate to abstand.
			set nextnode:prograde to nextnode:prograde + ticker.
		}	
		
		set ticker to ticker * -1.
		
		if abs(nextnode:prograde) > 20 {
			until laststate2 < abstand {
				set turns to turns + turnticker.
			}	
			set turnticker to turnticker * -1.
			set turns to turns + turnticker.
		}
		
		else {
			break.
		}
	}
	
	lock abstand to positionat(target,time:seconds + turns * nextnode:orbit:period):mag.
	set laststate to abstand +1.
	
	until nextnode:deltav:mag < 0.1{
		print abstand.
		print turns.
		wait 0.1.
		clearscreen.
		translate(nextnode:deltav).
	}
	
	set ship:control:neutralize to true.
	remove nextnode.
	wait 0.1.
	add node(time:seconds+turns*ship:orbit:period,0,0,0).