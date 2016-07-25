//Parameter.
	
	Parameter runmode is 1.
	Parameter sicherheitsabstand is 20.
	set ziel to target.

	
//Known State.

	run lib.
	run lib_gui_box.
	run lib_menu.
	RCS on.
	SAS off.


//Abbremsen und in die Nähe bringen - Runmode 1
	
	lock relgeschwindigkeit to (ship:orbit:velocity:orbit-ziel:orbit:velocity:orbit).
	lock zielvector to ziel:position - ziel:position:normalized * 180.
	
	if runmode = 1 {
		
		lock steering to lookdirup(-relgeschwindigkeit,ship:facing:topvector).
		
		wait until zielvector:mag < 20000.
		lock differenzvector to zielvector:normalized - relgeschwindigkeit/maneuvergeschwindigkeit.
		
		
		
		
		until ziel:position:mag < 200 {	
		
			set maneuvergeschwindigkeit to maneuvergeschwindigkeitFK(zielvector).
			
			if vang(relgeschwindigkeit, zielvector) < 1 and abs(relgeschwindigkeit:mag-maneuvergeschwindigkeit) < 0.1 {
				set ship:control:neutralize to true.
			}
	
			else {
				translate(differenzvector).
			}
		}
		
		lock throttle to 0.
		unlock steering.
		set ship:control:neutralize to true.
		set runmode to 2.
	}


//Andocken - Runmode 2
	
	if runmode = 2 {
		set portliste to waehleports(ziel).
		set meinport to portliste[0].
		set deinport to portliste[1].
		set maneuvergeschwindigkeit to 1.
		set rotation to 0.
		set finalapproach to 0.
		lock nodevector to deinport:nodeposition-meinport:nodeposition.
		lock relpos to -nodevector * deinport:portfacing:inverse.
		lock differenzvector to zielvector:normalized - relgeschwindigkeit/maneuvergeschwindigkeit.
		
		on ag4 {
			set rotation to rotation - 45.
			print "rotation gesetzt zu " + rotation.
			preserve.
		}
		
		on ag5 {
			set rotation to rotation + 45.
			print "rotation gesetzt zu " + rotation.
			preserve.
		}
		
		on ag9 {
			set finalapproach to 1.
		}

		
		lock steering to lookdirup(-deinport:portfacing:vector:normalized,deinport:facing:topvector * -angleaxis(rotation,deinport:portfacing:vector:normalized)).

		
		if nodevector:mag < sicherheitsabstand {
			
			print "check1".
			lock zielvector to nodevector - nodevector:normalized * sicherheitsabstand.
			
			until zielvector:mag < 5 {
			
				set maneuvergeschwindigkeit to maneuvergeschwindigkeitFK(zielvector).
			
				if vang(relgeschwindigkeit, zielvector) < 1 and abs(relgeschwindigkeit:mag-maneuvergeschwindigkeit) < 0.1 {
					set ship:control:neutralize to true.
				}
				
				else {
					translate(differenzvector).
				}
			}
		}
		
		set ship:control:neutralize to true.
		
		if relpos:z < 0 {
      
            print "check2".
			lock zielvector to nodevector + vcrs(deinport:portfacing:forevector, vcrs(deinport:portfacing:forevector,nodevector)):normalized * sicherheitsabstand.
			
			
			until zielvector:mag < 5 {
			
				set maneuvergeschwindigkeit to maneuvergeschwindigkeitFK(zielvector).
				
				if vang(relgeschwindigkeit, zielvector) < 1 and abs(relgeschwindigkeit:mag-maneuvergeschwindigkeit) < 0.1 {
					set ship:control:neutralize to true.
				}
				
				else {
					translate(differenzvector).
				}
				
			}
		}
        
        set ship:control:neutralize to true.
           
			print "check3".
         	lock zielvector to nodevector + deinport:portfacing:forevector:normalized * sicherheitsabstand.
			
			until zielvector:mag < 0.5 and finalapproach = 1 {
			
				set maneuvergeschwindigkeit to maneuvergeschwindigkeitFK(zielvector).
			
				if vang(relgeschwindigkeit, zielvector) < 1 and abs(relgeschwindigkeit:mag-maneuvergeschwindigkeit) < 0.1 {
					set ship:control:neutralize to true.
				}
				
				else {
					translate(differenzvector).
				}
			}
			
			set ship:control:neutralize to true.

			print "check4".
         	lock zielvector to nodevector.
			until nodevector:mag < 0.1 {
			
				set maneuvergeschwindigkeit to maneuvergeschwindigkeitFK(zielvector).
			
				if vang(relgeschwindigkeit, zielvector) < 1 and abs(relgeschwindigkeit:mag-maneuvergeschwindigkeit) < 0.1 {
					set ship:control:neutralize to true.
				}
				
				else {
					translate(differenzvector).
				}
			}			
		
		set ship:control:neutralize to true.
	}