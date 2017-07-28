mob/living/simple_animal/penguin_friendly
	name = "Penguin"
	desc = "It's just a penguin."
	icon = 'icons/mob/penguin.dmi'
	icon_state = "penguin"
	icon_living = "penguin"
	icon_dead = "penguin_dead"
	icon_gib = ""
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
	attacktext = "pecks"
	attack_sound = 'sound/weapons/bite.ogg'

	//Penguins aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 350

	faction = "penguin"

	//Penguin Weakness
	heat_damage_per_tick = 120	//amount of damage applied if animal's body temperature is higher than maxbodytemp

/* Removing because strange
mob/living/simple_animal/penguin_friendly/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space penguins!	//original comments do not steal
*/

mob/living/simple_animal/penguin_friendly/Baram
	name = "Baram"
	desc = "It's just a penguin; definitely not a spy."