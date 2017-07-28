/obj/machinery/camera/security
	alarm_delay = 0 //No alarm delay
	var/obj/item/device/radio/headset/radio

/obj/machinery/camera/security/New()
	. = ..()
	radio = new /obj/item/device/radio/headset(src)
	radio.frequency = SEC_FREQ
	radio.config(list("Security" = 1))
	assembly.upgrades.Add(new/obj/item/device/assembly/prox_sensor)

/obj/machinery/camera/security/Del()
	del(radio)
	..()

/obj/machinery/camera/security/triggerAlarm()
	if (!detectTime)
		return 0
	if(status && !(stat & EMPED)) //check if can transmit
		radio.frequency = SEC_FREQ
		radio.config(list("Security" = 1))
		//radio.autosay("Motion detected in [area_motion]","Security Alert", "Security")

		var/mob/living/alert = new/mob/living
		alert.name = "Security Alert"
		alert.real_name = "Security Alert"

		radio.talk_into(alert, "Motion detected in [c_tag]", "Security","states")
		del(alert)
	detectTime = -1
	return 1

/obj/machinery/camera/security/cancelAlarm()
	detectTime = 0
	return 1

/obj/machinery/camera/security/triggerCameraAlarm() //Keep AI involvement out
	return

/obj/machinery/camera/security/cancelCameraAlarm() //Keep AI involvement out
	return
