// Auf 'true' setzen, damit sich das Skript nach dem Ausfuehren selber loescht.
set loeschen to false.

// Ggf. neu hinzugekommene Dateien muessen in die folgende Liste eingetragen werden.
set dateiListe to list("burntime.ks","circorbit.ks","ispcurrent.ks","ivacon.ks","lander.ks","launch.ks","lib_gui_box.ks","lib_menu.ks","maneuvernode.ks","portauswahl.ks","rendezvous.ks","spec_char.ksm").

print "Kopiere "+dateiListe:length+" Dateien aus Archiv.".
wait 2. // Warte auf Initialisierung aller Teile.
set listenIterator to dateiListe:iterator.
listenIterator:reset().
until not listenIterator:next {
	print "Kopiere "+listenIterator:value.
	copy listenIterator:value from 0.
}
print "Dateien kopiert.".
list files.

if (loeschen = true) {
	print "Loesche Boot-Skript.".
	delete boot.ks.
}
print "Operation abgeschlossen.".
