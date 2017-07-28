///////////////////////////////////CUP DISPENSER\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/obj/machinery/vending/cup_dispensor
	name = "Cup Dispensor"
	desc = "Dispenses cups, no one knows where from."
	icon = 'icons/obj/coffee.dmi'
	icon_state = "cup_dispenser"        //////////////18 drink entities below, plus the glasses, in case someone wants to edit the number of bottles
	products = list(/obj/item/weapon/reagent_containers/food/drinks/drinkingglass = 200,
						/obj/item/weapon/reagent_containers/food/drinks/mug = 200,
						/obj/item/weapon/reagent_containers/food/drinks/teacup = 200,
						/obj/item/weapon/reagent_containers/food/drinks/large_teacup = 200,
						/obj/item/weapon/reagent_containers/food/drinks/britcup = 10)
	contraband = list(/obj/item/weapon/reagent_containers/food/drinks/bluespace_coffee = 5,
						/obj/item/weapon/reagent_containers/food/drinks/sillycup)
	vend_delay = 5
	idle_power_usage = 5
///////////////////////////////////CUP DISPENSOR END\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
