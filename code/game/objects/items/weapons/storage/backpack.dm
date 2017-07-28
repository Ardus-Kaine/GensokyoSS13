
/*
 * Backpack
 */

/obj/item/weapon/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_backpacks.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_backpacks.dmi',
		)
	icon_state = "backpack"
	item_state = null
	//most backpacks use the default backpack state for inhand overlays
	item_state_slots = list(
		slot_l_hand_str = "backpack",
		slot_r_hand_str = "backpack",
		)
	sprite_sheets = list(
		"Resomi" = 'icons/mob/species/resomi/back.dmi'
		)
	w_class = 4
	slot_flags = SLOT_BACK
	max_w_class = 4
	max_storage_space = 28

/obj/item/weapon/storage/backpack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..()

/obj/item/weapon/storage/backpack/equipped(var/mob/user, var/slot)
	if (slot == slot_back && src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..(user, slot)

/*
/obj/item/weapon/storage/backpack/dropped(mob/user as mob)
	if (loc == user && src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..(user)
*/

/*
 * Backpack Types
 */

/obj/item/weapon/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = list(TECH_BLUESPACE = 4)
	icon_state = "holdingpack"
	max_w_class = 4
	max_storage_space = 56
	var/mob/user = null
	storage_cost = 29

	New()
		..()
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		/*if(istype(W, /obj/item/weapon/storage/backpack/holding) && !W.crit_fail)
			user << "\red The Bluespace interfaces of the two devices conflict and malfunction."
			del(W)
			return*/
			 //BoH+BoH=Singularity, commented out.

		if(istype(W, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/grab = W
			if(istype(grab.affecting, /mob/living/carbon/human) && istype(grab.assailant, /mob/living/carbon/human))
				if(grab.affecting.buckled)
					grab.affecting.buckled.unbuckle_mob()
				shoveIntoBag(grab.affecting, grab.assailant)
				grab.dropped()
			else
				if(!istype(grab.affecting, /mob/living/carbon/human))
					usr << "\red The bag of holding refuses to accept a simplistic lifeform such as this"
				if(!istype(grab.assailant, /mob/living/carbon/human))
					usr << "\red You fail to interface with the controls of the bag of holding"
			return
		..()

	//Please don't clutter the parent storage item with stupid hacks.
	can_be_inserted(obj/item/W as obj, stop_messages = 0)
		if(istype(W, /obj/item/weapon/storage/backpack/holding))
			return 1
		return ..()

	MouseDrop_T(var/atom/movable/C, mob/user)
		if(istype(C, /mob/living/carbon/human) && istype(user, /mob/living/carbon/human))
			if(user.buckled)
				user.buckled.unbuckle_mob()
			shoveIntoBag(C, user)
		else
			if(!istype(C, /mob/living/carbon/human) && istype(C, /mob))
				user << "\red The bag of holding refuses to accept a simplistic lifeform such as this"
			else
				if(istype(C, /obj/item/weapon))
					attackby(C, user)
				else
					user << "\red You feel as if that probably does not belong in a bag of holding"
			if(!istype(user, /mob/living/carbon/human))
				user << "\red You fail to inteface with the controls of the bag of holding"

		return

	proc/shoveIntoBag(var/mob/living/carbon/human/H, var/mob/living/carbon/human/user)

		var/num_crew_stored = 0
		for(var/turf/simulated/floor/bluespace/b in world)
			for(var/mob/m in b.contents)
				num_crew_stored++

		if(num_crew_stored == 10)
			num_crew_stored = 0
			for(var/turf/simulated/floor/bluespace/b in world)
				for(var/mob/m in b.contents)
					m.gib()
				for(var/obj/o in b.contents)
					if(istype(o, /obj/item/organ))
						del(o)

		if(num_crew_stored >= 8)
			user << "\red The bluespace doesn't seem to accept any more objects of this type at this time"
			return

		var/obj/item/crew_item/crew = new/obj/item/crew_item

		if(!can_be_inserted(crew))
			return

		if(src.contents.len == 7)
			user << "\blue The bag of holding is full, make some space."
			return

		var/start_one = user.loc
		var/start_two = H.loc

		if(user == H)
			user << "\blue You begin putting yourself into the bag of holding"
		else
			user << "\blue You begin putting [H.name] inside the bag of holding"
			H << "\red [user.name] is trying to put you inside a bag of holding!"

		sleep(20) //two seconds
		if(start_one == user.loc && start_two == H.loc)

			crew.contained = H
			crew.holding = src
			crew.name += H.name
			if(H.stat == DEAD)
				crew.name += "-DEAD"
			crew_items.Add(crew)

			if(user == H)
				H << "\red You crawl inside the bag of holding, for some reason"
				user.drop_from_inventory(src)
			else
				H << "\red You have been shoved into a bag of holding"

			for(var/obj/object in H.get_contents())
				if(istype(object, /obj/item/weapon/storage/backpack/holding))
					var/obj/item/weapon/storage/backpack/holding/hold = object
					H << "Your bag of holding shorts out"
					for (var/obj/O in hold.contents) //it broke, delete what was in it
						del(O)
					hold.icon_state = "brokenpack"
				else
					if(istype(object, /obj/item/weapon/disk/nuclear))
						H.drop_from_inventory(object)
						H << "\red It appears your nuclear disk did not make the trip with you!"
					else
						if(istype(object, /obj/item/device/radio) || istype(object, /obj/item/device/pda))
							H << "\red You check yourself and realize your [object.name] has been lost to the bluespace"
							if(istype(object, /obj/item/device/radio/headset))
								crew.radios.Add(object)
								H.drop_from_inventory(object)
								object.x = 1
								object.y = 1
								object.z = 2
							else
								if(istype(object, /obj/item/device/pda)) //what if they have more than one PDA?
									crew.PDAs.Add(object)
									H.drop_from_inventory(object)
									object.x = 1
									object.y = 1
									object.z = 2
								else
									del(object)
						else //10% chance //exclude IDs and backpacks from being taken so we're not being TOO dickish with it
							if(rand(0,9) == 9 && (!istype(object, /obj/item/weapon/storage/backpack) && !istype(object, /obj/item/weapon/card/id) && !istype(object, /obj/item/weapon/implant)))
								H << "\red You check yourself and realize your [object.name] has been lost to the bluespace"
								del(object) //does not yet exclude implants, have to decide that

			var/icon/human_icon = getFlatIcon(H, SOUTH) //I have no idea why this works
														//I have no idea how this works
														//Hell, I can't even find where they declare this proc
			human_icon.Scale(33,28)
			crew.icon = human_icon

			var/mob_found = 0
			for(var/turf/simulated/floor/bluespace/b in world)
				for(var/mob/m in b.contents)
					mob_found = 1
				if(!mob_found)
					H.x = b.x
					H.y = b.y
					H.z = b.z
					if(crew.PDAs.len > 0)
						for(var/obj/item/device/pda/PDA in PDAs)
							if(PDA.id)
								PDA.id.loc = H.loc
								PDA.id = null
					handle_item_insertion(crew)
					for(var/mob/M in viewers(usr, null))
						if(M != user)
							if(H == user)
								M.show_message("\blue [user.name] crawls into a bag of holding!")
							else
								M.show_message("\blue [user.name] shoves [H.name] into a bag of holding!")
					message_admins("[key_name_admin(user)] has shoved [key_name_admin(H)] into a bag of holding", 0, 1)
					break
				mob_found = 0
		else
			if(user == H)
				user << "\red You must stand still to put yourself in the bag"
				return
			else
				user << "\red You and your target must remain still to put anyone in the bag"
				H << "[user.name] fails to put you inside the bag of holding"
				return

			//CREW MUST BE ADDED TO BAG OR THEY DUN SPLODE

		return

/obj/item/weapon/storage/backpack/holding/verb/shakeBag()
	set name = "Shake Bag"
	set category = "Object"

	var/was_escaping = 0
	for(var/obj/O in src.contents)
		var/obj/item/crew_item/crew = null
		if(istype(O, /obj/item/crew_item))
			crew = O
			if(crew.escaping)
				was_escaping = 1
				crew.contained.Stun(8) //great time for stunning until a standing check is made
				crew.contained.Weaken(1)
				crew.contained << "\red <b>You feel a great rumbling, as if someone is shaking the bag</b>"
				crew.escaping = 0
	if(was_escaping)
		src.contents = shuffle(contents)
		usr << "\blue You visibly shake the bag, and the vibrations within momentarily cease"
		for(var/mob/M in range(7, src.user))
			if(src.user != M)
				M << "[src.user] vigorously shakes their bag of holding"
	else
		usr << "\red You fail to see the need to shake up the bag at the current moment"

/obj/item/weapon/storage/backpack/holding/dropped(mob/use as mob)
	src.user = null //bag being taken off by other people handled by human inventory class
	..()

/obj/item/weapon/storage/backpack/holding/pickup(mob/use)
	src.user = use
	..()

/obj/item/weapon/storage/backpack/santabag
	name = "\improper Santa's gift bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state = "giftbag"
	w_class = 4.0
	max_w_class = 3
	max_storage_space = 400 // can store a ton of shit!
	item_state_slots = null

/obj/item/weapon/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	icon_state = "cultpack"

/obj/item/weapon/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon_state = "clownpack"
	item_state_slots = null

/obj/item/weapon/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"
	item_state_slots = null

/obj/item/weapon/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"
	item_state_slots = null

/obj/item/weapon/storage/backpack/captain
	name = "captain's backpack"
	desc = "It's a special backpack made exclusively for officers."
	icon_state = "captainpack"
	item_state_slots = null

/obj/item/weapon/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."
	icon_state = "engiepack"
	item_state_slots = null

/obj/item/weapon/storage/backpack/toxins
	name = "laboratory backpack"
	desc = "It's a light backpack modeled for use in laboratories and other scientific institutions."
	icon_state = "toxpack"

/obj/item/weapon/storage/backpack/hydroponics
	name = "herbalist's backpack"
	desc = "It's a green backpack with many pockets to store plants and tools in."
	icon_state = "hydpack"

/obj/item/weapon/storage/backpack/genetics
	name = "geneticist backpack"
	desc = "It's a backpack fitted with slots for diskettes and other workplace tools."
	icon_state = "genpack"

/obj/item/weapon/storage/backpack/virology
	name = "sterile backpack"
	desc = "It's a sterile backpack able to withstand different pathogens from entering its fabric."
	icon_state = "viropack"

/obj/item/weapon/storage/backpack/chemistry
	name = "chemistry backpack"
	desc = "It's an orange backpack which was designed to hold beakers, pill bottles and bottles."
	icon_state = "chempack"

/*
 * Satchel Types
 */

/obj/item/weapon/storage/backpack/satchel
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "satchel"

/obj/item/weapon/storage/backpack/satchel/withwallet
	New()
		..()
		new /obj/item/weapon/storage/wallet/random( src )

/obj/item/weapon/storage/backpack/satchel_norm
	name = "satchel"
	desc = "A trendy looking satchel."
	icon_state = "satchel-norm"

/obj/item/weapon/storage/backpack/satchel_eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"
	item_state_slots = list(
		slot_l_hand_str = "engiepack",
		slot_r_hand_str = "engiepack",
		)

/obj/item/weapon/storage/backpack/satchel_med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"
	item_state_slots = list(
		slot_l_hand_str = "medicalpack",
		slot_r_hand_str = "medicalpack",
		)

/obj/item/weapon/storage/backpack/satchel_vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colours."
	icon_state = "satchel-vir"

/obj/item/weapon/storage/backpack/satchel_chem
	name = "chemist satchel"
	desc = "A sterile satchel with chemist colours."
	icon_state = "satchel-chem"

/obj/item/weapon/storage/backpack/satchel_gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colours."
	icon_state = "satchel-gen"

/obj/item/weapon/storage/backpack/satchel_tox
	name = "scientist satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel-tox"

/obj/item/weapon/storage/backpack/satchel_sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon_state = "satchel-sec"
	item_state_slots = list(
		slot_l_hand_str = "securitypack",
		slot_r_hand_str = "securitypack",
		)

/obj/item/weapon/storage/backpack/satchel_hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant related work."
	icon_state = "satchel_hyd"

/obj/item/weapon/storage/backpack/satchel_cap
	name = "captain's satchel"
	desc = "An exclusive satchel for officers."
	icon_state = "satchel-cap"
	item_state_slots = list(
		slot_l_hand_str = "satchel-cap",
		slot_r_hand_str = "satchel-cap",
		)

//ERT backpacks.
/obj/item/weapon/storage/backpack/ert
	name = "emergency response team backpack"
	desc = "A spacious backpack with lots of pockets, used by members of the Emergency Response Team."
	icon_state = "ert_commander"
	item_state_slots = list(
		slot_l_hand_str = "securitypack",
		slot_r_hand_str = "securitypack",
		)

//Commander
/obj/item/weapon/storage/backpack/ert/commander
	name = "emergency response team commander backpack"
	desc = "A spacious backpack with lots of pockets, worn by the commander of an Emergency Response Team."

//Security
/obj/item/weapon/storage/backpack/ert/security
	name = "emergency response team security backpack"
	desc = "A spacious backpack with lots of pockets, worn by security members of an Emergency Response Team."
	icon_state = "ert_security"

//Engineering
/obj/item/weapon/storage/backpack/ert/engineer
	name = "emergency response team engineer backpack"
	desc = "A spacious backpack with lots of pockets, worn by engineering members of an Emergency Response Team."
	icon_state = "ert_engineering"

//Medical
/obj/item/weapon/storage/backpack/ert/medical
	name = "emergency response team medical backpack"
	desc = "A spacious backpack with lots of pockets, worn by medical members of an Emergency Response Team."
	icon_state = "ert_medical"

/*
 * Dufflebag Types
 *Soon to be adddedd
 */
