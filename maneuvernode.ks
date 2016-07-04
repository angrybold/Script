run burntime.
RCS on.
SAS off.
set ship:control:neutralize to true.


WARPTO(time:seconds + nextnode:eta - timeto - 100).

set maneuvervec to nextnode:deltav.
lock steering to lookdirup(maneuvervec,ship:facing:topvector).
wait 2.
wait until ship:angularmomentum:mag < 0.01.


if nextnode:deltav:mag > 10 {
	wait until nextnode:eta < timeto + 10.
	set ship:control:fore to 1.
	wait until nextnode:eta < timeto.
	lock throttle to 1.
	set ship:control:fore to 0.
	wait until nextnode:deltav:mag < 5.
}
	
wait until nextnode:eta < timeto + 5.
lock throttle to 0.
set ship:control:fore to 1.

wait until nextnode:deltav:mag < 5.
lock steering to lookdirup(ship:facing:forevector,ship:facing:topvector).

set lastmag to 99999999.
until nextnode:deltav:mag > lastmag {
	set lastmag to nextnode:deltav:mag.
}
set ship:control:fore to 0.
unlock steering.
remove nextnode.
