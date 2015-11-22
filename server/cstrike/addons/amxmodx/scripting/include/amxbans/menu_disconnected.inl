#if defined _menu_disconnected_included
    #endinput
#endif

#define _menu_disconnected_included

#include <amxmodx>
#include <amxmisc>
#include <sqlx>

public cmdBanDisconnectedMenu(id, level, cid) 
{
	if(!cmd_access(id, level, cid, 1))
	{
		return PLUGIN_HANDLED
	}
		
	new dnum = ArraySize(g_disconPLname)
	
	if(!dnum) 
	{
		return ColorChat(id, RED, "%s %L", PREFIX, id, "NO_DISCONNECTED_PLAYER_IN_LIST")
	}
	
	new menu = menu_create("menu_discplayer", "actionBanDisconnectedMenu")
	
	new szText[64]
	if(g_coloredMenus)
	{
		formatex(szText, 63, "\y%L\w", id, "BANDISCONNECTED_MENU", dnum)
	}
	else
	{
		formatex(szText, 63, "%L", id, "BANDISCONNECTED_MENU", dnum)
	}
	
	menu_setprop(menu, MPROP_TITLE, szText)
	
	formatex(szText, 63, "%L", id, "BACK")
	menu_setprop(menu, MPROP_BACKNAME, szText)
	
	formatex(szText, 63, "%L", id, "MORE")
	menu_setprop(menu, MPROP_NEXTNAME, szText)
	
	formatex(szText, 63, "%L^n^n%sAMXBans %s", id, "EXIT", g_coloredMenus ? "\y" : "", VERSION)
	menu_setprop(menu, MPROP_EXITNAME, szText)
	
	new szDisplay[128], szArId[3]
	for(new i = dnum - 1; i >= 0; i--) 
	{
		ArrayGetString(g_disconPLname, i, szDisplay, 127)
		num_to_str(i, szArId, 3)
		menu_additem(menu, szDisplay, szArId, 0)
	}

	return menu_display(id, menu, 0)
}

public actionBanDisconnectedMenu(id, menu, item) 
{
	if(item < 0) 
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new acc, szInfo[3], szText[128], callb
	menu_item_getinfo(menu, item, acc, szInfo, 2, szText, 127, callb)
	
	new aid = str_to_num(szInfo)
	
	ArrayGetString(g_disconPLname, aid, banData[id][banName], 31)
	ArrayGetString(g_disconPLauthid, aid, banData[id][banSteamid], 33)
	ArrayGetString(g_disconPLip, aid, banData[id][banIp], 21)
	banData[id][banPlayer] = 0
	
	if(get_pcvar_num(pcvar_debug) >= 2)
	{
		log_amx("[AMXBans PlayerDiscMenu %d] %d choice: %s | %s | %s | %d", menu, id, banData[id][banName], banData[id][banSteamid], banData[id][banIp], 0)
	}
	
	if(amxbans_get_static_bantime(id)) 
	{
		set_task(0.2, "cmdReasonMenu", id)
	} 
	else 
	{
		set_task(0.2, "cmdBantimeMenu", id)
	}

	menu_destroy(menu)
	return PLUGIN_HANDLED
}

public cmdMenuBanDisc(id) 
{
	if(!id) return PLUGIN_HANDLED
	
	if(!get_ban_type(banData[id][banType], 2, banData[id][banSteamid], banData[id][banIp])) 
	{
		return log_amx("[AMXBans Disc ERROR] Steamid / IP Invalid! Bantype: <%s> | Authid: <%s> | IP: <%s>", banData[id][banType], banData[id][banSteamid], banData[id][banIp])
	}
	
	if(get_pcvar_num(pcvar_debug) >= 2) 
	{
		log_amx("[AMXBans cmdMenuBanDisc %d] %d | %s | %s | %s | %s (%d min)", id,\
		0, banData[id][banName], banData[id][banSteamid], banData[id][banIp], banData[id][banReason], banData[id][banTime])
	}
	
	new pquery[1024]
	
	if(equal(banData[id][banType], "S")) 
	{
		formatex(pquery, 1023, "SELECT `player_id` FROM `%s%s` WHERE `player_id` = '%s' AND `expired` = '0';", g_dbPrefix, TBL_BANS, banData[id][banSteamid])
		if(get_pcvar_num(pcvar_debug) >= 2)
		{
			log_amx("[AMXBans cmdMenuBanDisc] Banned a player by SteamID")
		}
	} 
	else 
	{
		formatex(pquery, 1023, "SELECT `player_ip` FROM `%s%s` WHERE `player_ip` = '%s' AND `expired` = '0';", g_dbPrefix, TBL_BANS, banData[id][banIp])
		if(get_pcvar_num(pcvar_debug) >= 2)
		{
			log_amx("[AMXBans cmdMenuBanDisc] Banned a player by IP/steamID")
		}
	}
	
	new data[1]
	data[0] = id

	return SQL_ThreadQuery(g_SqlX, "_cmdMenuBanDisc", pquery, data, 1)
}

public _cmdMenuBanDisc(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}
	
	new id = data[0]
	
	if(get_pcvar_num(pcvar_debug) >= 1)
	{
		log_amx("[cmdMenuBanDisc function 2]")
	}
	
	if(SQL_NumResults(query)) 
	{
		ColorChat(id, RED, "%s %L", PREFIX, id, "ALREADY_BANNED", banData[id][banSteamid], banData[id][banIp])
		return SQL_FreeHandle(query)
	}
	
	SQL_FreeHandle(query)
	
	new admin_nick[64]
	mysql_get_username_safe(id, admin_nick, 63)
	
	
	new server_name[256]
	mysql_get_servername_safe(server_name, 255)
	
	if(get_pcvar_num(pcvar_add_mapname) == 1) 
	{
		new mapname[32]
		get_mapname(mapname, 31)
		format(server_name, 255, "%s (%s)", server_name, mapname)
	}

	mysql_escape_string(server_name, 255)
	
	new player_name[64]
	copy(player_name, 63, banData[id][banName])
	mysql_escape_string(player_name, 63)
	
	new pquery[1024], len

#if defined SET_NAMES_UTF8	
	
	len = format(pquery, 1023, "SET NAMES UTF8; INSERT INTO `%s%s` (`player_id`, `player_ip`, `player_nick`, `admin_ip`, `admin_id`, `admin_nick`, `ban_type`,\
		`ban_reason`, `cs_ban_reason`, `ban_created`, `ban_length`, `server_name`, `server_ip`, `expired`) ", g_dbPrefix, TBL_BANS)
	len += format(pquery[len], 1023 - len, "VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', UNIX_TIMESTAMP(NOW()), '%d', '%s', '%s:%s', '0');", banData[id][banSteamid],banData[id][banIp], player_name, playerData[id][playerIp], playerData[id][playerSteamid], admin_nick, banData[id][banType], banData[id][banReason], "See banlist", banData[id][banTime], server_name, g_ip, g_port)

#else

	len = format(pquery, 1023, "INSERT INTO `%s%s` (`player_id`, `player_ip`, `player_nick`, `admin_ip`, `admin_id`, `admin_nick`, `ban_type`,\
		`ban_reason`, `cs_ban_reason`, `ban_created`, `ban_length`, `server_name`, `server_ip`, `expired`) ", g_dbPrefix, TBL_BANS)
	len += format(pquery[len], 1023 - len, "VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', UNIX_TIMESTAMP(NOW()), '%d', '%s', '%s:%s', '0');", banData[id][banSteamid],banData[id][banIp], player_name, playerData[id][playerIp], playerData[id][playerSteamid], admin_nick, banData[id][banType], banData[id][banReason], banData[id][banReason], banData[id][banTime], server_name, g_ip, g_port)
	
#endif	
	
	return SQL_ThreadQuery(g_SqlX, "__cmdMenuBanDisc", pquery, data, 1)
}

public __cmdMenuBanDisc(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		ColorChat(data[0], RED, "%s %L", PREFIX, data[0], "BAN_DISCONNECTED_PLAYER_FAILED")
		return SQL_Error(query, error, errornum, failstate)
	}
	
	new id = data[0]
	
	if(get_pcvar_num(pcvar_debug) >= 1)
	{
		log_amx("[AMXBans cmdMenuBanDisc function 3] %d: %s", id, banData[id][banName])
	}
	
	ColorChat(id, RED, "%s %L", PREFIX, id, "BAN_DISCONNECTED_PLAYER_SUCCESS")
	
#if defined SET_NAMES_UTF8	
	
	SQL_FreeHandle(query)
	
	new pquery[1024]
	formatex(pquery, 1023, "UPDATE `%s%s` SET `cs_ban_reason` = '%s' WHERE `bid` = (SELECT MAX(`bid`) FROM `%s%s` WHERE (`player_ip` = '%s' AND `ban_type` = 'SI') OR (`player_id` = '%s' AND `ban_type` = 'S'));", g_dbPrefix, TBL_BANS, banData[id][banReason], g_dbPrefix, TBL_BANS, banData[id][banIp], banData[id][banSteamid])

	return SQL_ThreadQuery(g_SqlX, "KOCTblJIb", pquery)
}

public KOCTblJIb(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}

#endif	
	
	return SQL_FreeHandle(query)
}

stock disconnect_remove_player(id) 
{
	if(get_user_state(id, PDATA_BOT)) return PLUGIN_CONTINUE
	
	new dnum = ArraySize(g_disconPLauthid)
	if(!dnum) return PLUGIN_CONTINUE
	
	new tmpid[35], tmpip[22]
	
	for(new i; i < dnum; i++) 
	{
		ArrayGetString(g_disconPLauthid, i, tmpid, 34)
		ArrayGetString(g_disconPLip, i, tmpip, 21)
		if(!equal(playerData[id][playerSteamid], tmpid) && !equal(playerData[id][playerIp], tmpip)) continue
		disc_array_remove_item(i)
		break
	}

	return disc_debug_list()
}

stock disconnected_add_player(id) 
{
	if(get_user_state(id, PDATA_BOT)) return PLUGIN_CONTINUE
	
	new maxnum = get_pcvar_num(pcvar_discon_in_banlist)
	if(!maxnum) return PLUGIN_CONTINUE
	
	new dnum = ArraySize(g_disconPLname)

	ArrayPushString(g_disconPLname, playerData[id][playerName])
	ArrayPushString(g_disconPLauthid, playerData[id][playerSteamid])
	ArrayPushString(g_disconPLip, playerData[id][playerIp]) 
	
	while(dnum >= maxnum) 
	{
		disc_array_remove_item(0)
		dnum--
	}

	return disc_debug_list()
}

stock disc_array_remove_item(item) 
{
	ArrayDeleteItem(g_disconPLname, item)
	ArrayDeleteItem(g_disconPLauthid, item)
	ArrayDeleteItem(g_disconPLip, item)
	return 1
}

stock disc_debug_list() 
{
	if(get_pcvar_num(pcvar_debug) < 4) return PLUGIN_CONTINUE
	
	new dnum = ArraySize(g_disconPLname)
	new maxnum = get_pcvar_num(pcvar_discon_in_banlist)
	
	for(new i; i < dnum; i++) 
	{
		log_amx("[AMXBans DiscList %d/%d] %d %a | %a | %a", dnum, maxnum, i,\
			ArrayGetStringHandle(g_disconPLname, i),\
			ArrayGetStringHandle(g_disconPLauthid, i),\
			ArrayGetStringHandle(g_disconPLip, i))
	}
	return PLUGIN_CONTINUE
}