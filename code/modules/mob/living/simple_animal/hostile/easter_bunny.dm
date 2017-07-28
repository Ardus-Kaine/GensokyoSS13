/mob/living/simple_animal/hostile/easter_bunny
	name = "\improper Easter Bunny"
	desc = "That's definitely not a rabbit."
	icon = 'icons/mob/bunn.dmi'
	icon_state = "bunny_ranged"
	icon_living = "bunny_ranged"
	icon_dead = "bunny_dead"
	icon_gib = "syndicate_gib"
	speak_chance = 2
	speak = list("Happy Easter!","HAPPY EASTER!","Why don't you just lie down and BLEED to death!?")
	speak_emote = list("screams", "screeches")
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "strikes"
	a_intent = "harm"
	var/weapon1
	var/weapon2
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	faction = "easter_empire"
	status_flags = CANPUSH

/mob/living/simple_animal/hostile/easter_bunny/ranged
	ranged = 1
	rapid = 0
	icon_state = "bunny_ranged"
	icon_living = "bunny_ranged"
	projectilesound = 'sound/weapons/rocket.ogg'
	projectiletype = /obj/item/projectile/carrot
	weapon1 = /obj/item/weapon/gun/rocketlauncher/carrot

/mob/living/simple_animal/hostile/easter_bunny/ranged/drops_rocket
	ranged = 1
	rapid = 0
	icon_state = "bunny_ranged"
	icon_living = "bunny_ranged"
	projectilesound = 'sound/weapons/rocket.ogg'
	projectiletype = /obj/item/projectile/carrot
	weapon1 = /obj/item/weapon/gun/rocketlauncher/carrot

/mob/living/simple_animal/hostile/easter_bunny/ranged/drops_rocket/Life()
	..()
	if(health == 0)
		src.gib()
		new /obj/item/weapon/gun/rocketlauncher/carrot/full( loc )

/obj/item/missile/carrot
	icon = 'icons/mob/bunn.dmi'
	icon_state = "carrot"