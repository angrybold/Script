parameter vorzeichen is 1.
RCS on.
SAS off.
lock steering to lookdirup(vcrs(ship:velocity:orbit,sun:position),vorzeichen*sun:position).
wait 2.
wait until ship:angularmomentum:mag < 0.01.
RCS off.
SAS on.
