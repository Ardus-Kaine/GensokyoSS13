/* Parrots!
 * Contains
 * 		Defines
 *		Inventory (headset stuff)
 *		Attack responces
 *		AI
 *		Procs / Verbs (usable by players)
 *		Sub-types
 */

/*
 * Defines
 */

//Only a maximum of one action and one intent should be active at any given time.
//Actions
#define OWL_PERCH 1		//Sitting/sleeping, not moving
#define OWL_SWOOP 2		//Moving towards or away from a target
#define OWL_WANDER 4		//Moving without a specific target in mind

//Intents
#define OWL_STEAL 8		//Flying towards a target to steal it/from it
#define OWL_ATTACK 16	//Flying towards a target to attack it
#define OWL_RETURN 32	//Flying towards its perch
#define OWL_FLEE 64		//Flying away from its attacker


/mob/living/simple_animal/owl
	name = "\improper Owl"
	desc = "It has a look of more intelligence than most of the crew."
	icon = 'icons/mob/animal.dmi'
	icon_state = "owl_fly"
	icon_living = "owl_fly"
	icon_dead = "owl_dead"
	pass_flags = PASSTABLE
	small = 1

	speak = list("Hwhoooo","Hoo, hoo")
//	speak_emote = list("squawks","says","yells")
	emote_hear = list("hoots")
	emote_see = list("flaps its wings")

	speak_chance = 1//1% (1 in 100) chance every tick; So about once per 150 seconds, assuming an average tick is 1.5s
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/cracker/

	response_help  = "pets"
	response_disarm = "gently moves aside"
	response_harm   = "swats"
	stop_automated_movement = 1
	universal_speak = 1

	var/owl_state = OWL_WANDER //Hunt for a perch when created
	var/owl_sleep_max = 25 //The time the owl sits while perched before looking around. Mosly a way to avoid the owl's AI in life() being run every single tick.
	var/owl_sleep_dur = 25 //Same as above, this is the var that physically counts down
	var/owl_dam_zone = list("chest", "head", "l_arm", "l_leg", "r_arm", "r_leg") //For humans, select a bodypart to attack

	var/owl_speed = 5 //"Delay in world ticks between movement." according to byond. Yeah, that's BS but it does directly affect movement. Higher number = slower.
	var/owl_been_shot = 0 //Parrots get a speed bonus after being shot. This will deincrement every Life() and at 0 the owl will return to regular speed.

	var/list/speech_buffer = list()
	var/list/available_channels = list()

	//Headset for Poly to yell at engineers :)
	var/obj/item/device/radio/headset/ears = null

	//The thing the owl is currently interested in. This gets used for items the owl wants to pick up, mobs it wants to steal from,
	//mobs it wants to attack or mobs that have attacked it
	var/atom/movable/owl_interest = null

	//Parrots will generally sit on their pertch unless something catches their eye.
	//These vars store their preffered perch and if they dont have one, what they can use as a perch
	var/obj/owl_perch = null
	var/obj/desired_perches = list(/obj/structure/computerframe, 		/obj/structure/displaycase, \
									/obj/structure/bookcase,		/obj/machinery/teleport, \
									/obj/machinery/computer,			/obj/machinery/clonepod, \
									/obj/machinery/dna_scannernew,		/obj/machinery/telecomms, \
									/obj/machinery/nuclearbomb,			/obj/machinery/particle_accelerator, \
									/obj/machinery/recharge_station,	/obj/machinery/smartfridge, \
									/obj/machinery/suit_storage_unit)

	//Parrots are kleptomaniacs. This variable ... stores the item a owl is holding.
	var/obj/item/held_item = null


/mob/living/simple_animal/owl/New()
	..()
	if(!ears)
		var/headset = pick(null)
		ears = new headset(src)

	owl_sleep_dur = owl_sleep_max //In case someone decides to change the max without changing the duration var

	verbs.Add(/mob/living/simple_animal/owl/proc/steal_from_ground, \
			  /mob/living/simple_animal/owl/proc/steal_from_mob, \
			  /mob/living/simple_animal/owl/verb/drop_held_item_player, \
			  /mob/living/simple_animal/owl/proc/perch_player)


/mob/living/simple_animal/owl/death()
	if(held_item)
		held_item.loc = src.loc
		held_item = null
	walk(src,0)
	..()

/mob/living/simple_animal/owl/Stat()
	..()
	stat("Held Item", held_item)


/*
 * Attack responces
 */
//Humans, monkeys, aliens
/mob/living/simple_animal/owl/attack_hand(mob/living/carbon/M as mob)
	..()
	if(client) return
	if(!stat && M.a_intent == "hurt")

		icon_state = "owl_fly" //It is going to be flying regardless of whether it flees or attacks

		if(owl_state == OWL_PERCH)
			owl_sleep_dur = owl_sleep_max //Reset it's sleep timer if it was perched

		owl_interest = M
		owl_state = OWL_SWOOP //The owl just got hit, it WILL move, now to pick a direction..

		if(M.health < 50) //Weakened mob? Fight back!
			owl_state |= OWL_ATTACK
		else
			owl_state |= OWL_FLEE		//Otherwise, fly like a bat out of hell!
			drop_held_item(0)
	return

//Bullets
/mob/living/simple_animal/owl/bullet_act(var/obj/item/projectile/Proj)
	..()
	if(!stat && !client)
		if(owl_state == OWL_PERCH)
			owl_sleep_dur = owl_sleep_max //Reset it's sleep timer if it was perched

		owl_interest = null
		owl_state = OWL_WANDER //OWFUCK, Been shot! RUN LIKE HELL!
		owl_been_shot += 5
		icon_state = "owl_fly"
		drop_held_item(0)
	return


/*
 * AI - Not really intelligent, but I'm calling it AI anyway.
 */
/mob/living/simple_animal/owl/Life()
	..()

	//Sprite and AI update for when a owl gets pulled
	if(pulledby && stat == CONSCIOUS)
		icon_state = "owl_fly"
		if(!client)
			owl_state = OWL_WANDER
		return

	if(client || stat)
		return //Lets not force players or dead/incap owls to move

	if(!isturf(src.loc) || !canmove || buckled)
		return //If it can't move, dont let it move. (The buckled check probably isn't necessary thanks to canmove)


//-----SLEEPING
	if(owl_state == OWL_PERCH)
		if(owl_perch && owl_perch.loc != src.loc) //Make sure someone hasnt moved our perch on us
			if(owl_perch in view(src))
				owl_state = OWL_SWOOP | OWL_RETURN
				icon_state = "owl_fly"
				return
			else
				owl_state = OWL_WANDER
				icon_state = "owl_fly"
				return

		if(--owl_sleep_dur) //Zzz
			return

		else
			//This way we only call the stuff below once every [sleep_max] ticks.
			owl_sleep_dur = owl_sleep_max

			//Cycle through message modes for the headset
			if(speak.len)
				var/list/newspeak = list()

				if(available_channels.len && src.ears)
					for(var/possible_phrase in speak)

						//50/50 chance to not use the radio at all
						var/useradio = 0
						if(prob(50))
							useradio = 1

						if(copytext(possible_phrase,1,3) in department_radio_keys)
							possible_phrase = "[useradio?pick(available_channels):""] [copytext(possible_phrase,3,length(possible_phrase)+1)]" //crop out the channel prefix
						else
							possible_phrase = "[useradio?pick(available_channels):""] [possible_phrase]"

						newspeak.Add(possible_phrase)

				else //If we have no headset or channels to use, dont try to use any!
					for(var/possible_phrase in speak)
						if(copytext(possible_phrase,1,3) in department_radio_keys)
							possible_phrase = "[copytext(possible_phrase,3,length(possible_phrase)+1)]" //crop out the channel prefix
						newspeak.Add(possible_phrase)
				speak = newspeak

			//Search for item to steal
			owl_interest = search_for_item()
			if(owl_interest)
				visible_emote("looks in [owl_interest]'s direction and takes flight")
				owl_state = OWL_SWOOP | OWL_STEAL
				icon_state = "owl_fly"
			return

//-----WANDERING - This is basically a 'I dont know what to do yet' state
	else if(owl_state == OWL_WANDER)
		//Stop movement, we'll set it later
		walk(src, 0)
		owl_interest = null

		//Wander around aimlessly. This will help keep the loops from searches down
		//and possibly move the mob into a new are in view of something they can use
		if(prob(90))
			step(src, pick(cardinal))
			return

		if(!held_item && !owl_perch) //If we've got nothing to do.. look for something to do.
			var/atom/movable/AM = search_for_perch_and_item() //This handles checking through lists so we know it's either a perch or stealable item
			if(AM)
				if(istype(AM, /obj/item) || isliving(AM))	//If stealable item
					owl_interest = AM
					visible_emote("turns and flies towards [owl_interest]")
					owl_state = OWL_SWOOP | OWL_STEAL
					return
				else	//Else it's a perch
					owl_perch = AM
					owl_state = OWL_SWOOP | OWL_RETURN
					return
			return

		if(owl_interest && owl_interest in view(src))
			owl_state = OWL_SWOOP | OWL_STEAL
			return

		if(owl_perch && owl_perch in view(src))
			owl_state = OWL_SWOOP | OWL_RETURN
			return

		else //Have an item but no perch? Find one!
			owl_perch = search_for_perch()
			if(owl_perch)
				owl_state = OWL_SWOOP | OWL_RETURN
				return
//-----STEALING
	else if(owl_state == (OWL_SWOOP | OWL_STEAL))
		walk(src,0)
		if(!owl_interest || held_item)
			owl_state = OWL_SWOOP | OWL_RETURN
			return

		if(!(owl_interest in view(src)))
			owl_state = OWL_SWOOP | OWL_RETURN
			return

		if(in_range(src, owl_interest))

			if(isliving(owl_interest))
				steal_from_mob()

			else //This should ensure that we only grab the item we want, and make sure it's not already collected on our perch
				if(!owl_perch || owl_interest.loc != owl_perch.loc)
					held_item = owl_interest
					owl_interest.loc = src
					visible_message("[src] grabs the [held_item]!", "\blue You grab the [held_item]!", "You hear the sounds of wings flapping furiously.")

			owl_interest = null
			owl_state = OWL_SWOOP | OWL_RETURN
			return

		walk_to(src, owl_interest, 1, owl_speed)
		return

//-----RETURNING TO PERCH
	else if(owl_state == (OWL_SWOOP | OWL_RETURN))
		walk(src, 0)
		if(!owl_perch || !isturf(owl_perch.loc)) //Make sure the perch exists and somehow isnt inside of something else.
			owl_perch = null
			owl_state = OWL_WANDER
			return

		if(in_range(src, owl_perch))
			src.loc = owl_perch.loc
			drop_held_item()
			owl_state = OWL_PERCH
			icon_state = "owl_sit"
			return

		walk_to(src, owl_perch, 1, owl_speed)
		return

//-----FLEEING
	else if(owl_state == (OWL_SWOOP | OWL_FLEE))
		walk(src,0)
		if(!owl_interest || !isliving(owl_interest)) //Sanity
			owl_state = OWL_WANDER

		walk_away(src, owl_interest, 1, owl_speed-owl_been_shot)
		owl_been_shot--
		return

//-----ATTACKING
	else if(owl_state == (OWL_SWOOP | OWL_ATTACK))

		//If we're attacking a nothing, an object, a turf or a ghost for some stupid reason, switch to wander
		if(!owl_interest || !isliving(owl_interest))
			owl_interest = null
			owl_state = OWL_WANDER
			return

		var/mob/living/L = owl_interest

		//If the mob is close enough to interact with
		if(in_range(src, owl_interest))

			//If the mob we've been chasing/attacking dies or falls into crit, check for loot!
			if(L.stat)
				owl_interest = null
				if(!held_item)
					held_item = steal_from_ground()
					if(!held_item)
						held_item = steal_from_mob() //Apparently it's possible for dead mobs to hang onto items in certain circumstances.
				if(owl_perch in view(src)) //If we have a home nearby, go to it, otherwise find a new home
					owl_state = OWL_SWOOP | OWL_RETURN
				else
					owl_state = OWL_WANDER
				return

			//Time for the hurt to begin!
			var/damage = rand(5,10)

			if(ishuman(owl_interest))
				var/mob/living/carbon/human/H = owl_interest
				var/datum/organ/external/affecting = H.get_organ(ran_zone(pick(owl_dam_zone)))

				H.apply_damage(damage, BRUTE, affecting, H.run_armor_check(affecting, "melee"), sharp=1)
				visible_emote(pick("pecks [H]'s [affecting].", "cuts [H]'s [affecting] with its talons."))

			else
				L.adjustBruteLoss(damage)
				visible_emote(pick("pecks at [L].", "claws [L]."))
			return

		//Otherwise, fly towards the mob!
		else
			walk_to(src, owl_interest, 1, owl_speed)
		return
//-----STATE MISHAP
	else //This should not happen. If it does lets reset everything and try again
		walk(src,0)
		owl_interest = null
		owl_perch = null
		drop_held_item()
		owl_state = OWL_WANDER
		return

/*
 * Procs
 */

/mob/living/simple_animal/owl/movement_delay()
	if(client && stat == CONSCIOUS && owl_state != "owl_fly")
		icon_state = "owl_fly"
	..()

/mob/living/simple_animal/owl/proc/search_for_item()
	for(var/atom/movable/AM in view(src))
		//Skip items we already stole or are wearing or are too big
		if(owl_perch && AM.loc == owl_perch.loc || AM.loc == src)
			continue

		if(istype(AM, /obj/item))
			var/obj/item/I = AM
			if(I.w_class < 2)
				return I

		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			if((C.l_hand && C.l_hand.w_class <= 2) || (C.r_hand && C.r_hand.w_class <= 2))
				return C
	return null

/mob/living/simple_animal/owl/proc/search_for_perch()
	for(var/obj/O in view(src))
		for(var/path in desired_perches)
			if(istype(O, path))
				return O
	return null

//This proc was made to save on doing two 'in view' loops seperatly
/mob/living/simple_animal/owl/proc/search_for_perch_and_item()
	for(var/atom/movable/AM in view(src))
		for(var/perch_path in desired_perches)
			if(istype(AM, perch_path))
				return AM

		//Skip items we already stole or are wearing or are too big
		if(owl_perch && AM.loc == owl_perch.loc || AM.loc == src)
			continue

		if(istype(AM, /obj/item))
			var/obj/item/I = AM
			if(I.w_class <= 2)
				return I

		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			if(C.l_hand && C.l_hand.w_class <= 2 || C.r_hand && C.r_hand.w_class <= 2)
				return C
	return null


/*
 * Verbs - These are actually procs, but can be used as verbs by player-controlled owls.
 */
/mob/living/simple_animal/owl/proc/steal_from_ground()
	set name = "Steal from ground"
	set category = "Parrot"
	set desc = "Grabs a nearby item."

	if(stat)
		return -1

	if(held_item)
		src << "\red You are already holding the [held_item]"
		return 1

	for(var/obj/item/I in view(1,src))
		//Make sure we're not already holding it and it's small enough
		if(I.loc != src && I.w_class <= 2)

			//If we have a perch and the item is sitting on it, continue
			if(!client && owl_perch && I.loc == owl_perch.loc)
				continue

			held_item = I
			I.loc = src
			visible_message("[src] grabs the [held_item]!", "\blue You grab the [held_item]!", "You hear the sounds of wings flapping furiously.")
			return held_item

	src << "\red There is nothing of interest to take."
	return 0

/mob/living/simple_animal/owl/proc/steal_from_mob()
	set name = "Steal from mob"
	set category = "Parrot"
	set desc = "Steals an item right out of a person's hand!"

	if(stat)
		return -1

	if(held_item)
		src << "\red You are already holding the [held_item]"
		return 1

	var/obj/item/stolen_item = null

	for(var/mob/living/carbon/C in view(1,src))
		if(C.l_hand && C.l_hand.w_class <= 2)
			stolen_item = C.l_hand

		if(C.r_hand && C.r_hand.w_class <= 2)
			stolen_item = C.r_hand

		if(stolen_item)
			C.u_equip(stolen_item)
			held_item = stolen_item
			stolen_item.loc = src
			visible_message("[src] grabs the [held_item] out of [C]'s hand!", "\blue You snag the [held_item] out of [C]'s hand!", "You hear the sounds of wings flapping furiously.")
			return held_item

	src << "\red There is nothing of interest to take."
	return 0

/mob/living/simple_animal/owl/verb/drop_held_item_player()
	set name = "Drop held item"
	set category = "Parrot"
	set desc = "Drop the item you're holding."

	if(stat)
		return

	src.drop_held_item()

	return

/mob/living/simple_animal/owl/proc/drop_held_item(var/drop_gently = 1)
	set name = "Drop held item"
	set category = "Parrot"
	set desc = "Drop the item you're holding."

	if(stat)
		return -1

	if(!held_item)
		usr << "\red You have nothing to drop!"
		return 0

	if(!drop_gently)
		if(istype(held_item, /obj/item/weapon/grenade))
			var/obj/item/weapon/grenade/G = held_item
			G.loc = src.loc
			G.prime()
			src << "You let go of the [held_item]!"
			held_item = null
			return 1

	src << "You drop the [held_item]."

	held_item.loc = src.loc
	held_item = null
	return 1

/mob/living/simple_animal/owl/proc/perch_player()
	set name = "Sit"
	set category = "Parrot"
	set desc = "Sit on a nice comfy perch."

	if(stat || !client)
		return

	if(icon_state == "owl_fly")
		for(var/atom/movable/AM in view(src,1))
			for(var/perch_path in desired_perches)
				if(istype(AM, perch_path))
					src.loc = AM.loc
					icon_state = "owl_sit"
					return
	src << "\red There is no perch nearby to sit on."
	return

/*
 * Sub-types
 */
/mob/living/simple_animal/owl/Poly
	name = "Poly"
	desc = "Poly the Parrot. An expert on quantum cracker theory."
	speak = list("Poly wanna cracker!", ":e Check the crystal, you chucklefucks!",":e Wire the solars, you lazy bums!",":e WHO TOOK THE DAMN HARDSUITS?",":e OH GOD ITS GONNA BLOW CALL THE SHUTTLE")

/mob/living/simple_animal/owl/Poly/New()
	ears = new /obj/item/device/radio/headset/headset_eng(src)
	available_channels = list(":e")
	..()

/mob/living/simple_animal/owl/say(var/message)

	if(stat)
		return

	var/verb = "says"
	if(speak_emote.len)
		verb = pick(speak_emote)


	var/message_mode=""
	if(copytext(message,1,2) == ";")
		message_mode = "headset"
		message = copytext(message,2)

	if(length(message) >= 2)
		var/channel_prefix = copytext(message, 1 ,3)
		message_mode = department_radio_keys[channel_prefix]

	if(copytext(message,1,2) == ":")
		var/positioncut = 3
		message = trim(copytext(message,positioncut))

	message = capitalize(trim_left(message))

	if(message_mode)
		if(message_mode in radiochannels)
			if(ears && istype(ears,/obj/item/device/radio))
				ears.talk_into(src,message, message_mode, verb, null)


	..(message)


/mob/living/simple_animal/owl/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	if(prob(50))
		owl_hear(message)
	..(message,verb,language,alt_name,italics,speaker)



/mob/living/simple_animal/owl/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = 0)
	if(prob(50))
		owl_hear("[pick(available_channels)] [message]")
	..(message,verb,language,part_a,part_b,speaker,hard_to_hear)


/mob/living/simple_animal/owl/proc/owl_hear(var/message="")
	if(!message || stat)
		return
	speech_buffer.Add(message)

/mob/living/simple_animal/owl/attack_generic(var/mob/user, var/damage, var/attack_message)

	var/success = ..()

	if(client)
		return success

	if(owl_state == OWL_PERCH)
		owl_sleep_dur = owl_sleep_max //Reset it's sleep timer if it was perched

	if(!success)
		return 0

	owl_interest = user
	owl_state = OWL_SWOOP | OWL_ATTACK //Attack other animals regardless
	icon_state = "owl_fly"
	return success