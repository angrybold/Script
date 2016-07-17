				
				
				
		//Benutzt das RCS um in Richtung eines bestimmten Vectors zu translieren.	
				
				
				function translate {
					
					
					parameter transvec is v(0,0,0).
					
					if transvec:mag > 1 set transvec to transvec:normalized.
					
					
					set forestash 	to 	forestash	+	transvec * ship:facing:forevector.
					set starstash 	to 	starstash	+	transvec * ship:facing:starvector.
					set topstash 	to 	topstash	+	transvec * ship:facing:topvector.
					
					if abs(forestash) > 50 {
						set ship:control:fore to 		forestash/abs(forestash)	*	min(abs(forestash)/100,1).
						set forestash to forestash - 	forestash/abs(forestash)	*	min(abs(forestash)/100,1).
					}
					else set ship:control:fore to 0.
					
					if abs(starstash) > 50 {
						set ship:control:starboard to 	starstash/abs(starstash)	*	min(abs(starstash)/100,1).
						set starstash to starstash - 	starstash/abs(starstash)	*	min(abs(starstash)/100,1).
					}	
					else set ship:control:starboard to 0.	
					
					if abs(topstash) > 50 {
						set ship:control:top to 		topstash/abs(topstash)	*		min(abs(topstash)/100,1).
						set topstash to topstash - 		topstash/abs(topstash)	*		min(abs(topstash)/100,1).
					}	
					else set ship:control:top to 0.
					
				}
				
				set forestash 	to 0.
				set starstash 	to 0.
				set topstash 	to 0.
				
				
		//Berechnet wie lange ein Burn für einen Wert dV bei aktueller Motorenkonfiguaration benötigt.
		
		
				function burntimeFK {
					parameter dV is nextnode:deltav:mag.
					run ISPcurrent.
					if ship:maxthrust > 0 {
						set mfinal to ship:mass * constant:E^(-dV / (ISPcurrent * 9.81)).
						set mpropellant to ship:mass - mfinal.
						set burnpt to ship:maxthrust / (ISPcurrent * 9.81).
						set burntime to mpropellant/burnpt.
					}	
					set timeto to burntime/2.
				}
				
				
		//Berechnet den aktuellen spezifischen Impuls aller Maschinen zusammengenommen, in Abhängigkeit von Schubkraft.

				
				function ispcurrentFK {
					set totalenginethrust to 0.
					set ISPcurrent to 0.
					list engines in engineList.
					for eng in engineList {
						if eng:ignition = true {
							set totalenginethrust to totalenginethrust + eng:maxthrust.
							set ISPcurrent to ((eng:vacuumISP*eng:maxthrust)+(ISPcurrent* (totalenginethrust-eng:maxthrust))) /totalenginethrust.
						}
					}	
				}	

				
		//Wartet auf Ausrichten des Schiffs.
		
		
				function stillstand {	
					
					set wert1 to 1.
					set wert2 to 1.
					set wert3 to 1.
					set wert4 to 1.
					set wert5 to 1.
				
					wait 2.

					until (wert1+wert2+wert3+wert4+wert5) / 5 < 0.05 {
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
					burntime.

					WARPTO(time:seconds + nextnode:eta - timeto - 60).

					lock steering to lookdirup(nextnode:deltav,ship:facing:topvector).
					stillstand.

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

					wait until nextnode:deltav:mag < 5.
					set maneuvervec to nextnode:deltav.
					lock steering to lookdirup(maneuvervec,ship:facing:topvector).

					set lastmag to 99999999.
					until nextnode:deltav:mag > 0.1 {
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
					if 	distanz 		> 200 		set maneuvergeschwindigkeit to 5.
				
				}


		//Errechnet , wie lange ein Schiff bei gegebener Geschwindigkeit für gegebene Strecke benötigt.
		
		
				function timetoFK {

					parameter distanz is 1.
					parameter geschwindigkeit is 1.
					
					set timeto to distanz / geschwindigkeit.
					
				}


		