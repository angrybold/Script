
	set totalenginethrust to 0.
	set ISPcurrent to 0.
	list engines in engineList.
	for eng in engineList {
		if eng:ignition = true {
			set totalenginethrust to totalenginethrust + eng:maxthrust.
			set ISPcurrent to ((eng:vacuumISP*eng:maxthrust)+(ISPcurrent* (totalenginethrust-eng:maxthrust))) /totalenginethrust.
		}
	}	
	