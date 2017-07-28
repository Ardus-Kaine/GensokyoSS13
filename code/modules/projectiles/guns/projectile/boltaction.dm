/obj/item/weapon/gun/projectile/Mauser98K
	name = "\improper Farben Karabiner 98K"
	desc = "The standard bolt-action rifle of the German Wehrmacht during World War II. Well known for it's reliability, it's seen optimization and renewed production as one of the battle rifles for IG Farben's forces."
	icon = 'icons/obj/soapstation_weapons.dmi'
	icon_state = "Kar98K"
	item_state = "l6closednomag" //placeholder
	w_class = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = "combat=8;materials=2;syndicate=8"
	caliber = "a792"
	recoil = 0 //extra kickback
	//fire_sound = 'sound/weapons/sniper.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SPEEDLOADER
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/a792
	//+2 accuracy over the LWAP because only one shot
	accuracy = 1
	scoped_accuracy = 2
	var/bolt_open = 0

/obj/item/weapon/gun/projectile/Mauser98K/update_icon()
	if(bolt_open)
		icon_state = "Kar98K-open"
	else
		icon_state = "Kar98K"

/obj/item/weapon/gun/projectile/Mauser98K/attack_self(mob/user as mob)
	playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			user << "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>"
			chambered.loc = get_turf(src)
			loaded -= chambered
			chambered = null
		else
			user << "<span class='notice'>You work the bolt open.</span>"
	else
		user << "<span class='notice'>You work the bolt closed.</span>"
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/weapon/gun/projectile/Mauser98K/special_check(mob/user)
	if(bolt_open)
		user << "<span class='warning'>You can't fire [src] while the bolt is open!</span>"
		return 0
	return ..()

/obj/item/weapon/gun/projectile/Mauser98K/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/Mauser98K/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/Mauser98K/verb/scope()
	set category = "Object"
	set name = "Use Sights"
	set popup_menu = 1

	toggle_scope(2.0)
