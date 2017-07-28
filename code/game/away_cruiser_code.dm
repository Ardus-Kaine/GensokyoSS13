/////////////////////////cruiser radios relay\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/obj/machinery/telecomms/relay/preset/cruiser
	id = "NanoTrasen Cruiser"
	hide = 1
	toggled = 0
	autolinkers = list("cr_relay")

/////////////////////////cruiser hazmat suit\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/obj/item/weapon/rig/hazmat/engine
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/meson
	)

	allowed = list(/obj/item/rig_module/vision/meson,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/weapon/storage/box/excavation,/obj/item/weapon/pickaxe,/obj/item/device/healthanalyzer,/obj/item/device/measuring_tape,/obj/item/device/ano_scanner,/obj/item/device/depth_scanner,/obj/item/device/core_sampler,/obj/item/device/gps,/obj/item/device/beacon_locator,/obj/item/device/radio/beacon,/obj/item/weapon/pickaxe/hand,/obj/item/weapon/storage/bag/fossils)

	req_access = null
	req_one_access = null

//////////////////////////filled phoron tank\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/obj/item/weapon/tank/phoron/filled

/obj/item/weapon/tank/phoron/filled/New()
	..()

	src.air_contents.adjust_gas("phoron", (10*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C))
	return


/////////////////////////////////////////////Filled Phoron Tank Dispenser\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/obj/structure/filled_dispenser

	name = "tank storage unit"
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to ten oxygen tanks, and ten phoron tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	density = 1
	anchored = 1.0
	var/oxygentanks = 10
	var/phorontanks = 10
	var/list/oxytanks = list()	//sorry for the similar var names
	var/list/platanks = list()

/obj/structure/filled_dispenser/update_icon()
	overlays.Cut()
	switch(oxygentanks)
		if(1 to 3)	overlays += "oxygen-[oxygentanks]"
		if(4 to INFINITY) overlays += "oxygen-4"
	switch(phorontanks)
		if(1 to 4)	overlays += "phoron-[phorontanks]"
		if(5 to INFINITY) overlays += "phoron-5"

/obj/structure/filled_dispenser/attack_ai(mob/user as mob)
	if(user.Adjacent(src))
		return attack_hand(user)
	..()

/obj/structure/filled_dispenser/attack_hand(mob/user as mob)
	user.set_machine(src)
	var/dat = "[src]<br><br>"
	dat += "Oxygen tanks: [oxygentanks] - [oxygentanks ? "<A href='?src=\ref[src];oxygen=1'>Dispense</A>" : "empty"]<br>"
	dat += "Phoron tanks: [phorontanks] - [phorontanks ? "<A href='?src=\ref[src];phoron=1'>Dispense</A>" : "empty"]"
	user << browse(dat, "window=dispenser")
	onclose(user, "dispenser")
	return


/obj/structure/filled_dispenser/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/tank/oxygen) || istype(I, /obj/item/weapon/tank/air) || istype(I, /obj/item/weapon/tank/anesthetic))
		if(oxygentanks < 10)
			user.drop_item()
			I.loc = src
			oxytanks.Add(I)
			oxygentanks++
			user << "<span class='notice'>You put [I] in [src].</span>"
			if(oxygentanks < 5)
				update_icon()
		else
			user << "<span class='notice'>[src] is full.</span>"
		updateUsrDialog()
		return
	if(istype(I, /obj/item/weapon/tank/phoron/filled))
		if(phorontanks < 10)
			user.drop_item()
			I.loc = src
			platanks.Add(I)
			phorontanks++
			user << "<span class='notice'>You put [I] in [src].</span>"
			if(oxygentanks < 6)
				update_icon()
		else
			user << "<span class='notice'>[src] is full.</span>"
		updateUsrDialog()
		return
	if(istype(I, /obj/item/weapon/wrench))
		if(anchored)
			user << "<span class='notice'>You lean down and unwrench [src].</span>"
			anchored = 0
		else
			user << "<span class='notice'>You wrench [src] into place.</span>"
			anchored = 1
		return

/obj/structure/filled_dispenser/Topic(href, href_list)
	if(usr.stat || usr.restrained())
		return
	if(Adjacent(usr))
		usr.set_machine(src)
		if(href_list["oxygen"])
			if(oxygentanks > 0)
				var/obj/item/weapon/tank/oxygen/O
				if(oxytanks.len == oxygentanks)
					O = oxytanks[1]
					oxytanks.Remove(O)
				else
					O = new /obj/item/weapon/tank/oxygen(loc)
				O.loc = loc
				usr << "<span class='notice'>You take [O] out of [src].</span>"
				oxygentanks--
				update_icon()
		if(href_list["phoron"])
			if(phorontanks > 0)
				var/obj/item/weapon/tank/phoron/filled/P
				if(platanks.len == phorontanks)
					P = platanks[1]
					platanks.Remove(P)
				else
					P = new /obj/item/weapon/tank/phoron/filled(loc)
				P.loc = loc
				usr << "<span class='notice'>You take [P] out of [src].</span>"
				phorontanks--
				update_icon()
		add_fingerprint(usr)
		updateUsrDialog()
	else
		usr << browse(null, "window=dispenser")
		return
	return





/////////////////////////////cruiser areas\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/*
/area/away_cruiser
	name = "\improper Cruiser Bridge"
	icon = 'icons/turf/areas.dmi'
	icon_state = "cruiser_bridge"

/area/away_cruiser/cruiser_bridge
	name = "\improper Cruiser Bridge"
	icon_state = "cruiser_bridge"

/area/away_cruiser/cruiser_engine
	name = "\improper Cruiser Engine"
	icon_state = "cruiser_engine"

/area/away_cruiser/cruiser_dorms
	name = "\improper Cruiser Dorms"
	icon_state = "cruiser_dorms"

/area/away_cruiser/cruiser_med
	name = "\improper Cruiser Medbay"
	icon_state = "cruiser_med"

/area/away_cruiser/cruiser_gateway
	name = "\improper Cruiser Gateway"
	icon_state = "cruiser_gateway"

/area/away_cruiser/cruiser_atmos
	name = "\improper Cruiser Atmospherics"
	icon_state = "cruiser_atmos"

/area/away_cruiser/cruiser_hall
	name = "\improper Cruiser Hallway"
	icon_state = "cruiser_hall"

/area/away_cruiser/cruiser_power
	name = "\improper Cruiser Electronics"
	icon_state = "cruiser_power"
*/

////////////////////////Fancy's Gravy\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/area/grave
	icon = 'icons/turf/cruiser_areas.dmi'
	requires_power = 0
	unlimited_power = 1

/area/grave/asteroid
	name = "\improper Asteroid"
	icon_state = "fancy_asteroid"

/area/grave/asteroid/core
	name = "\improper Asteroid Core"
	icon_state = "fancy_core"

////////////////////More Areas\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/area/engine/engine_solars
		name = "\improper Engine Solar Array"
		icon_state = "engine"
		requires_power = 1
		always_unpowered = 1
		luminosity = 1
		lighting_use_dynamic = 0
