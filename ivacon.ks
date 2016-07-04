
clearscreen.
print "...booting up..." at (11,1).


set BUTTON0LABEL to "[#222222]AFFIRM".
set BUTTON1LABEL to "[#222222] NEG ".
set BUTTON2LABEL to "[#222222]LEFT".
set BUTTON3LABEL to "[#222222]RGHT".
set BUTTON4LABEL to "[#222222] UP ".
set BUTTON5LABEL to "[#222222]DOWN ".
set BUTTON7LABEL to "[#222222]LNCH ".
set BUTTON8LABEL to "[#222222]CIRC ".
set BUTTON9LABEL to "[#222222]MNVR ".
set BUTTON10LABEL to "[#222222]NODE ".
set BUTTON11LABEL to "[#222222]RDVZ ".
set BUTTON12LABEL to "[#222222]DOCK ".
set BUTTON13LABEL to "[#222222]LAND".


set FLAG0LABELINACT to "ACTV".
set FLAG1LABELINACT to "OKAY".
set FLAG2LABELINACT to "BURN".
set FLAG3LABELINACT to "WARP".
set FLAG4LABELINACT to "WAIT".
set FLAG5LABELINACT to "INPT".
set FLAG6LABELINACT to "DNGR".
set FLAG7LABELINACT to "WARN".
set FLAG8LABELINACT to "FAIL".
set FLAG9LABELINACT to "FUCK".
set FLAG10LABELINACT to "AAH!".
set FLAG11LABELINACT to "WTF?".
set FLAG12LABELINACT to "GAME".
set FLAG13LABELINACT to "OVER".

set FLAG0LABELACT to "[#00FF00]ACTV".
set FLAG1LABELACT to "[#00FF00]OKAY".
set FLAG2LABELACT to "[#1EFAEF]BURN".
set FLAG3LABELACT to "[#1EFAEF]WARP".
set FLAG4LABELACT to "[#FFFFFF]WAIT".
set FLAG5LABELACT to "[#FFFF00]INPT".
set FLAG6LABELACT to "[#FF0000]DNGR".
set FLAG7LABELACT to "[#FFFF00]WARN".
set FLAG8LABELACT to "[#F58505]FAIL".
set FLAG9LABELACT to "[#F58505]FUCK".
set FLAG10LABELACT to "[#1EFAEF]AAH!".
set FLAG11LABELACT to "[#FA05C9]WTF?".
set FLAG12LABELACT to "[#FFFFFF]GAME".
set FLAG13LABELACT to "[#FFFFFF]OVER".

set FLAG0LABEL to FLAG0LABELINACT.
set FLAG1LABEL to FLAG1LABELINACT.
set FLAG2LABEL to FLAG2LABELINACT.
set FLAG3LABEL to FLAG3LABELINACT.
set FLAG4LABEL to FLAG4LABELINACT.
set FLAG5LABEL to FLAG5LABELINACT.
set FLAG6LABEL to FLAG6LABELINACT.
set FLAG7LABEL to FLAG7LABELINACT.
set FLAG8LABEL to FLAG8LABELINACT.
set FLAG9LABEL to FLAG9LABELINACT.
set FLAG10LABEL to FLAG10LABELINACT.
set FLAG11LABEL to FLAG11LABELINACT.
set FLAG12LABEL to FLAG12LABELINACT.
set FLAG13LABEL to FLAG13LABELINACT.

on FLAG0 {
  if FLAG0 { set FLAG0LABEL to FLAG0LABELACT. }
  else { set FLAG0LABEL to FLAG0LABELINACT. }
  return true.
}
on FLAG1 {
  if FLAG1 { set FLAG1LABEL to FLAG1LABELACT. }
  else { set FLAG1LABEL to FLAG1LABELINACT. }
  return true.
}
on FLAG2 {
  if FLAG2 { set FLAG2LABEL to FLAG2LABELACT. }
  else { set FLAG2LABEL to FLAG2LABELINACT. }
  return true.
}
on FLAG3 {
  if FLAG3 { set FLAG3LABEL to FLAG3LABELACT. }
  else { set FLAG3LABEL to FLAG3LABELINACT. }
  return true.
}
on FLAG4 {
  if FLAG4 { set FLAG4LABEL to FLAG4LABELACT. }
  else { set FLAG4LABEL to FLAG4LABELINACT. }
  return true.
}
on FLAG5 {
  if FLAG5 { set FLAG5LABEL to FLAG5LABELACT. }
  else { set FLAG5LABEL to FLAG5LABELINACT. }
  return true.
}
on FLAG6 {
  if FLAG6 { set FLAG6LABEL to FLAG6LABELACT. }
  else { set FLAG6LABEL to FLAG6LABELINACT. }
  return true.
}
on FLAG7 {
  if FLAG7 { set FLAG7LABEL to FLAG7LABELACT. }
  else { set FLAG7LABEL to FLAG7LABELINACT. }
  return true.
}
on FLAG8 {
  if FLAG8 { set FLAG8LABEL to FLAG8LABELACT. }
  else { set FLAG8LABEL to FLAG8LABELINACT. }
  return true.
}
on FLAG9 {
  if FLAG9 { set FLAG9LABEL to FLAG9LABELACT. }
  else { set FLAG9LABEL to FLAG9LABELINACT. }
  return true.
}
on FLAG10 {
  if FLAG10 { set FLAG10LABEL to FLAG10LABELACT. }
  else { set FLAG10LABEL to FLAG10LABELINACT. }
  return true.
}
on FLAG11 {
  if FLAG11 { set FLAG11LABEL to FLAG11LABELACT. }
  else { set FLAG11LABEL to FLAG11LABELINACT. }
  return true.
}
on FLAG12 {
  if FLAG12 { set FLAG12LABEL to FLAG12LABELACT. }
  else { set FLAG12LABEL to FLAG12LABELINACT. }
  return true.
}
on FLAG13 {
  if FLAG13 { set FLAG13LABEL to FLAG13LABELACT. }
  else { set FLAG13LABEL to FLAG13LABELINACT. }
  return true.
}

set FLAG0 to true.
wait 0.5.
set FLAG0 to false.
set FLAG1 to true.
wait 0.5.
set FLAG1 to false.
set FLAG2 to true.
wait 0.5.
set FLAG2 to false.
set FLAG3 to true.
wait 0.5.
set FLAG3 to false.
set FLAG4 to true.
wait 0.5.
set FLAG4 to false.
set FLAG5 to true.
wait 0.5.
set FLAG5 to false.
set FLAG6 to true.
wait 0.5.
set FLAG6 to false.
set FLAG7 to true.
wait 0.5.
set FLAG7 to false.
set FLAG8 to true.
wait 0.5.
set FLAG8 to false.
set FLAG9 to true.
wait 0.5.
set FLAG9 to false.
set FLAG10 to true.
wait 0.5.
set FLAG10 to false.
set FLAG11 to true.
wait 0.5.
set FLAG11 to false.
set FLAG12 to true.
wait 0.5.
set FLAG12 to false.
set FLAG13 to true.
wait 0.5.
set FLAG13 to false.

wait 1.
clearscreen.
print "[#FFFFFF]Initialisiere Module.".

wait 1.
print "Launch and ascent".
on BUTTON7 {
  if BUTTON7 {
    //clearscreen.
  
    set FLAG0 to true. // ACTV
    //set FLAG4 to true. // WAIT
    //set FLAG5 to true. // INPT
	
	
	// Setze Merker
    //set FLAG5 to false.
    //set FLAG4 to false.
	
	//clearscreen.
	//print "[#FFFFFF]LAUNCH-Vorbereitung" at (0,1).
	//print "Parametereingabe" at (0,2).
	
	//set orbithoehe to 250.
	//set inklination to abs(latitude).
	//set endburn to 0.
	
	// TODO Parametereingabe
	//set bestaetigt to false.
	//until bestaetigt {
	//}
	
	// Fuehre Programm aus
    run launch.
	
	// Setze Merker
    set FLAG0 to false.
	set BUTTON7 to false.
  }
  return true.
}
set BUTTON7LABEL to "LNCH ".
wait 2.

print "Orbit circularization".
on BUTTON8 {
  if BUTTON8 {
    run circorbit.
	set BUTTON8 to false.
  }
  return true.
}
set BUTTON8LABEL to "CIRC ".
wait 2.

print "Maneuver autopilot".
on BUTTON9 {
  if BUTTON9 {
    run maneuvernode.
	set BUTTON9 to false.
  }
  return true.
}
set BUTTON9LABEL to "MNVR ".
wait 2.

print "Node adjustment".
on BUTTON10 {
  if BUTTON10 {
    run node.
	set BUTTON10 to false.
  }
  return true.
}
set BUTTON10LABEL to "NODE ".
wait 2.

print "Rendezvous".
on BUTTON11 {
  if BUTTON11 {
    run rendezvous.
	set BUTTON11 to false.
  }
  return true.
}
set BUTTON11LABEL to "RDVZ ".
wait 2.

print "Docking autopilot".
on BUTTON12 {
  if BUTTON12 {
    run once portauswahl.
	waehleports().
	print "[#ff0000]DOCKING NOCH NICHT IMPLEMENTIERT.".
	set FLAG8 to true.
	set FLAG9 to true.
	set BUTTON12 to false.
  }
  return true.
}
set BUTTON12LABEL to "DOCK ".
wait 2.

print "Landing autopilot".
on BUTTON13 {
  if BUTTON13 {
    run lander.
	set BUTTON13 to false.
  }
  return true.
}
set BUTTON13LABEL to "LAND".
wait 2.

set BUTTON0LABEL to "[#00FF00]AFFIRM".
set BUTTON1LABEL to "[#FF0000] NEG ".
set BUTTON2LABEL to "LEFT".
set BUTTON3LABEL to "RGHT".
set BUTTON4LABEL to " UP ".
set BUTTON5LABEL to "DOWN ".
set BUTTON10LABEL to "NODE ".
set BUTTON11LABEL to "RDVZ ".
set BUTTON12LABEL to "DOCK ".
set BUTTON13LABEL to "LAND".

clearscreen.
set exit to false.
until exit {
  print "System on-line" at (13,1).
  print "Select program to run" at (10,2).
  print "To exit, press [#880000]STBY" at (11,3).
  wait 1.
}.