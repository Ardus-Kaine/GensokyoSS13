/var/recolony = 0

/datum/admins/proc/recolony()
	set name = "Recolony Mode"
	set category = "Event Verbs"
	//recolony = 0
	recolony = !recolony
	usr << "Recolony mode is now [recolony ? "on" : "off"]"

/datum/spawnpoint/recolony
	display_name = "Asteroid"
	msg = "has been evactuated to the asteroid."

/datum/spawnpoint/recolony/New()
	..()
	turfs = latejoin_recolony