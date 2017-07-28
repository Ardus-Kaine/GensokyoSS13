/obj/item/weapon/reagent_containers/food/drinks/britcup
	name = "cup"
	desc = "A cup with the British flag emblazoned on it."
	icon_state = "britcup"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)

/obj/item/weapon/reagent_containers/food/drinks/bluespace_coffee
	name = "bluespace coffee"
	desc = "This revolutionary device is always full of hot 'coffee'; no one knows where it comes from..."
	icon = 'icons/obj/coffee.dmi'
	icon_state = "bluespace_coffee"
	center_of_mass = list("x"=15, "y"=10)
	volume = 50
	New()
		..()
		reagents.add_reagent("coffee", 50)

	//Infinite Coffee
	attack(mob/M as mob, mob/user as mob, def_zone)
		..()
		src.reagents.add_reagent("coffee", 50)

/obj/item/weapon/reagent_containers/food/drinks/teacup
	name = "tea cup"
	desc = "Your standard tea cup."
	icon_state = "teacup"

/obj/item/weapon/reagent_containers/food/drinks/large_teacup
	name = "large tea cup"
	desc = "Your abnormally large tea cup."
	icon_state = "bigteacup"

/obj/item/weapon/reagent_containers/food/drinks/mug
	name = "mug"
	desc = "For holding any hot drink that's not tea."
	icon_state = "hot_coco"