/obj/structure/largecrate/kitten
	name = "kitten crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/kitten/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		var/num = rand(1, 2)
		for(var/i = 0, i < num, i++)
			new /mob/living/simple_animal/cat/kitten(loc)
	..()

/obj/structure/largecrate/bear
	name = "bear crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/bear/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		new /mob/living/simple_animal/bear_pet(loc)
	..()

/obj/structure/largecrate/carp
	name = "space carp crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/carp/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		new /mob/living/simple_animal/carp_pet(loc)
	..()

/obj/structure/largecrate/parrot
	name = "parrot crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/parrot/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		new /mob/living/simple_animal/parrot(loc)
	..()

/obj/structure/largecrate/penguin
	name = "penguin crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/penguin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		new /mob/living/simple_animal/penguin_friendly(loc)
	..()

/obj/structure/largecrate/fox
	name = "fox crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/fox/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		new /mob/living/simple_animal/fox(loc)
	..()

/obj/structure/largecrate/seal
	name = "seal crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/seal/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		new /mob/living/simple_animal/seal(loc)
	..()

/obj/structure/largecrate/walrus
	name = "walrus crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/walrus/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		new /mob/living/simple_animal/walrus(loc)
	..()

/obj/structure/largecrate/goose
	name = "goose crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/goose/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		new /mob/living/simple_animal/goose(loc)
	..()

/obj/structure/largecrate/renault
	name = "renault crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/renault/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		new /mob/living/simple_animal/fox/renault(loc)
	..()