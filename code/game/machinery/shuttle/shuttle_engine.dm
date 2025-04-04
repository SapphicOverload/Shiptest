/**
 * ## Engine Thrusters
 * The workhorse of any movable ship, these engines (usually) take in some kind fuel and produce thrust to move ships.
 *
 */
/obj/machinery/power/shuttle/engine
	name = "shuttle thruster"
	desc = "A thruster for shuttles."
	circuit = /obj/item/circuitboard/machine/shuttle/engine
	CanAtmosPass = FALSE //so people can actually tend to their engines
	dir = EAST //most ships face east
	///Whether or not the engine is enabled and can be used. Controlled from helm consoles and by hitting with a multitool.
	var/enabled = TRUE
	///How much thrust this engine generates when burned fully.
	var/thrust = 0
	///Whether this engine is actively providing thrust to the ship
	var/thruster_active = FALSE

/**
 * Uses up a specified percentage of the fuel cost, and returns the amount of thrust if successful.
 * * percentage - The percentage of total thrust that should be used
 */
/obj/machinery/power/shuttle/engine/proc/burn_engine(percentage = 100, seconds_per_tick)
	update_icon_state()
	return FALSE

/**
 * Returns how much "Fuel" is left. (For use with engine displays.)
 */
/obj/machinery/power/shuttle/engine/proc/return_fuel()
	return

/**
 * Returns how much "Fuel" can be held. (For use with engine displays.)
 */
/obj/machinery/power/shuttle/engine/proc/return_fuel_cap()
	return

/**
 * Updates the engine state.
 * All functions should return if the parent function returns false.
 */
/obj/machinery/power/shuttle/engine/proc/update_engine()
	if(!(flags_1 & INITIALIZED_1))
		return FALSE
	thruster_active = TRUE
	if(panel_open)
		thruster_active = FALSE
		return FALSE
	return TRUE

/**
 * Updates the engine's icon and engine state.
 */
/obj/machinery/power/shuttle/engine/update_icon_state()
	update_engine() //Calls this so it sets the accurate icon
	if(panel_open)
		icon_state = icon_state_open
		return ..()
	else if(thruster_active && enabled && return_fuel())
		icon_state = icon_state_closed
		return ..()
	else
		icon_state = icon_state_off
		return ..()

/obj/machinery/power/shuttle/engine/Initialize()
	. = ..()
	update_icon_state()

/obj/machinery/power/shuttle/engine/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	. = ..()
	port.engine_list |= WEAKREF(src)

/obj/machinery/power/shuttle/engine/on_construction()
	. = ..()
	update_icon_state()

/obj/machinery/power/shuttle/engine/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	if(do_after(user, MIN_TOOL_SOUND_DELAY, target=src))
		enabled = !enabled
		to_chat(user, "<span class='notice'>You [enabled ? "enable" : "disable"] [src].")
