
	add node(0,0,0,0).
	set nextnode:eta to 100.
	set stepcheck to 0.

	
	
on ag9 {
	set stepcheck to stepcheck + 1.
	preserve.
}

on ag8 {
	set nextnode:eta to nextnode:eta + orbit:period.
	preserve.
}

on ag7 {
	set nextnode:eta to nextnode:eta - orbit:period.
	preserve.
}

on ag6 {
	set nextnode:eta to eta:apoapsis.
	preserve.
}

on ag5 {
	set nextnode:eta to eta:periapsis.
	preserve.
}

until stepcheck = 1 {
	print "orbit:inclination " + nextnode:orbit:inclination at (1,1).
	print "orbit:periapsis " + nextnode:orbit:periapsis at (1,2).
	print "orbit:apoapsis " + nextnode:orbit:apoapsis at (1,3).
	
	if nextnode:orbit:hasnextpatch = true {
	print "nextpatch:inclination " + nextnode:orbit:nextpatch:inclination at (1,5).
	print "nextpatch:periapsis " + nextnode:orbit:nextpatch:periapsis at (1,6).
	print "nextpatch:apoapsis " + nextnode:orbit:nextpatch:apoapsis at (1,7).
	}
	
	wait 0.1.
	clearscreen.
}

RCS on.

if nextnode:deltav:mag > 5{
	clearscreen.
	print "fuehre maneuver aus".
	run maneuvernode.
}

else {
	clearscreen.
	set steervec to nextnode:deltav.
	lock steering to lookdirup(steervec,ship:facing:topvector).
	wait 20.
	remove nextnode.
	print "maneuver bitte manuell ausführen".
}


until stepcheck = 2 {
	print "orbit:inclination " + ship:orbit:inclination at (1,1).
	print "orbit:periapsis " + ship:orbit:periapsis at (1,2).
	print "orbit:apoapsis " + ship:orbit:apoapsis at (1,3).
	
	if orbit:hasnextpatch = true {
	print "nextpatch:inclination " + ship:orbit:nextpatch:inclination at (1,5).
	print "nextpatch:periapsis " + ship:orbit:nextpatch:periapsis at (1,6).
	print "nextpatch:apoapsis " + ship:orbit:nextpatch:apoapsis at (1,7).
	}
	
	wait 0.1.
	clearscreen.
}

set warp to 1.
