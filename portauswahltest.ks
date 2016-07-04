	run portauswahl.ks.
	set portliste to waehleports().
	set meinport to portliste[0].
	set deinport to portliste[1].
	set ziel to target.
	
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
	
		clearscreen.
		print relpos.
		print relspeed.
		
		

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