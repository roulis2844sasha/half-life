#if defined _menu_flag_included
    #endinput
#endif
#define _menu_flag_included

#include <amxmodx>
#include <amxmisc>
#include <sqlx>

public cmdFlaggingMenu(id, level, cid) 
{
	if(!cmd_access(id, level, cid, 1) || !get_pcvar_num(pcvar_flag))
	{
		return PLUGIN_HANDLED
	}
	
	new menu = menu_create("menu_flagplayer", "actionFlaggingMenu")
	new callback = menu_makecallback("callback_MenuGetPlayers")
	
	MenuSetProps(id, menu, "FLAGGING_MENU")
	MenuGetPlayers(menu, callback)

	return menu_display(id, menu, 0)
}

public actionFlaggingMenu(id, menu, item) 
{
	if(item < 0) 
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new acc, szInfo[3], szText[128], callb
	menu_item_getinfo(menu, item, acc, szInfo, 2, szText, 127, callb)
	
	new pid = str_to_num(szInfo)
	
	if(is_user_disconnected(pid))
	{
		return ColorChat(id, RED, "%s %L", PREFIX, id, "PLAYER_LEAVED")
	}
	
	copy(flagData[id][flagName], 31, playerData[pid][playerName])
	copy(flagData[id][flagSteamid], 33, playerData[pid][playerSteamid])
	copy(flagData[id][flagIp], 21, playerData[pid][playerIp])
	flagData[id][flagPlayer] = pid
	
	if(get_pcvar_num(pcvar_debug) >= 2)
	{
		log_amx("[AMXBans FlagPlayerMenu %d] %d choice: %d | %s | %s | %d", menu, id, flagData[id][flagName], flagData[id][flagSteamid], flagData[id][flagIp], pid)
	}
	
	if(get_user_state(pid, PDATA_FLAGGED))
	{
		set_task(0.2, "cmdUnflagMenu", id)
	}
	else
	{
		set_task(0.2, "cmdFlagtimeMenu", id)
	}
	
	menu_destroy(menu)
	return PLUGIN_HANDLED
}

public cmdUnflagMenu(id, level, cid) 
{
	if(!cmd_access(id, level, cid, 1))
	{
		return PLUGIN_HANDLED
	}
	
	new menu = menu_create("menu_unflagplayer", "actionUnflagMenu")
	
	MenuSetProps(id, menu, "UNFLAG_MENU")
	
	new pid = flagData[id][flagPlayer]
	
	new szDisplay[128], szTime[64]
	
	get_flagtime_string(id, playerData[pid][playerFlagTime], szTime, 63, 1)
	
	if(g_coloredMenus)
	{
		format(szTime, 63, "\y(%s: %s)\w", szTime, playerData[pid][playerFlagReason])
	}
	else
	{
		format(szTime, 63, "(%s: %s)", szTime, playerData[pid][playerFlagReason])
	}
	
	formatex(szDisplay, 127, "%L %s", id, "UNFLAG_PLAYER", szTime)
	menu_additem(menu, szDisplay, "1", 0)
	
	formatex(szDisplay, 127, "%L", id, "FLAG_PLAYER_NEW")
	menu_additem(menu, szDisplay, "2", 0)

	return menu_display(id, menu, 0)
}

public actionUnflagMenu(id, menu, item) 
{
	if(item < 0) 
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new acc, szInfo[3], szText[128], callb
	menu_item_getinfo(menu, item, acc, szInfo, 2, szText, 127, callb)
	
	new mid = str_to_num(szInfo)
	
	if(mid == 1) 
	{
		UnflagPlayer(id, 1)
	} 
	else if(mid == 2) 
	{
		UnflagPlayer(id, 0)
		set_task(0.2, "cmdFlagtimeMenu", id)
	}
	
	menu_destroy(menu)
	return PLUGIN_HANDLED
}

public cmdFlagtimeMenu(id)
{
	new menu = menu_create("menu_flagtime", "actionFlagtimeMenu")
	
	MenuSetProps(id, menu, "FLAGTIME_MENU")
	MenuGetFlagtime(id, menu)

	return menu_display(id, menu, 0)
}

public actionFlagtimeMenu(id, menu, item) 
{
	if(item < 0) 
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new acc, szInfo[11], szText[128], callb
	menu_item_getinfo(menu, item, acc, szInfo, 10, szText, 127, callb)
	
	flagData[id][flagTime] = str_to_num(szInfo)
	
	if(get_pcvar_num(pcvar_debug) >= 2)
	{
		log_amx("[AMXBans FlagtimeMenu %d] %d choice: %d min", menu, id, flagData[id][flagTime])
	}
	
	set_task(0.2, "cmdFlagReasonMenu", id)
	
	menu_destroy(menu)
	
	return PLUGIN_HANDLED
}

public cmdFlagReasonMenu(id) 
{
	
	new menu = menu_create("menu_flagreason","actionFlagReasonMenu")
	
	MenuSetProps(id, menu, "FLAGREASON_MENU")
	MenuGetReason(id, menu, amxbans_get_static_bantime(id))

	return menu_display(id, menu, 0)
}

public actionFlagReasonMenu(id, menu, item) 
{
	if(item < 0) 
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new acc, szInfo[3], szText[128], callb
	menu_item_getinfo(menu, item, acc, szInfo, 2, szText, 127, callb)
	
	new aid = str_to_num(szInfo)
	
	if(aid == 99) 
	{
		if(amxbans_get_static_bantime(id)) flagData[id][flagTime] = get_pcvar_num(pcvar_custom_statictime)
		add_user_state(id, PDATA_IN_FLAGGING)
		client_cmd(id, "messagemode amxbans_custombanreason")
		menu_destroy(menu)
		return PLUGIN_HANDLED
	} 
	else 
	{
		ArrayGetString(g_banReasons, aid, flagData[id][flagReason], 127)
		if(amxbans_get_static_bantime(id)) flagData[id][flagTime] = ArrayGetCell(g_banReasons_Bantime, aid)
	}
	
	if(get_pcvar_num(pcvar_debug) >= 2)
	{
		log_amx("[AMXBans FlagReasonMenu %d] %d choice: %s (%d min)", menu, id, flagData[id][flagReason], flagData[id][flagTime])
	}
	
	FlagPlayer(id)
	
	menu_destroy(menu)
	return PLUGIN_HANDLED
}

stock FlagPlayer(id) 
{
	if(get_pcvar_num(pcvar_debug) >= 2)
	{
		log_amx("[AMXBans FlagPlayer] %d | %s | %s | %s | %s | %d min ", id,\
			flagData[id][flagName], flagData[id][flagSteamid], flagData[id][flagIp],\
			flagData[id][flagReason], flagData[id][flagTime])
	}
			
	new anick[64]
	mysql_get_username_safe(id, anick, 63)

	new pnick[64]
	copy(pnick, 63, flagData[id][flagName])
	mysql_escape_string(pnick, 63)
	
	new pquery[1024]
	
	formatex(pquery, 1023, "INSERT INTO `%s%s` (`player_ip`, `player_id`, `player_nick`, \
		`admin_ip`, `admin_id`, `admin_nick`, `reason`, `created`, `length`, `server_ip`) VALUES \
		('%s', '%s', '%s', '%s', '%s', '%s', '%s', UNIX_TIMESTAMP(NOW()), '%d', '%s:%s');", g_dbPrefix, TBL_FLAGGED, \
		flagData[id][flagIp], flagData[id][flagSteamid], pnick, playerData[id][playerIp], playerData[id][playerSteamid], anick,\
		flagData[id][flagReason], flagData[id][flagTime], g_ip, g_port)
	
	new data[2]
	data[0] = id
	data[1] = flagData[id][flagPlayer]

	return SQL_ThreadQuery(g_SqlX, "_FlagPlayer", pquery, data, 2)
}

stock UnflagPlayer(id, announce = 0) 
{
	if(get_pcvar_num(pcvar_debug) >= 2)
	{
		log_amx("[AMXBans UnflagPlayer] %d | %s", id, flagData[id][flagName])
	}
	
	new pquery[512]
	
	formatex(pquery, 511, "DELETE FROM `%s%s` WHERE `player_id` = '%s' OR `player_ip` = '%s'", g_dbPrefix, TBL_FLAGGED, \
		flagData[id][flagSteamid], flagData[id][flagIp])
	
	if(!get_pcvar_num(pcvar_flagged_all))
	{
		format(pquery, 511, "%s AND `server_ip` = '%s:%s';", pquery, g_ip, g_port)
	}
	
	new data[3]
	data[0] = id
	data[1] = announce
	data[2] = flagData[id][flagPlayer]
	
	return SQL_ThreadQuery(g_SqlX, "_UnflagPlayer", pquery, data, 3)
}

public _FlagPlayer(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		ColorChat(data[0], RED, "%s %L", PREFIX,  data[0], "FLAGG_MESS_ERROR", flagData[data[0]][flagName])
		return SQL_Error(query, error, errornum, failstate)
	}
	
	new id = data[0]
	new pid = data[1]
	
	if(SQL_AffectedRows(query)) 
	{
		ColorChat(id, RED, "%s %L", PREFIX, data[0], "FLAGG_MESS", flagData[id][flagName])
		add_user_state(pid, PDATA_FLAGGED)
		playerData[pid][playerFlagTime] = flagData[id][flagTime]
		copy(playerData[pid][playerFlagReason], 127, flagData[id][flagReason])
		
		new ret
		ExecuteForward(MFHandle[Player_Flagged], ret, pid, (flagData[id][flagTime] * 60), flagData[id][flagReason])
	} 
	else 
	{ 
		ColorChat(id, RED, "%s %L", PREFIX, data[0], "FLAGG_MESS_ERROR", flagData[id][flagName])
		remove_user_state(id, PDATA_FLAGGED)
	}

	return SQL_FreeHandle(query)
}

public _UnflagPlayer(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		ColorChat(data[0], RED, "%s %L", PREFIX,  data[0], "UN_FLAGG_MESS_ERROR", flagData[data[0]][flagName])
		return SQL_Error(query, error, errornum, failstate)
	}
	
	new id  = data[0]
	new pid = data[2]
	
	if(SQL_AffectedRows(query)) 
	{
		if(data[1]) 
		{
			ColorChat(id, RED, "%s %L", PREFIX, data[0], "UN_FLAGG_MESS", flagData[id][flagName])
		}
		
		remove_user_state(pid, PDATA_FLAGGED)
		
		new ret
		ExecuteForward(MFHandle[Player_UnFlagged], ret, pid)
	} 
	else 
	{ 
		ColorChat(id, RED, "%s %L", PREFIX, data[0], "UN_FLAGG_MESS_ERROR", flagData[id][flagName])
	}

	return SQL_FreeHandle(query)
}