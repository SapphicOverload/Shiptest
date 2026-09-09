/// This element hooks a signal onto adjacent locations.
/// When the object moves, it will unhook the signal and rehook it to the new adjacents.
/datum/element/connect_adjacent_turfs
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH | ELEMENT_NO_LIST_UNIT_TEST
	argument_hash_start_idx = 2

	/// An assoc list of signal -> procpath to register to the loc this object is on.
	var/list/connections

/datum/element/connect_adjacent_turfs/Attach(atom/movable/listener, list/connections)
	. = ..()
	if (!istype(listener))
		return ELEMENT_INCOMPATIBLE

	src.connections = connections

	RegisterSignal(listener, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved), override = TRUE)
	update_signals(listener)

/datum/element/connect_adjacent_turfs/Detach(atom/movable/listener)
	. = ..()
	unregister_signals(listener, listener.loc)
	UnregisterSignal(listener, COMSIG_MOVABLE_MOVED)

/datum/element/connect_adjacent_turfs/proc/update_signals(atom/movable/listener)
	var/atom/listener_loc = listener.loc
	if(isnull(listener_loc))
		return

	for(var/direction in GLOB.cardinals)
		var/turf/dir_step = get_step(listener_loc, direction)
		for (var/signal in connections)
			//override=TRUE because more than one connect_loc element instance tracked object can be on the same loc
			listener.RegisterSignal(dir_step, signal, connections[signal], override=TRUE)

/datum/element/connect_adjacent_turfs/proc/unregister_signals(datum/listener, atom/old_loc)
	if(isnull(old_loc))
		return
	for(var/direction in GLOB.cardinals)
		listener.UnregisterSignal(get_step(old_loc, direction), connections)

/datum/element/connect_adjacent_turfs/proc/on_moved(atom/movable/listener, atom/old_loc)
	SIGNAL_HANDLER
	unregister_signals(listener, old_loc)
	update_signals(listener)
