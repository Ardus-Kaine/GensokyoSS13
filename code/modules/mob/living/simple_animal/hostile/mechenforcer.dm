/mob/living/simple_animal/hostile/corpenforcer
	name = "Corporate Alliance Mechanized Enforcer"
	desc = "A variant of the 1.93 meter tall second-generation automated soldier developed by IG Farben during the very close of the 21st century. While the variant is somewhat inferior to the origianl design, it is less expensive, and as such most groups within the officially-neutral Corporate Alliance use it as a primary unit for boarding operations, planetary assault, garrison forces, and as the first line of defense against enemy boarding parties."
	//icon = 'B2_Battle_Droid'
	icon_state = "B2_Battle_Droid"
	icon_living = "B2_Battle_Droid"
	icon_dead = "B2_Battle_Droid"
	speak_chance = 0
	turns_per_move = 5
	speak = list("Advance the attack!", "Roger, roger.")
	speak_chance = 1
	emote_see = list("re-arms its wrist blaster")
	health = 100
	maxHealth = 100
	ranged = 1
	rapid = 1
	attacktext = "fired their wrist blaster at"
	projectilesound = 'sound/weapons/laser.ogg'
	projectiletype = /obj/item/projectile/beam
	var/weapon1 = /obj/item/weapon/gun/energy/laser
	faction = "corporate"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 4


/mob/living/simple_animal/hostile/corpenforcer/death()
	..()
	visible_message("<b>[src]</b> collapses to the ground!")
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	del src
	return
