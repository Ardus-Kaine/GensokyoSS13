/mob/living/simple_animal/hostile/retaliate/goose
	name = "goose"
	desc = "Not known for their pleasant disposition."
	icon_state = "gooseflap"
	icon_living = "gooseflap"
	icon_dead = "goose_dead"
	speak = list("quack?","quack","QUACK","honk","HONK")
	speak_emote = list("brays")
//	emote_hear = list("brays")
	emote_see = list("flaps it's wings")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	meat_amount = 6
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "pecks"
	faction = "goose"
	health = 50
	melee_damage_lower = 1
	melee_damage_upper = 3

/mob/living/simple_animal/hostile/retaliate/goose/Life()
	. = ..()
	if(.)
		//chance to go crazy and start wacking stuff
		if(!enemies.len && prob(1))
			Retaliate()

		if(enemies.len && prob(10))
			enemies = list()
			LoseTarget()
			src.visible_message("\blue [src] calms down.")

		if(!pulledby)
			for(var/direction in shuffle(list(1,2,4,8,5,6,9,10)))
				var/step = get_step(src, direction)
				if(step)
					if(locate(/obj/effect/plant) in step)
						Move(step)

/mob/living/simple_animal/hostile/retaliate/goose/Retaliate()
	..()
	src.visible_message("\red [src] flaps its wings angrily!")