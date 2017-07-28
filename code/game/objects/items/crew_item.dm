var/global/list/crew_items = list()

/obj/item/crew_item
	name = "Crew Member "
	desc = "It appears to be a member of the crew contained in bluespace"
	icon = 'icons/obj/items.dmi'//change icon later
	icon_state = "blueprints"
	w_class = 4.0
	var/mob/living/carbon/human/contained
	var/obj/item/weapon/storage/backpack/holding/holding
	var/escaping = 0
	var/list/radios = list()
	var/list/PDAs = list()
	//var/obj/item/device/radio/headset/radio = null
	//var/obj/item/device/pda/PDA = null

/obj/item/crew_item/on_exit_storage(obj/item/weapon/storage/S as obj)
	if(escaping)
		contained << "\blue You manage to free yourself from the bag of holding!"
	else
		contained << "\blue You have been pulled out of the bag of holding!"

	var/exit_loc = null
	var/obj/item/weapon/storage/backpack/holding/hold = S //should be guaranteed

	if(hold.user)
		exit_loc = hold.user.loc
	else
		exit_loc = hold.loc

	for(var/obj/object in get_turf(contained))
		if(!istype(object, /obj/item/organ) && !istype(object, /obj/effect))
			object.loc = exit_loc
	for(var/mob/mobs in get_turf(contained))
		mobs.loc = exit_loc

	if(PDAs.len > 0)
		for(var/obj/item/device/pda/PDA in PDAs)
			PDA.loc = exit_loc
			contained << "\blue You mysteriously find a PDA returned to you"
	if(radios.len >0)
		for(var/obj/item/device/radio/headset/radio in radios)
			radio.loc = exit_loc
			contained << "\blue You mysteriously find a headset returned to you"

	contained = null
	del(src)
	return

/obj/item/crew_item/Del()
	if(crew_items.Find(src))
		crew_items.Remove(src)
	if(contained && contained.z == 2)
		contained << "\red <b>YOU FEEL THE BLUESPACE AROUND YOU BEGIN TO TEAR APART</b>"
		contained.gib()
	..()
