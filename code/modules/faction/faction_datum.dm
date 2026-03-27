/datum/faction
	var/name
	/// Primarly to be used for backend stuff.
	var/short_name
	/// Parent faction of this faction, used for allowed factions and information
	var/parent_faction
	/// List of prefixes that ships of this faction uses
	var/list/prefixes
	/// List/Typecache of factions that this faction is allowed to interact with. Non-recursive.
	var/list/allowed_factions = list()
	/// List/Typecache of factions that this faction is hostile to. Used to warn players when joining a ship of this faction.
	var/list/hostile_factions = list(
		/datum/faction/frontiersmen,
		/datum/faction/ramzi,
	)
	/// The official language of this faction. Galactic Common by default.
	var/official_language = /datum/language/galactic_common
	/// Theme color for this faction, currently only used for the wiki
	var/color = "#ffffff"
	/// Contrast color for this faction, used for links on the wiki
	var/contrast_color
	/// Background color for this faction, for use under black text
	var/background_color
	/// Properties of this faction.
	var/flags = FACTION_CHECK_PREFIX
	/// Sorting order for factions
	var/order = FACTION_SORT_DEFAULT

/datum/faction/New()
	if(!short_name)
		short_name = uppertext(copytext_char(name, 3))

	if(!contrast_color)
		contrast_color = "#[invert_hex(copytext_char(color, 2))]"
	if(!background_color)
		var/list/hsl = rgb2num(color, COLORSPACE_HSL)
		background_color = rgb(hsl[1], min(hsl[2], 50), max(hsl[3], 66), space=COLORSPACE_HSL)

	//All subtypes of this faction, all subtypes of specifically allowed factions, and SPECIFICALLY the parent faction (no subtypes) are allowed.
	//Try not to nest factions too deeply, yeah?
	allowed_factions += src
	allowed_factions = typecacheof(allowed_factions)
	allowed_factions[parent_faction] = TRUE
	hostile_factions = typecacheof(hostile_factions)
	hostile_factions -= type

/// Easy way to check if something is "allowed", checks to see if it matches the name or faction typepath because factions are a fucking mess
/datum/faction/proc/allowed_faction(value_to_check)
	//do we have the same faction even if one is a define?
	if(value_to_check == name)
		return TRUE
	return is_type_in_typecache(value_to_check, allowed_factions)

/// Checks whether this faction is hostile to the given one.
/datum/faction/proc/is_hostile_to(value_to_check)
	return is_type_in_typecache(value_to_check, hostile_factions)

/datum/faction/syndicate
	name = FACTION_SYNDICATE
	parent_faction = /datum/faction/syndicate
	prefixes = PREFIX_SYNDICATE
	color = "#B22C20"

/datum/faction/syndicate/ngr
	name = FACTION_NGR
	short_name = "NGR"
	prefixes = PREFIX_NGR
	flags = FACTION_CHECK_PREFIX | FACTION_PLAYER_SELECT | FACTION_CITIZENSHIP
	hostile_factions = list(
		/datum/faction/syndicate/hardliners,
		/datum/faction/frontiersmen,
		/datum/faction/ramzi,
	)
	color = "#C59973"

/datum/faction/syndicate/cybersun
	name = FACTION_CYBERSUN
	prefixes = PREFIX_CYBERSUN
	flags = FACTION_CHECK_PREFIX | FACTION_PLAYER_SELECT
	color = "#4C9C9C"

/datum/faction/syndicate/hardliners
	name = FACTION_HARDLINERS
	prefixes = PREFIX_HARDLINERS
	flags = FACTION_PLAYER_SELECT
	hostile_factions = list(
		/datum/faction/syndicate/ngr,
		/datum/faction/frontiersmen,
		/datum/faction/ramzi,
		/datum/faction/warra,
	)
	color = "#97150B"

/datum/faction/syndicate/scarborough
	name = "Scarborough Arms"
	prefixes = PREFIX_NONE
	allowed_factions = list(/datum/faction/syndicate)

/datum/faction/syndicate/concordat
	name = "Galactic Engineer's Concordat"
	prefixes = PREFIX_NONE
	flags = FACTION_WIKI_HIDDEN | FACTION_PLAYER_SELECT
	allowed_factions = list(
		/datum/faction/syndicate,
		/datum/faction/solgov,
		/datum/faction/suns,
		/datum/faction/clip,
		/datum/faction/pgf,
		/datum/faction/teceti,
	)
	hostile_factions = list(
		/datum/faction/warra,
		/datum/faction/ramzi,
		/datum/faction/frontiersmen,
	)

/datum/faction/syndicate/liberation_front
	name = "Anti-Corporation Liberation Front"
	prefixes = PREFIX_NONE
	flags = FACTION_WIKI_HIDDEN | FACTION_PLAYER_SELECT
	allowed_factions = list(
		/datum/faction/syndicate,
		/datum/faction/solgov,
		/datum/faction/clip,
		/datum/faction/pgf,
		/datum/faction/teceti,
	)
	hostile_factions = list(
		/datum/faction/warra,
		/datum/faction/frontiersmen,
	)

/datum/faction/solgov
	name = FACTION_SOLCON
	parent_faction = /datum/faction/solgov
	official_language = /datum/language/solarian_international
	allowed_factions = list(/datum/faction/suns)
	prefixes = PREFIX_SOLCON
	flags = FACTION_CHECK_PREFIX | FACTION_PLAYER_SELECT | FACTION_CITIZENSHIP
	color = "#444e5f"

/datum/faction/suns
	name = FACTION_SUNS
	short_name = "SUNS"
	parent_faction = /datum/faction/suns
	official_language = /datum/language/solarian_international
	prefixes = PREFIX_SUNS
	flags = FACTION_CHECK_PREFIX | FACTION_PLAYER_SELECT
	color = "#CD94D3"

/datum/faction/srm
	name = FACTION_SRM
	short_name = "SRM"
	parent_faction = /datum/faction/srm
	prefixes = PREFIX_SRM
	flags = FACTION_CHECK_PREFIX | FACTION_PLAYER_SELECT
	color = "#6B3500"

/datum/faction/inteq
	name = FACTION_INTEQ
	short_name = "INTEQ"
	parent_faction = /datum/faction/inteq
	prefixes = PREFIX_INTEQ
	flags = FACTION_CHECK_PREFIX | FACTION_PLAYER_SELECT
	color = "#E6B93C"

/datum/faction/clip
	name = FACTION_CLIP
	short_name = "CLIP"
	parent_faction = /datum/faction/clip
	official_language = /datum/language/league_kalixcian
	prefixes = PREFIX_CLIP
	flags = FACTION_CHECK_PREFIX | FACTION_PLAYER_SELECT | FACTION_CITIZENSHIP
	color = "#3F90DF"

/datum/faction/warra
	name = FACTION_WARRA
	short_name = "MAKOSSO-WARRA"
	parent_faction = /datum/faction/warra
	prefixes = PREFIX_WARRA
	flags = FACTION_CHECK_PREFIX | FACTION_PLAYER_SELECT
	hostile_factions = list(
		/datum/faction/syndicate/concordat,
		/datum/faction/syndicate/hardliners,
		/datum/faction/syndicate/liberation_front,
		/datum/faction/frontiersmen,
		/datum/faction/ramzi,
	)
	color = "#0094FF"

/datum/faction/warra/ns_logi
	name = FACTION_NS_LOGI
	prefixes = PREFIX_NS_LOGI
	color = "#FF6600"

/datum/faction/warra/vigilitas
	name = FACTION_VIGILITAS
	prefixes = PREFIX_VIGILITAS
	color = "#d40000"

/datum/faction/frontiersmen
	name = FACTION_FRONTIERSMEN
	prefixes = PREFIX_FRONTIERSMEN
	flags = FACTION_PLAYER_SELECT
	hostile_factions = list(/datum/faction)
	color = "#80735D"
	parent_faction = /datum/faction/frontiersmen
	order = FACTION_SORT_ASPAWN

/datum/faction/pgf
	name = FACTION_PGF
	short_name = "PGF"
	parent_faction = /datum/faction/pgf
	official_language = /datum/language/gezena_kalixcian
	prefixes = PREFIX_PGF
	hostile_factions = list(
		/datum/faction/frontiersmen,
		/datum/faction/ramzi,
		/datum/faction/zohil,
	)
	flags = FACTION_CHECK_PREFIX | FACTION_PLAYER_SELECT | FACTION_CITIZENSHIP
	color = "#359829"

/datum/faction/zohil // in case anyone wants to give zohil a ship
	name = FACTION_ZOHIL
	short_name = "ZHL"
	parent_faction = /datum/faction/zohil
	official_language = /datum/language/zohil_kalixcian
	prefixes = PREFIX_ZOHIL
	hostile_factions = list(
		/datum/faction/frontiersmen,
		/datum/faction/ramzi,
		/datum/faction/pgf
	)
	flags = FACTION_CHECK_PREFIX | FACTION_PLAYER_SELECT | FACTION_CITIZENSHIP
	color = "#6b2ba0"

/datum/faction/teceti
	name = FACTION_TECETI
	short_name = "UTF"
	parent_faction = /datum/faction/teceti
	official_language = /datum/language/teceti_unified
	prefixes = PREFIX_TECETI
	flags = FACTION_CHECK_PREFIX | FACTION_PLAYER_SELECT | FACTION_CITIZENSHIP
	color = "#ffeed0"

/datum/faction/independent
	name = FACTION_INDEPENDENT
	short_name = "IND"
	parent_faction = /datum/faction/independent
	prefixes = PREFIX_INDEPENDENT
	hostile_factions = list()
	color = "#A0A0A0"
	order = FACTION_SORT_INDEPENDENT

/datum/faction/independent/allowed_faction(value_to_check)
	return TRUE

/datum/faction/independent/is_hostile_to(value_to_check)
	return FALSE

/datum/faction/ramzi
	name = FACTION_RAMZI
	short_name = "RAM"
	parent_faction = /datum/faction/ramzi
	prefixes = PREFIX_RAMZI
	flags = FACTION_PLAYER_SELECT
	hostile_factions = list(/datum/faction)
	color = "#c45508"
	order = FACTION_SORT_ASPAWN

/datum/faction/unknown
	name = FACTION_UNKNOWN
	short_name = "???"
	parent_faction = /datum/faction/unknown
	prefixes = PREFIX_NONE
	flags = FACTION_CHECK_PREFIX | FACTION_WIKI_HIDDEN
	hostile_factions = list()
	color = "#504c4c"
	order = FACTION_SORT_ASPAWN

/datum/faction/unknown/allowed_faction(value_to_check)
	return TRUE

/datum/faction/unknown/is_hostile_to(value_to_check)
	return FALSE
