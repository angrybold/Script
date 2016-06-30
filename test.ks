parameter orbitx is (((ship:body:rotationperiod^2)*constant:g*ship:body:mass/(4*(constant:pi^2)))^(1/3))-ship:body:radius.

print orbitx.

set warp to 5.
wait until abs(orbitx-altitude) < 10000.
set warp to 4.
wait until abs(orbitx-altitude) < 1000.
set warp to 3.
wait until abs(orbitx-altitude) < 500.
set warp to 0.

RCS on.
lock steering to ship:body:position.
wait 1.
wait until ship:angularmomentum:mag < 0.01.

until abs(ship:verticalspeed) < 0.01 {
	set ship:control:fore to ship:verticalspeed/abs(ship:verticalspeed).
}