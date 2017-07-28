/mob/living/simple_animal/hostile/navytrooper
	name = "Corporate Alliance Navy Trooper"
	desc = "A member who enlisted with one of the naval fleet regiments modelled after the self-named Imperial Fleet Security of IG Farben. Often inferior to those they were modelled after, they are used by most groups within the officially-neutral Alliance as a last line of defense against enemy boarding groups and in boarding enemy structures or navalcraft."
	icon_state = "russianmelee" //Placeholder until I make a real sprite
	icon_living = "russianmelee" //Placeholder until I make a real sprite
	icon_dead = "russianmelee_dead" //Placeholder (?)
	icon_gib = "syndicate_gib"
	speak_chance = 0
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
	attacktext = "slashed"
	a_intent = "harm"
	var/corpse = /obj/effect/landmark/mobcorpse/navytrooper
	var/weapon1 = /obj/item/weapon/melee/energy/sword
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	faction = "corporate"
	status_flags = CANPUSH


/mob/living/simple_animal/hostile/navytrooper/ranged
	icon_state = "russianranged" //Placeholder until I make a real sprite
	icon_living = "russianranged" //Placeholder until I make a real sprite
	corpse = /obj/effect/landmark/mobcorpse/navytrooper/ranged
	weapon1 = /obj/item/weapon/gun/projectile/revolver/mateba
	ranged = 1
	projectiletype = /obj/item/projectile/bullet
	projectilesound = 'sound/weapons/Gunshot.ogg'
	casingtype = /obj/item/ammo_casing/a357


/mob/living/simple_animal/hostile/navytrooper/death()
	..()
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	del src
	return