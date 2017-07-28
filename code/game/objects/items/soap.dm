/obj/item/weapon/soap/space_soap
	name = "Soap"
	desc = "Smells like burnt meat."
	icon = 'icons/obj/soap.dmi'
	icon_state = "space_soap"

/obj/item/weapon/soap/water_soap
	name = "Soap"
	desc = "Smells wet."
	icon = 'icons/obj/soap.dmi'
	icon_state = "water_soap"

/obj/item/weapon/soap/fire_soap
	name = "Soap"
	desc = "Smells warm."
	icon = 'icons/obj/soap.dmi'
	icon_state = "fire_soap"

/obj/item/weapon/soap/american_soap
	name = "Soap"
	desc = "Smells like freedom."
	icon = 'icons/obj/soap.dmi'
	icon_state = "american_soap"

/obj/item/weapon/soap/british_soap
	name = "Soap"
	desc = "Smells like tea."
	icon = 'icons/obj/soap.dmi'
	icon_state = "british_soap"

/obj/item/weapon/soap/rainbow_soap
	name = "Soap"
	desc = "Smells like unicorns and magic."
	icon = 'icons/obj/soap.dmi'
	icon_state = "rainbow_soap"

/obj/item/weapon/soap/diamond_soap
	name = "Soap"
	desc = "Smells of expenses."
	icon = 'icons/obj/soap.dmi'
	icon_state = "diamond_soap"

/obj/item/weapon/soap/uranium_soap
	name = "Soap"
	desc = "Smells like explosions."
	icon = 'icons/obj/soap.dmi'
	icon_state = "uranium_soap"

/obj/item/weapon/soap/silver_soap
	name = "Soap"
	desc = "Smells like surfing."
	icon = 'icons/obj/soap.dmi'
	icon_state = "silver_soap"

/obj/item/weapon/soap/brown_soap
	name = "Soap"
	desc = "Smells like chocolate."
	icon = 'icons/obj/soap.dmi'
	icon_state = "brown_soap"

/obj/item/weapon/soap/white_soap
	name = "Soap"
	desc = "Smells like chicken."
	icon = 'icons/obj/soap.dmi'
	icon_state = "white_soap"

/obj/item/weapon/soap/grey_soap
	name = "Soap"
	desc = "Smells like rain."
	icon = 'icons/obj/soap.dmi'
	icon_state = "grey_soap"

/obj/item/weapon/soap/pink_soap
	name = "Soap"
	desc = "Smells like bubble gum"
	icon = 'icons/obj/soap.dmi'
	icon_state = "pink_soap"

/obj/item/weapon/soap/purple_soap
	name = "Soap"
	desc = "Smells like lavender."
	icon = 'icons/obj/soap.dmi'
	icon_state = "purple_soap"

/obj/item/weapon/soap/blue_soap
	name = "Soap"
	desc = "What smells like blue?..."
	icon = 'icons/obj/soap.dmi'
	icon_state = "blue_soap"

/obj/item/weapon/soap/cyan_soap
	name = "Soap"
	desc = "Smells like bluebells."
	icon = 'icons/obj/soap.dmi'
	icon_state = "cyan_soap"

/obj/item/weapon/soap/green_soap
	name = "Soap"
	desc = "Smells like radioactive waste."
	icon = 'icons/obj/soap.dmi'
	icon_state = "green_soap"

/obj/item/weapon/soap/yellow_soap
	name = "Soap"
	desc = "Smells like dun flowers."
	icon = 'icons/obj/soap.dmi'
	icon_state = "yellow_soap"

/obj/item/weapon/soap/orange_soap
	name = "Soap"
	desc = "Smells like oranges."
	icon = 'icons/obj/soap.dmi'
	icon_state = "orange_soap"

/obj/item/weapon/soap/red_soap
	name = "Soap"
	desc = "Smells like my last victim..."
	icon = 'icons/obj/soap.dmi'
	icon_state = "red_soap"

/obj/item/weapon/soap/irish_soap
	name = "Soap"
	desc = "Smells like hops."
	icon = 'icons/obj/soap.dmi'
	icon_state = "irish_soap"

/obj/item/weapon/soap/swedish_soap
	name = "Soap"
	desc = "Smells like free college and high taxes."
	icon = 'icons/obj/soap.dmi'
	icon_state = "swedish_soap"

/obj/item/weapon/soap/fluff/hugo_soap
  desc = "One true soap to rule them all."
  icon_state = "hugo_soap"
  icon = 'icons/obj/soap.dmi'

/obj/item/weapon/soap/fluff/innerwulf
  desc = "Smells like justice."
  icon = 'icons/obj/soap.dmi'
  icon_state = "innerwulf_soap"

/obj/item/weapon/soap/fluff/cebu //Donated $20 :D
  desc = "Can anyone else smell blue?"
  icon = 'icons/obj/soap.dmi'
  icon_state = "cebu_soap"

/obj/random/soap/
	name = "Random Soap"
	desc = "This is a random soap."
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	item_to_spawn()
		return pick(prob(1);/obj/item/weapon/soap/space_soap,\
					prob(1);/obj/item/weapon/soap/water_soap,\
					prob(1);/obj/item/weapon/soap/fire_soap,\
					prob(1);/obj/item/weapon/soap/american_soap,\
					prob(1);/obj/item/weapon/soap/british_soap,\
					prob(1);/obj/item/weapon/soap/rainbow_soap,\
					prob(1);/obj/item/weapon/soap/diamond_soap,\
					prob(1);/obj/item/weapon/soap/uranium_soap,\
					prob(1);/obj/item/weapon/soap/silver_soap,\
					prob(1);/obj/item/weapon/soap/brown_soap,\
					prob(1);/obj/item/weapon/soap/white_soap,\
					prob(1);/obj/item/weapon/soap/grey_soap,\
					prob(1);/obj/item/weapon/soap/pink_soap,\
					prob(1);/obj/item/weapon/soap/purple_soap,\
					prob(1);/obj/item/weapon/soap/blue_soap,\
					prob(1);/obj/item/weapon/soap/cyan_soap,\
					prob(1);/obj/item/weapon/soap/green_soap,\
					prob(1);/obj/item/weapon/soap/yellow_soap,\
					prob(1);/obj/item/weapon/soap/orange_soap,\
					prob(1);/obj/item/weapon/soap/red_soap,\
					prob(1);/obj/item/weapon/soap/irish_soap,\
					prob(1);/obj/item/weapon/soap/swedish_soap,\
					prob(1);/obj/item/weapon/soap/nanotrasen)