/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////

/proc/do_sparks(n, c, source)
	// n - number of sparks
	// c - cardinals, bool, do the sparks only move in cardinal directions?
	// source - source of the sparks.

	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(n, c, source)
	sparks.autocleanup = TRUE
	sparks.start()


/obj/effect/particle_effect/sparks
	name = "sparks"
	icon_state = "sparks"
	anchored = TRUE
	light_system = MOVABLE_LIGHT
	light_range = 2
	light_power = 0.5
	light_color = LIGHT_COLOR_FIRE
	var/ignition_temp = 1000
	var/ignition_volume = 100

/obj/effect/particle_effect/sparks/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/particle_effect/sparks/LateInitialize()
	flick(icon_state, src)
	playsound(src, "sparks", 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	var/turf/T = loc
	if(isturf(T))
		T.hotspot_expose(ignition_temp, ignition_volume)
	QDEL_IN(src, 20)

/obj/effect/particle_effect/sparks/Destroy()
	var/turf/T = loc
	if(isturf(T))
		T.hotspot_expose(ignition_temp, ignition_volume)
	return ..()

/obj/effect/particle_effect/sparks/Move()
	..()
	var/turf/T = loc
	if(isturf(T))
		T.hotspot_expose(ignition_temp, ignition_volume)

/obj/effect/particle_effect/sparks/Bump(atom/A)
	. = ..()
	if(istype(A, /obj/machinery/portable_atmospherics))
		var/obj/machinery/portable_atmospherics/portable = A
		var/datum/gas_mixture/temp_gas = portable.air_contents.remove_ratio(ignition_volume / portable.air_contents.return_volume())
		var/initial_energy = temp_gas.thermal_energy()
		var/delta_energy = 0
		if(temp_gas.return_temperature() < ignition_temp)
			temp_gas.set_temperature(ignition_temp)
			delta_energy = temp_gas.thermal_energy() - initial_energy
		for(var/i in 1 to 3)
			temp_gas.react(portable)
		if(delta_energy)
			temp_gas.set_temperature((temp_gas.thermal_energy() - delta_energy) / temp_gas.heat_capacity())
		portable.air_contents.merge(temp_gas)

/datum/effect_system/spark_spread
	effect_type = /obj/effect/particle_effect/sparks

/datum/effect_system/spark_spread/quantum
	effect_type = /obj/effect/particle_effect/sparks/quantum


//electricity

/obj/effect/particle_effect/sparks/electricity
	name = "lightning"
	icon_state = "electricity"

/obj/effect/particle_effect/sparks/quantum
	name = "quantum sparks"
	icon_state = "quantum_sparks"

/datum/effect_system/lightning_spread
	effect_type = /obj/effect/particle_effect/sparks/electricity
