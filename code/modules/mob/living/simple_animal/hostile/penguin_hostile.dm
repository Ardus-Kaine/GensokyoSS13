//Killer Penguins!!
/mob/living/simple_animal/hostile/penguin_hostile
	name = "Penguin"
	desc = "I think it's plotting something..."
	icon = 'icons/mob/penguin.dmi'
	icon_state = "penguin_hostile"
	icon_living = "penguin_hostile"
	icon_dead = "penguin_dead"
	icon_gib = ""
	speak = list("Death to humans!","For the emperor!","I want carp!")
	speak_emote = list("screams", "squawks")
	emote_hear = list("rawrs","grumbles","grawls")
	emote_see = list("stares ferociously", "flaps")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/cell/crap
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "pokes"
	stop_automated_movement_when_pulled = 0
	maxHealth = 1
	health = 1
	melee_damage_lower = 20
	melee_damage_upper = 30

/mob/living/simple_animal/hostile/penguin_hostile/strong_version_very_OP
	name = "Penguin"
	desc = "I think it's plotting something..."
	maxHealth = 120
	health = 120
