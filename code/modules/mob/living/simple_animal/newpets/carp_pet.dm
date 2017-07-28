

/mob/living/simple_animal/carp_pet
	name = "space carp"
	desc = "An adorable pet fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	speak = list("Glub Glub")
	speak_emote = list("swims", "splashes")
	speak_chance = 1
	turns_per_move = 2
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "pokes the"
	speed = 4
	maxHealth = 100
	health = 100

	harm_intent_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = "licks"
	attack_sound = 'sound/mobs/lick.ogg'

	//Space carp aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "carp"

/mob/living/simple_animal/carp_pet/Blinky
	name = "Blinky"
	desc = "Space carp are just misunderstood."
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"


/mob/living/simple_animal/carp_pet/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal
