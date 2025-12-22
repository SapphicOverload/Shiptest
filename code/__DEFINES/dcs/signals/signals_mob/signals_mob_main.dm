/// From base of /client/proc/change_view() (mob/source, new_size)
#define COMSIG_MOB_CLIENT_CHANGE_VIEW "mob_client_change_view"
/// From base of /mob/proc/reset_perspective() (mob/source)
#define COMSIG_MOB_RESET_PERSPECTIVE "mob_reset_perspective"
/// From base of /client/Move()
#define COMSIG_MOB_CLIENT_PRE_MOVE "mob_client_pre_move"
	/// Should always match COMPONENT_MOVABLE_BLOCK_PRE_MOVE as these are interchangeable and used to block movement.
	#define COMSIG_MOB_CLIENT_BLOCK_PRE_MOVE COMPONENT_MOVABLE_BLOCK_PRE_MOVE
/// From base of /client/Move()
#define COMSIG_MOB_CLIENT_PRE_LIVING_MOVE "mob_client_pre_living_move"
	/// Should we stop the current living movement attempt
	#define COMSIG_MOB_CLIENT_BLOCK_PRE_LIVING_MOVE COMPONENT_MOVABLE_BLOCK_PRE_MOVE
