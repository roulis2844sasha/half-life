#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <sqlx>
#include <time>

#define AUTHOR "Larte Team"
#define PLUGIN_NAME "AMXBans: Main"
#define VERSION "Gm 1.6"
#define DATE "14:25 26.04.2011"

#define PREFIX "!y[!tAMXBans!y]"

#define AMXBANS_VERSION "1.6"

//#define UNBAN_GAME_DEL // раскомментировать для удаления бана при разбане
#define SET_NAMES_UTF8 // закомментировать, если русские причины банов нормально отображались и в ранних версиях

#include "include/amxbans_core.inc"

#include "include/amxbans/global_vars.inl"
#include "include/amxbans/color_chat.inl"
#include "include/amxbans/init_functions.inl"
#include "include/amxbans/check_player.inl"
#include "include/amxbans/check_flag.inl"
#include "include/amxbans/menu_stocks.inl"
#include "include/amxbans/menu_ban.inl"
#include "include/amxbans/menu_disconnected.inl"
#include "include/amxbans/menu_history.inl"
#include "include/amxbans/menu_flag.inl"
#include "include/amxbans/cmd_ban.inl"
#include "include/amxbans/cmd_unban.inl"
#include "include/amxbans/web_handshake.inl"
#include "include/amxbans/reason_checker.inl"

#pragma dynamic 16384

public plugin_init() 
{
	register_plugin(PLUGIN_NAME, VERSION, AUTHOR)
	register_cvar("amxbans_version", VERSION, FCVAR_SERVER | FCVAR_EXTDLL | FCVAR_UNLOGGED| FCVAR_SPONLY)
	
	register_dictionary("amxbans.txt")
	register_dictionary("common.txt")
	register_dictionary("time.txt")
	
	register_clcmd("amx_banmenu", "cmdBanMenu", ADMIN_BAN, "- displays ban menu")
	register_clcmd("amxbans_custombanreason", "setCustomBanReason", ADMIN_BAN, "- configures custom ban message")
	register_clcmd("amx_banhistorymenu", "cmdBanhistoryMenu", ADMIN_BAN, "- displays banhistorymenu")
	register_clcmd("amx_bandisconnectedmenu", "cmdBanDisconnectedMenu", ADMIN_BAN, "- displays bandisconnectedmenu")
	register_clcmd("amx_flaggingmenu","cmdFlaggingMenu", ADMIN_BAN, "- displays flagging menu")
	
	register_srvcmd("amx_sethighbantimes", "setHighBantimes")
	register_srvcmd("amx_setlowbantimes", "setLowBantimes")
	register_srvcmd("amx_setflagtimes", "setFlagTimes")
	
	register_concmd("amx_reloadreasons", "cmdFetchReasons", ADMIN_CFG)
	
	pcvar_serverip = register_cvar("amxbans_server_address", "")
	pcvar_server_nick = register_cvar("amxbans_servernick", "")
	pcvar_discon_in_banlist = register_cvar("amxbans_discon_players_saved", "10")
	pcvar_complainurl = register_cvar("amxbans_complain_url", "www.yoursite.com")
	pcvar_debug = register_cvar("amxbans_debug", "0")
	pcvar_add_mapname = register_cvar("amxbans_add_mapname_in_servername", "0")
	pcvar_flagged_all = register_cvar("amxbans_flagged_all_server","1")
	pcvar_show_in_hlsw = register_cvar("amxbans_show_in_hlsw", "1")
	pcvar_show_hud_messages = register_cvar("amxbans_show_hud_messages", "1")
	pcvar_higher_ban_time_admin = register_cvar("amxbans_higher_ban_time_admin", "n")
	pcvar_admin_mole_access = register_cvar("amxbans_admin_mole_access", "r")
	pcvar_show_name_evenif_mole = register_cvar("amxbans_show_name_evenif_mole", "1")
	pcvar_custom_statictime = register_cvar("amxbans_custom_statictime", "1440")
	pcvar_show_prebanned = register_cvar("amxbans_show_prebanned", "1")
	pcvar_show_prebanned_num = register_cvar("amxbans_show_prebanned_num", "2")
	pcvar_default_banreason = register_cvar("amxbans_default_ban_reason", "unknown")
	pcvar_offset = register_cvar("amxbans_time_offset", "0")
	pcvar_snapshot = register_cvar("amxbans_snapshot", "1")
	pcvar_bantype = register_cvar("amxbans_bantype", "0")
	pcvar_flag = register_cvar("amxbans_check_flag", "1")
	pcvar_history = register_cvar("amxbans_history_menu", "1")
	pcvar_activity = get_cvar_pointer("amx_show_activity")
	pcvar_hostname = get_cvar_pointer("hostname")
	
	register_concmd("amx_ban", "cmdBan", ADMIN_BAN, "<time in mins> <steamID or nickname or #authid or IP> <reason>")
	register_concmd("amx_banip", "cmdBan", ADMIN_BAN, "<time in mins> <steamID or nickname or #authid or IP> <reason>")
	register_concmd("amx_unban", "cmdUnBan", ADMIN_BAN, "<steamID or IP>")
	
	register_srvcmd("amx_list", "cmdLst", ADMIN_RCON, "sends playerinfos to web")
	
	g_coloredMenus = colored_menus()
	g_MyMsgSync = CreateHudSyncObj()
	
	g_banReasons = ArrayCreate(128, 7)
	g_banReasons_Bantime = ArrayCreate(1, 7)
	
	g_disconPLname = ArrayCreate(32, 1)
	g_disconPLauthid = ArrayCreate(35, 1)
	g_disconPLip = ArrayCreate(22, 1)
	
	g_AReplaceInd = ArrayCreate(64, 1)
	g_AReplace = ArrayCreate(64, 1)
	g_ReplaceInd = ArrayCreate(64, 1)
	g_Replace = ArrayCreate(64, 1)
	
	plnum = get_maxplayers()
	
	for(new i = 1; i <= plnum; i++)
	{
		set_user_state(i, PDATA_DISCONNECTED)
	}

	new configsDir[64]
	get_configsdir(configsDir, 63)
	
	server_cmd("exec %s/amxbans.cfg", configsDir)
	
	color_chat_init()
	load_replaces()
	
	return PLUGIN_CONTINUE
}

stock create_forwards() 
{
	MFHandle[Ban_MotdOpen] = CreateMultiForward("amxbans_ban_motdopen", ET_IGNORE, FP_CELL)
	MFHandle[Player_Flagged] = CreateMultiForward("amxbans_player_flagged", ET_IGNORE, FP_CELL, FP_CELL, FP_STRING)
	MFHandle[Player_UnFlagged] = CreateMultiForward("amxbans_player_unflagged", ET_IGNORE, FP_CELL)
	return PLUGIN_CONTINUE
}

public addMenus() 
{
	new szKey[128]
	
	if(get_pcvar_num(pcvar_flag))
	{
		format(szKey, 127, "%L", LANG_SERVER, "ADMMENU_FLAGGING")
		AddMenuItem(szKey, "amx_flaggingmenu", ADMIN_BAN, PLUGIN_NAME)
	}
	
	if(get_pcvar_num(pcvar_discon_in_banlist))
	{
		format(szKey, 127, "%L", LANG_SERVER, "ADMMENU_DISCONNECTED")
		AddMenuItem(szKey, "amx_bandisconnectedmenu", ADMIN_BAN, PLUGIN_NAME)
	}
	
	if(get_pcvar_num(pcvar_history))
	{
		format(szKey, 127, "%L", LANG_SERVER, "ADMMENU_HISTORY")
		AddMenuItem(szKey, "amx_banhistorymenu", ADMIN_BAN, PLUGIN_NAME)
	}

	return PLUGIN_CONTINUE
}

public amxbans_sql_initialized(Handle:sqlTuple, const dbPrefix[]) 
{
	if(g_SqlX != Empty_Handle) 
	{
		if(get_pcvar_num(pcvar_debug) >= 1)
		{
			log_amx("[AMXBans Notice] DB Info Tuple from amxbans_core initialized twice! Maybee used command amx_realoadadmins.")
		}
		return PLUGIN_CONTINUE
	}

	copy(g_dbPrefix, 31, dbPrefix)
	
	get_user_ip(0, playerData[0][playerIp], 21, 1)

	g_SqlX = sqlTuple
	
	if(get_pcvar_num(pcvar_debug) >= 1)
	{
		log_amx("[AMXBans] Received DB Info Tuple from amxbans_core: %d | %s", sqlTuple, g_dbPrefix)
	}
	
	if(g_SqlX == Empty_Handle) 
	{
		log_amx("[AMXBans Error] DB Info Tuple from amxbans_main is empty! Trying to get a valid one.")
		new host[64], user[64], pass[64], db[64]

		get_cvar_string("amx_sql_host", host, 63)
		get_cvar_string("amx_sql_user", user, 63)
		get_cvar_string("amx_sql_pass", pass, 63)
		get_cvar_string("amx_sql_db", db, 63)
		
		g_SqlX = SQL_MakeDbTuple(host, user, pass, db)
		
		get_cvar_string("amx_sql_prefix", g_dbPrefix, 31)
	}
	
	create_forwards()
	
	set_task(0.1, "banmod_online")
	set_task(0.25, "load_reasons")
	
	if(!get_pcvar_num(pcvar_offset))
	{
		set_task(0.5, "get_offset")
	}

	return set_task(2.0, "addMenus")
}

public get_higher_ban_time_admin_flag() 
{
	new flags[24]
	get_pcvar_string(pcvar_higher_ban_time_admin, flags, 23)
	
	return read_flags(flags)
}

public get_admin_mole_access_flag() 
{
	new flags[24]
	get_pcvar_string(pcvar_admin_mole_access, flags, 23)
	
	return read_flags(flags)
}

public delayed_kick(id) 
{
	id -= 200
	
	if(is_user_disconnected(id))
	{
		return PLUGIN_HANDLED
	}

	if(get_pcvar_num(pcvar_debug) >= 1)
	{
		log_amx("[AMXBANS DEBUG] Delayed Kick ID: <%d>", id)
	}

	add_user_state(id, PDATA_KICKED)

	return server_cmd("kick #%d  %L", get_user_userid(id), id, "KICK_MESSAGE")
}


stock SQL_Error(Handle:query, const error[], errornum, failstate)
{
	new qstring[1024]
	SQL_GetQueryString(query, qstring, 1023)
	
	if(failstate == TQUERY_CONNECT_FAILED) 
	{
		log_amx("%L", LANG_SERVER, "TCONNECTION_FAILED")
	} 
	else if (failstate == TQUERY_QUERY_FAILED) 
	{
		log_amx("%L", LANG_SERVER, "TQUERY_FAILED")
	}
	log_amx("%L", LANG_SERVER, "TQUERY_MSG", error, errornum)
	log_amx("%L", LANG_SERVER, "TQUERY_STATEMENT", qstring)

	return SQL_FreeHandle(query)
}

public client_authorized(id) 
{
	if(id > 201)
	{
		id -= 201
	}
	else
	{
		get_user_name(id, playerData[id][playerName], 31)
		get_user_authid(id, playerData[id][playerSteamid], 33)
		get_user_ip(id, playerData[id][playerIp], 21, 1)
	}
	
	if(g_SqlX == Empty_Handle) 
	{
		return set_task(1.0, "client_authorized", id + 201)
	}
	
	set_user_state(id, PDATA_CONNECTING)
	
	if(is_user_admin(id))
	{
		add_user_state(id, PDATA_ADMIN)
		if(get_user_flags(id) & ADMIN_IMMUNITY)
		{
			add_user_state(id, PDATA_IMMUNITY)
		}
	}

	return set_task(0.25, "check_player", id + 203)
}

public client_putinserver(id) 
{
	if(id > 202)
	{
		id -= 202
	}
	else
	{
		remove_user_state(id, PDATA_CONNECTING)
		
		if(is_user_hltv(id))
		{
			add_user_state(id, PDATA_HLTV)
		}
		if(is_user_bot(id)) 
		{	
			add_user_state(id, PDATA_BOT)
		}
		
		add_user_state(id, PDATA_CONNECTED)
	}
	
	if(g_SqlX == Empty_Handle) 
	{
		return set_task(1.0, "client_putinserver", id + 202)
	}
	
	if(get_user_state(id, PDATA_IMMUNITY))
	{
		return PLUGIN_HANDLED
	}
	
	check_player_post(id)
	disconnect_remove_player(id)
	
	return PLUGIN_CONTINUE
}

public client_disconnect(id) 
{
	if(!get_user_state(id, PDATA_KICKED) && !get_user_state(id, PDATA_IMMUNITY)) 
	{
		disconnected_add_player(id)
	} 

	remove_task(id + 200)
	remove_task(id + 201)
	remove_task(id + 202)
	remove_task(id + 203)
	remove_task(id + 204)
	
	return set_user_state(id, PDATA_DISCONNECTED)
}

public client_infochanged(id)
{
	if(!get_user_state(id, PDATA_CONNECTED))
	{
		return PLUGIN_CONTINUE
	}
	
	get_user_info(id, "name", playerData[id][playerName], 31)
	
	return PLUGIN_CONTINUE
}

public setHighBantimes() 
{
	new arg[32]
	new argc = read_argc() - 1
	g_highbantimesnum = argc

	if(argc < 1 || argc > 14) 
	{
		log_amx("[AMXBANS] You have more than 14 or less than 1 bantimes set in amx_sethighbantimes")
		log_amx("[AMXBANS] Loading default bantimes")
		return loadDefaultBantimes(1)
	}

	new i = 0
	new num[32], flag[32]
	while(i < argc)	
	{
		read_argv(i + 1, arg, 31)
		parse(arg, num, 31, flag, 31)

		if(equali(flag, "m")) 
		{ 
			g_HighBanMenuValues[i] = str_to_num(num)
		} 
		else if(equali(flag, "h")) 
		{
			g_HighBanMenuValues[i] = (str_to_num(num) * 60)
		} 
		else if(equali(flag, "d")) 
		{
			g_HighBanMenuValues[i] = (str_to_num(num) * 1440)
		} 
		else if(equali(flag, "w")) 
		{
			g_HighBanMenuValues[i] = (str_to_num(num) * 10080)
		}
		i++
	}
	
	return PLUGIN_HANDLED
}

public setLowBantimes() 
{
	new arg[32]
	new argc = read_argc() - 1
	g_lowbantimesnum = argc
	
	if(argc < 1 || argc > 14) 
	{
		log_amx("[AMXBANS] You have more than 14 or less than 1 bantimes set in amx_setlowbantimes")
		log_amx("[AMXBANS] Loading default bantimes")
		return loadDefaultBantimes(2)
	}

	new i = 0
	new num[32], flag[32]
	while(i < argc) 
	{
		read_argv(i + 1, arg, 31)
		parse(arg, num, 31, flag, 31)

		if(equali(flag, "m")) 
		{ 
			g_LowBanMenuValues[i] = str_to_num(num)
		} 
		else if(equali(flag, "h")) 
		{
			g_LowBanMenuValues[i] = (str_to_num(num) * 60)
		} 
		else if(equali(flag, "d")) 
		{
			g_LowBanMenuValues[i] = (str_to_num(num) * 1440)
		} 
		else if(equali(flag, "w")) 
		{
			g_LowBanMenuValues[i] = (str_to_num(num) * 10080)
		}
		i++
	}
	
	return PLUGIN_HANDLED
}

public plugin_end()
{
	ArrayDestroy(g_banReasons)
	ArrayDestroy(g_banReasons_Bantime)
	
	ArrayDestroy(g_disconPLname)
	ArrayDestroy(g_disconPLauthid)
	ArrayDestroy(g_disconPLip)
	
	ArrayDestroy(g_AReplaceInd)
	ArrayDestroy(g_AReplace)
	
	ArrayDestroy(g_ReplaceInd)
	ArrayDestroy(g_Replace)
	
	return PLUGIN_CONTINUE
}

public setFlagTimes() 
{
	new arg[32]
	new argc = read_argc() - 1
	g_flagtimesnum = argc
	if(argc < 1 || argc > 14) 
	{
		log_amx("[AMXBANS] You have more than 14 or less than 1 flagtimes set in amx_setflagtimes")
		log_amx("[AMXBANS] Loading default flagtimes")
		return loadDefaultBantimes(3)
	}
	
	new i = 0
	new num[32], flag[32]
	while(i < argc) 
	{
		read_argv(i + 1, arg, 31)
		parse(arg, num, 31, flag, 31)

		if(equali(flag, "m")) 
		{ 
			g_FlagMenuValues[i] = str_to_num(num)
		} 
		else if(equali(flag, "h")) 
		{
			g_FlagMenuValues[i] = (str_to_num(num) * 60)
		} 
		else if(equali(flag, "d")) 
		{
			g_FlagMenuValues[i] = (str_to_num(num) * 1440)
		} 
		else if(equali(flag, "w")) 
		{
			g_FlagMenuValues[i] = (str_to_num(num) * 10080)
		}
		i++
	}
	
	return PLUGIN_HANDLED
}

stock loadDefaultBantimes(num) 
{
	if(num == 1 || num == 0)
	{
		server_cmd("amx_sethighbantimes 5 60 240 600 6000 0")
	}
	if(num == 2 || num == 0)
	{
		server_cmd("amx_setlowbantimes 5 30 60 480 600 1440")
	}
	if(num == 3 || num == 0)
	{
		server_cmd("amx_setflagtimes 60 240 600 1440 10080 40320 90720 0")
	}
	
	return PLUGIN_CONTINUE
}

stock mysql_escape_string(dest[], len)
{
	replace_all(dest, len, "\\", "\\\\")
	replace_all(dest, len, "\0", "\\0")
	replace_all(dest, len, "\n", "\\n")
	replace_all(dest, len, "\r", "\\r")
	replace_all(dest, len, "\x1a", "\Z")
	replace_all(dest, len, "'", "\'")
	replace_all(dest, len, "^"", "\^"")
	
	return 1
}

stock mysql_get_username_safe(id, dest[], len) 
{
	copy(dest, len, playerData[id][playerName])
	return mysql_escape_string(dest, len)
}

stock mysql_get_servername_safe(dest[], len) 
{
	get_pcvar_string(pcvar_hostname, dest, len)
	return mysql_escape_string(dest, len)
}