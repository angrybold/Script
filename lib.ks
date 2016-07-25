				
				
				
		//Benutzt das RCS um in Richtung eines bestimmten Vectors zu translieren.	
				
				
				function translate {
					
					
					parameter transvec is v(0,0,0).
					
					if transvec:mag > 1 set transvec to transvec:normalized.
					
					
					set ship:control:fore 	to 		min(1,transvec * ship:facing:forevector).
					set ship:control:starboard to	min(1,transvec * ship:facing:starvector).
					set ship:control:top	to		min(1,transvec * ship:facing:topvector).
					
				}
				
				
		//Berechnet wie lange ein Burn für einen Wert dV bei aktueller Motorenkonfiguaration benötigt.
		
		
				function burntimeFK {
					parameter dV is nextnode:deltav:mag.
					set ispcurrent to ispcurrentFK().
					if ship:maxthrust > 0 {
						set mfinal to ship:mass * constant:E^(-dV / (ispcurrent * 9.81)).
						set mpropellant to ship:mass - mfinal.
						set burnpt to ship:maxthrust / (ispcurrent * 9.81).
						set burntime to mpropellant/burnpt.
					}	
					set timeto to burntime/2.
					return timeto.
				}
				
				
		//Berechnet den aktuellen spezifischen Impuls aller Maschinen zusammengenommen, in Abhängigkeit von Schubkraft.

				
				function ispcurrentFK {
					set totalenginethrust to 0.
					set ISPcurrent to 0.
					list engines in engineList.
					for eng in engineList {
						if eng:ignition = true {
							set totalenginethrust to totalenginethrust + eng:maxthrust.
							set ispcurrent to ((eng:vacuumISP*eng:maxthrust)+(ISPcurrent* (totalenginethrust-eng:maxthrust))) /totalenginethrust.
						}
					}	
					return ispcurrent.
				}	

				
		//Wartet auf Ausrichten des Schiffs.
		
		
				function stillstand {	
				
					parameter threshold is 0.5.
					
					set wert1 to 1.
					set wert2 to 1.
					set wert3 to 1.
					set wert4 to 1.
					set wert5 to 1.
				
					wait 2.

					until wert1 < threshold and wert2 < threshold and wert3 < threshold and wert4 < threshold and wert5 < threshold {
						wait 0.4.
						set wert5 to wert4.
						set wert4 to wert3.
						set wert3 to wert2.
						set wert2 to wert1.
						set wert1 to ship:angularmomentum:mag.
						
					}
				}


		//Führt die geplante Node aus.
		
		
				function maneuvernode {
					RCS on.
					SAS off.

					set ship:control:neutralize to true.
					set timeto to burntimeFK().

					WARPTO(time:seconds + nextnode:eta - timeto - 60).
					
					print timeto + 10.

					lock steering to lookdirup(nextnode:deltav,ship:facing:topvector).
					stillstand().

					if nextnode:deltav:mag > 10 {
						wait until nextnode:eta < timeto + 10.
						set ship:control:fore to 1.
						until nextnode:eta < timeto {translate(nextnode:deltav).}
						lock throttle to 1.
						set ship:control:fore to 0.
						wait until nextnode:deltav:mag < 5.
					}
						
					wait until nextnode:eta < timeto + 5 or nextnode:deltav:mag < 0.01.
					lock throttle to 0.
					set ship:control:fore to 1.

					set maneuvervec to nextnode:deltav.
					lock steering to lookdirup(maneuvervec,ship:facing:topvector).
					
					
					until nextnode:deltav:mag < 0.1 {
						
						translate(nextnode:deltav).
					}

					
					
					
					set ship:control:fore to 0.
					unlock steering.
					remove nextnode.
					lock throttle to 0.
				}
				
				
		// Gibt eine Liste freier Andockports des spezifizierten Typs (bzw. "egal") zurueck.
		
		
				function ermittlePorts {
					parameter schiff is ship.
					parameter portTyp is "egal".

					set rueckgabeListe to list().

					set andockportListe to schiff:dockingports.
					for andockPort in andockportListe {
						if (portTyp = "egal" or andockPort:nodetype = portTyp) {
							if(andockPort:state = "Ready") {
								rueckgabeListe:add(andockPort).
							}
						}
					}
					return rueckgabeListe.
				}

				
		//Hilft die gewollten Ports für das Andocken auszuwählen
		
		
				function waehlePorts {

					// Ziel
					parameter ziel is target.

					// Eigener Andockport
					parameter eigenerPort is "egal".
					
					// Konstanten
					set FORTFAHREN to "[fortfahren]".
					set ABBRUCH to "[abbrechen]".
					
					// Abbruchvariable
					//set fertig to 0.

					// Port ermitteln
					if (eigenerPort = "egal") {
					
						set portListe to ermittlePorts().
						if (portListe:LENGTH = 0) {
							// Nichts zu machen ...
							print "Andocken nicht moeglich -- kein passender freier Andockport am eigenen Schiff vorhanden.".
							return 1.
						}
						
						// Abbruch-Option hinzufuegen
						portListe:add(ABBRUCH).
						
						// Manuelle Portauswahl
						set eigenerPort to open_menu("Mit welchem Port andocken?",portListe).

						if (eigenerPort = ABBRUCH) {
						  print "Breche ab.".
						  return 1.
						}
						
						print "Eigenen Port ausgewaehlt: "+eigenerPort.
						
						set eigenerPortPfeil TO VECDRAW(
							eigenerPort:POSITION,
							(eigenerPort:portfacing:VECTOR*5),
							RGB(0,0,1),
							"",
							1.0,
							TRUE,
							0.2
						).
						
					}

					print "Gewaehltes Ziel ist vom Typ "+ziel:typename.
					set zielPort to "n/v".

					// Ziel pruefen
					if not (ziel:typename = "DockingPort") {
						print "Es ist kein Andockport als Ziel ausgewaehlt.".

						// Ist ein Schiff ausgewaehlt?
						if (ziel:typename = "Vessel") {
						
							// Suche nach Andockport
							set zielPortListe to ermittlePorts(ziel,eigenerPort:nodetype).
							
							// Abbrechen, wenn kein passender freier Port gefunden wurde
							if (zielPortListe:LENGTH = 0) {
								// Nichts zu machen ...
								print "Andocken nicht moeglich -- kein passender freier Andockport am Zielschiff vorhanden.".
								unset eigenerPortPfeil.
								return 1.
							}
							
							// Abbruch-Option hinzufuegen
							zielPortListe:add(ABBRUCH).
							
							// Manuelle Portauswahl
							set zielPort to open_menu("An welchen Port andocken?",zielPortListe).

							if (zielPort = ABBRUCH) {
								print "Breche ab.".
								unset eigenerPortPfeil.
								return 1.
							}
						
							print "Zielport ausgewaehlt: "+zielPort.
						
							set zielPortPfeil TO VECDRAW(
								zielPort:POSITION,
								(zielPort:portfacing:VECTOR*5),
								RGB(0,1,0),
								"",
								1.0,
								TRUE,
								0.2
							).
						}
					} else {
						set zielPort to ziel.
					}

					if (zielPort = "n/v") {
						// Nichts zu machen ...
						print "Andocken nicht moeglich -- kein passender freier Andockport am Ziel vorhanden.".
						unset eigenerPortPfeil.
						return 1.
					}

					set auswahl to open_menu("Mit den gewaehlten Ports fortfahren?",list(FORTFAHREN,ABBRUCH)).
					unset eigenerPortPfeil.
					unset zielPortPfeil.
					if (auswahl = ABBRUCH) {
						return 1.
					}
					
					return list(eigenerPort,zielPort).
				}
				
				
		//Legt eine Maneuvergschwindigkeit für normale RCS fest
		
		
				function maneuvergeschwindigkeitFK{
					
					Parameter zielvector.
					set distanz to zielvector:mag.
				
					if 	distanz			> 0.1 		set maneuvergeschwindigkeit to 0.11.
					if 	distanz 		> 2 		set maneuvergeschwindigkeit to 0.5.	
					if 	distanz 		> 20 		set maneuvergeschwindigkeit to 1.	
					if 	distanz			> 80 		set maneuvergeschwindigkeit to 3.	
					if 	distanz 		> 250 		set maneuvergeschwindigkeit to 5.
					if 	distanz			> 1000		set maneuvergeschwindigkeit to 10.
					if 	distanz			> 5000		set maneuvergeschwindigkeit to 25.
					
					return maneuvergeschwindigkeit.
				
				}


		//Errechnet , wie lange ein Schiff bei gegebener Geschwindigkeit für gegebene Strecke benötigt.
		
		
				function timetoFK {

					parameter distanz is 1.
					parameter geschwindigkeit is 1.
					
					set timeto to distanz / geschwindigkeit.
					return timeto.
					
				}

				
		//überprüft ob es bereit eine Node gibt.

				function hasnextnode {
					local testnode is node(time:seconds + 60*60*6*10000, 1 , 1, 1).
					add testnode.
					if nextnode = testnode {
						remove testnode.
						return false.
					}
					else {
						remove testnode.
						return true.
					}
				}
		
		
		//Passt die Inklination an.
		
		
				function inclination{
				
					Print "Inclination wird angepasst".
					parameter ziel is target.
					
					lock angulartarget to vcrs(ziel:velocity:orbit,ziel:position-ship:body:position):normalized.
					set ticker to ship:orbit:period / 32.
					set zeit to time:seconds + (ship:orbit:period/4) - (ship:orbit:period / 32).
					lock predicposition to positionat(ship, zeit) - body:position.
					lock predicquer to abs(predicposition * angulartarget).
					set laststate to  predicquer + 1.
					
					until abs(ticker) < 1 {
					
						if laststate < predicquer{
							set ticker to ticker/-2.
						}
						set laststate to predicquer.
						set zeit to zeit+ticker.
					}
					
					add node(zeit,0,0,0).
					set navvec to -velocityat(ship,zeit):orbit * angulartarget * angulartarget:normalized.
					set nextnode:prograde to navvec * -velocityat(ship,zeit):orbit:normalized.
					set nextnode:normal to navvec * vcrs(-velocityat(ship,zeit):orbit, up:vector):normalized.
					set nextnode:radialout to navvec * vcrs(vcrs(-velocityat(ship,zeit):orbit, up:vector):normalized, -velocityat(ship,zeit):orbit):normalized.
					maneuvernode().
					
				}
		
		
		
		//Macht einen Runden Orbit in definierter Höhe
		
		
				function circorbit {
				
					parameter orbitx is (periapsis + apoapsis)/2.
					
					if periapsis > orbitx {
						set orbitx to orbitx - 1000.
						add node(0,0,0,0).
						wait 0.1.
						set nextnode:eta to eta:apoapsis.
						set ticker to -32.
						set laststate to abs(nextnode:orbit:periapsis-orbitx) + 1.
						
						until abs(ticker) < 0.1 {
							if laststate < abs(nextnode:orbit:periapsis-orbitx) {
								set ticker to ticker/-2.
							}
							set laststate to abs(nextnode:orbit:periapsis-orbitx).
							set nextnode:prograde to nextnode:prograde + ticker.				
						}
						set orbitx to orbitx + 1000.
						maneuvernode().
					}
					
					if apoapsis < orbitx {
						set orbitx to orbitx + 1000.
						add node(0,0,0,0).
						wait 0.1.
						set nextnode:eta to eta:periapsis.
						set ticker to 32.
						set laststate to abs(nextnode:orbit:apoapsis-orbitx) + 1.
						
						until abs(ticker) < 0.1 {
							if laststate < abs(nextnode:orbit:apoapsis-orbitx) {
								set ticker to ticker/-2.
							}
							set laststate to abs(nextnode:orbit:apoapsis-orbitx).
							set nextnode:prograde to nextnode:prograde + ticker.
							wait 1.
						}
						set orbitx to orbitx - 1000.	
						maneuvernode().
					}
					
					set ticker to ship:orbit:period / 32.
					set zeit to time:seconds + (ship:orbit:period/4) - (ship:orbit:period / 32).
					lock predicposition to positionat(ship, zeit) - body:position.
					lock predicthoehe		to predicposition:mag - body:radius.
					set laststate 		to abs(orbitx-predicthoehe) + 1.
				
					until ticker < 1 {
						if laststate < abs(orbitx-predicthoehe) {
							set ticker to ticker /-2.
						}
						set laststate to abs(orbitx-predicthoehe).
						set zeit to zeit + ticker.
					}
				
					add node(zeit,0,0,0).
					wait 0.1.
					set nextnode:radialout to -velocityat(ship,zeit):orbit * predicposition:normalized.
					
					set ticker to 1.
					set laststate to abs(nextnode:orbit:periapsis-nextnode:orbit:apoapsis) + 1.
					
					until abs(ticker) < 0.001 {
						if laststate < abs(nextnode:orbit:periapsis-nextnode:orbit:apoapsis) {
							set ticker to ticker / -2.
						}
						set laststate to abs(nextnode:orbit:periapsis-nextnode:orbit:apoapsis).
						set nextnode:prograde to nextnode:prograde + ticker.
					}
					
					maneuvernode().
					
				}
		
		
		//Passt das Zielschiff ab.
		
				function meetup {
					parameter ziel is target.
					lock steering to lookdirup(ship:orbit:velocity:orbit,ship:facing:topvector).
					stillstand().
					
					add node(time:seconds+60,0,0,0).

					lock abstand to (positionat(ziel,time:seconds + turns * nextnode:orbit:period) - positionat(ship,time:seconds + turns * nextnode:orbit:period)):mag.
					set turnticker to 1.
					set turns to 1.
					set laststate to abstand + 1.
					set ticker to 5.
					
					print"check".
					
					until false {
						
						
						until abs(ticker) < 0.001 or abs(nextnode:prograde) > 25	{
							if laststate < abstand {
								set ticker to ticker / -2.
							}
							set laststate to abstand.
							set nextnode:prograde to nextnode:prograde + ticker.
							print abstand.
						}

						if abs(nextnode:prograde) > 25 set turns to turns + 1.

						else break.
						
						set nextnode:prograde to nextnode:prograde - ticker * 2.
					}
					
					set laststate to abstand +1.
					set timeticker to 10 / nextnode:orbit:period.
					
					until nextnode:deltav:mag < 0.1 {
						clearscreen.
						translate(nextnode:deltav).
						set laststate to abstand.
						set turns to turns + timeticker.
						if laststate < abstand set timeticker to timeticker * -1.

						print abstand.
						print turns.
					}
					
					print abstand.
					print turns.
					
					set ship:control:neutralize to true.
					remove nextnode.
					wait 0.1.
					
					add node(time:seconds+turns*ship:orbit:period,0,0,0).
					
				}
		
		
		
		
		
		