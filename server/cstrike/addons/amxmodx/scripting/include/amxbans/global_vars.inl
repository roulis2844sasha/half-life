#if defined _global_vars_included
	#endinput
#endif

#define _global_vars_included

#define TBL_SERVERINFO "_serverinfo"
#define TBL_REASONS "_reasons"
#define TBL_REASONSSET "_reasons_to_set"
#define TBL_BANS "_bans"
#define TBL_FLAGGED "_flagged"

#define PDATA_DISCONNECTED 0
#define PDATA_CONNECTING 1
#define PDATA_CONNECTED 2
#define PDATA_BOT 3
#define PDATA_HLTV 4
#define PDATA_BEING_BANNED 5
#define PDATA_KICKED 6
#define PDATA_FLAGGED 7
#define PDATA_ADMIN 8
#define PDATA_IMMUNITY 9
#define PDATA_IN_FLAGGING 10

#define set_user_state(%1,%2) (playerData[%1][playerState] = (1<<%2))
#define add_user_state(%1,%2) (playerData[%1][playerState] |= (1<<%2))
#define get_user_state(%1,%2) (playerData[%1][playerState] & (1<<%2))
#define remove_user_state(%1,%2) (playerData[%1][playerState] &= ~(1<<%2))
#define is_user_disconnected(%1) (get_user_state(%1, PDATA_DISCONNECTED) || (!is_user_connecting(%1) && !get_user_state(%1, PDATA_CONNECTED)))

enum _banData
{
	banReason[128],
	banSteamid[34],
	banName[32],
	banIp[22],
	banType[3],
	banTime,
	banPlayer
}

new banData[33][_banData]

enum _flagData
{
	flagReason[128],
	flagSteamid[34],
	flagName[32],
	flagIp[22],
	flagTime,
	flagPlayer
}

new flagData[33][_flagData]

enum _playerData
{
	playerFlagReason[128],
	playerSteamid[34],
	playerName[32],
	playerIp[22],
	playerFlagTime,
	playerState
}

new playerData[33][_playerData]

enum MFHandles
{
	Ban_MotdOpen,
	Player_Flagged,
	Player_UnFlagged
}

new MFHandle[MFHandles]

new g_ident[50]
new g_ip[32]
new g_dbPrefix[32]
new g_port[10]

new plnum
new g_MyMsgSync
new g_coloredMenus

new pcvar_serverip
new pcvar_server_nick
new pcvar_discon_in_banlist
new pcvar_complainurl
new pcvar_debug
new pcvar_add_mapname
new pcvar_flagged_all
new pcvar_show_in_hlsw
new pcvar_show_hud_messages
new pcvar_higher_ban_time_admin
new pcvar_admin_mole_access
new pcvar_show_name_evenif_mole
new pcvar_custom_statictime
new pcvar_show_prebanned
new pcvar_show_prebanned_num
new pcvar_default_banreason
new pcvar_offset
new pcvar_bantype
new pcvar_snapshot
new pcvar_flag
new pcvar_history
new pcvar_activity
new pcvar_hostname

new Handle:g_SqlX

new Float:kick_delay = 10.0

new Array:g_banReasons
new Array:g_banReasons_Bantime

new Array:g_AReplaceInd
new Array:g_AReplace
new Array:g_ReplaceInd
new Array:g_Replace

new Array:g_disconPLname
new Array:g_disconPLauthid
new Array:g_disconPLip

new g_highbantimesnum
new g_lowbantimesnum
new g_flagtimesnum

new g_HighBanMenuValues[14]
new g_LowBanMenuValues[14]
new g_FlagMenuValues[14]