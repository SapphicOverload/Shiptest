/datum/element/reflective
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2

	/// The bodypart flags covered by this item.
	var/covered_parts
	/// The percent of damage reflected back at the attacker, from 0 to 1.
	var/reflect_ratio

/*COMSIG_ITEM_EQUIPPED

COMSIG_ITEM_DROPPED*/

/datum/element/reflective/Attach(datum/target, covered_parts = ALL, reflect_ratio = 0.5)
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	. = ..()
	src.covered_parts = covered_parts
	src.reflect_ratio = reflect_ratio
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(target, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/element/reflective/proc/on_equip(obj/item/target, mob/user, slot)
	if(target.slot_flags & slot)
		RegisterSignal(user, COMSIG_ATOM_BULLET_ACT, PROC_REF(do_reflect))
	else
		UnregisterSignal(user, COMSIG_ATOM_BULLET_ACT)

/datum/element/reflective/proc/on_drop(obj/item/target, mob/user)
	UnregisterSignal(user, COMSIG_ATOM_BULLET_ACT)

/datum/element/reflective/proc/do_reflect(mob/living/defender, obj/projectile/incoming, def_zone)
	if(!(incoming.reflectable & REFLECT_NORMAL))
		return NONE
	var/obj/item/bodypart/covered_part = defender.get_bodypart(def_zone)
	if(!(covered_part?.body_part & covered_parts)) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return NONE
	incoming.damage *= 1 - reflect_ratio
	incoming.on_hit(defender, defender.run_armor_check(def_zone, incoming.flag, "", "", incoming.armour_penetration)) // Take the portion of damage that wasn't reflected
	incoming.damage *= reflect_ratio / (1 - reflect_ratio)
	incoming.setAngle()
	if(incoming.hitscan) // hitscan check
		incoming.store_hitscan_collision(incoming.trajectory.copy_to())
	incoming.firer = defender
	var/new_angle_s = incoming.Angle + rand(120,240)
	while(new_angle_s > 180)	// Translate to regular projectile degrees
		new_angle_s -= 360
	incoming.setAngle(new_angle_s)
	playsound(defender, pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, 1)
	return BULLET_ACT_FORCE_PIERCE
