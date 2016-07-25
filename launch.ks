//Startvorbereitung
	
	//known state
		
		clearscreen.
		set ship:control:pilotmainthrottle to 0.
		RCS off.
		SAS off.
		run lib.
		print "Startvorbereitungen beendet, beginne Countdown.".
		
	//parameter
	
		parameter orbitx is 300.								
		set orbitx to orbitx * 1000.						//Wegen den Nullen beim eingeben.
		
		parameter endburn is 1.										//Ob er zuende brennen soll
		
		parameter incl is abs(latitude).							//Die Steigung unseres Orbits kriegen wir ja eh von der Startrampe abhängig mit, ändern kostet Sprit, orbitalmechanischer schitt.
		set richtungsweiser to latitude/abs(latitude).				//Um festzulegen in welche Richtung(N/S) wir fliegen.

	
//Hauptprogramm
	
	//Countdown, Zündung, Schubaufbau, Startrampe klären
	
		set counter to 10.
		until counter < 2 and thrustcheck = 1 {
		
				if counter = 5 {
					stage.
					lock throttle to 1.
				}
				
				if counter < 6 {								//Ab Zündung checken, ob die aktiven Maschinen genug Schub aufgebaut haben.
					list engines in englist.
					set thrustcheck to 1.
					for eng in englist {
						if eng:ignition = true and eng:thrust/eng:availablethrust < 0.90 {
							set thrustcheck to 0.
						}
					}
				}
			
				print "Liftoff in t-" + counter.
				set counter to counter - 1.
				wait 1.
				
		}
		stage.
		print "Klammern geloest, Liftoff.".
		set Startrampenhoehe to alt:radar + 100.				//Nach oben, bis die Klammern frei sind.
		wait until alt:radar > Startrampenhoehe. 
		print "Klammern frei, Aufstieg beginnt.".
		
		
			
			
			
	//Erste Stage	

		set hori to 90.
		set vert to 90.
		set uebersteuern to 1.
		lock steering to heading(hori,vert).
		list engines in englist.
		set boostcheck to 0.
		
		//Erste Stage + Booster	
		
			until maxthrust = 0 {									//Wartet bis die erste Stage ausgebrannt ist.
			
				for eng in englist {								//Checkt nach ausgebrannten Boostern, entkoppelt diese wenn gefunden(im Staging beachten).
					if eng:flameout = true and boostcheck = 0 and eng:ignition = true {
						wait 1.
						if maxthrust <> 0 {
							stage.
							wait 1.
							set boostcheck to 1.
							print "Booster entkoppelt.".
						}
					}
				}
				
				if apoapsis/orbitx < 0.9 {
					set vert to 90-90*apoapsis/(orbitx*1.2).
				}
					else {
						set vert to 0.
					}
				
				if ship:orbit:inclination > incl{
					set uebersteuern to 0.
				}
				
				if uebersteuern = 0 {
					set hori to 90+ richtungsweiser*(ship:orbit:inclination*(1-(abs(latitude)/ship:orbit:inclination)^max(1,round(ship:orbit:inclination/10)))).		//Erklärung bei Bedarf einfragen
				}
				
				else {
					set hori to 90+richtungsweiser*(incl+30).							//Erstmal die Richtige Richtung einschlagen.
				}
			
			
			}
		
		
		//Abkoppeln und Zweite Stage.
			
			lock throttle to 0.
			wait 1.
			stage.
			print "Erste Stufe beendet, wird entkoppelt.".
			add node(0,0,0,0).
			set nextnode:eta to eta:apoapsis.
			lock steering to nextnode:deltav.
			rcs on.
			set burncheck to 0.
			
			
			

			set tvz to 1.
			set ticker to 128.
			set laststate to abs(nextnode:orbit:apoapsis/nextnode:orbit:periapsis) + 1.

			until ticker < 0.5 {

				if laststate < abs(nextnode:orbit:apoapsis-nextnode:orbit:periapsis) {
					set ticker to ticker/2.
					set tvz to tvz * -1.
				}
				set laststate to abs(nextnode:orbit:apoapsis-nextnode:orbit:periapsis).
				set nextnode:prograde to nextnode:prograde + ticker * tvz.

			}
			
			burntimeFK().															//Errechnet, wie lange der Burn dauern wird.
			
			wait until burntime/2 > nextnode:eta.									//Wartet, bis ein Schwellenwert erreicht is, zündet dann.
			
			stage.																	//Wegen Ullageboostern leicht zeitversetzt.
			print "Ullage-Booster gezündet, aktiviere zweite Stufe.".
			wait 2.
			lock throttle to 1.
			rcs off.
			wait 5.
			wait until apoapsis > 1.2 orbitx.

			if endburn = 0 {
				lock steering to lookdirup(ship:orbit:velocity:orbit,ship:facing:topvector).
				remove nextnode.
				wait until maxthrust = 0.
				lock throttle to 0.
			}
			
			else {
				unlock steering.
				remove nextnode.
				lock throttle to 0.
			}
			
			print "Aufstiegsequenz beendet. Willkommen im Weltraum.".
