#if defined _menu_stocks_included
    #endinput
#endif
#define _menu_stocks_included


#include <amxmodx>
#include <amxmisc>
#include <time>

stock MenuSetProps(id, menu, const title[]) 
{
	new szText[64]
	if(g_coloredMenus)
	{
		formatex(szText, 63, "\y%L\w", id, title)
	}
	else
	{
		formatex(szText, 63, "%L", id, title)
	}
	
	menu_setprop(menu,MPROP_TITLE,szText)
	
	formatex(szText, 63, "%L", id, "BACK")
	menu_setprop(menu, MPROP_BACKNAME, szText)
	
	formatex(szText, 63, "%L", id, "MORE")
	menu_setprop(menu, MPROP_NEXTNAME, szText)
	
	formatex(szText, 63, "%L^n^n%sAMXBans %s", id, "EXIT", g_coloredMenus ? "\y" : "", VERSION)
	menu_setprop(menu, MPROP_EXITNAME, szText)
	
	return 1
}

stock MenuGetPlayers(menu, callback) 
{
	new szID[3], count
	
	for(new i = 1; i <= plnum; i++) 
	{
		if(!get_user_state(i, PDATA_CONNECTED))
		{
			continue
		}
		count++
		num_to_str(i, szID, 2)
		menu_additem(menu, playerData[i][playerName], szID, 0, callback)
	}
	
	return 1
}

stock MenuGetBantime(id, menu) 
{
	if(!g_highbantimesnum || !g_lowbantimesnum) 
	{
		log_amx("[AMXBans Notice] High or Low Bantimes empty, loading defaults")
		loadDefaultBantimes(0)
	}
	
	new szDisplay[128], szTime[11]
	if(get_user_flags(id) & get_higher_ban_time_admin_flag()) 
	{
		for(new i; i < g_highbantimesnum; i++) 
		{
			get_bantime_string(id, g_HighBanMenuValues[i], szDisplay, 127)
			num_to_str(g_HighBanMenuValues[i], szTime, 10)
			menu_additem(menu, szDisplay, szTime)
		}
	} 
	else 
	{
		for(new i; i < g_lowbantimesnum; i++) 
		{
			get_bantime_string(id,g_LowBanMenuValues[i], szDisplay, 127)
			num_to_str(g_LowBanMenuValues[i], szTime, 10)
			menu_additem(menu, szDisplay, szTime)
		}
	}
	
	return 1
}

stock MenuGetReason(id, menu, staticBantime = 0) 
{
	new rnum = ArraySize(g_banReasons)
	new szDisplay[128], szArId[3], szTime[64]
	
	new custom_static_time = get_pcvar_num(pcvar_custom_statictime)
	
	if(custom_static_time >= 0) 
	{
		formatex(szDisplay, 127, "%L", id, "USER_REASON")
		if(staticBantime) 
		{
			get_bantime_string(id, custom_static_time, szTime, 63)
			format(szDisplay, 127, "%s (%s)", szDisplay, szTime)
		}
		menu_additem(menu, szDisplay, "99")
	}
	
	for(new i; i < rnum; i++) 
	{
		ArrayGetString(g_banReasons, i ,szDisplay, 127)
		num_to_str(i, szArId, 2)
		if(staticBantime) 
		{
			get_bantime_string(id, ArrayGetCell(g_banReasons_Bantime, i), szTime, 63)
			format(szDisplay, 127, "%s (%s)", szDisplay, szTime)
		} 
		menu_additem(menu,szDisplay,szArId)
	}
	
	return 1
}

stock MenuGetFlagtime(id, menu) 
{
	if(!g_flagtimesnum) 
	{
		log_amx("[AMXBans Notice] Flagtimes empty, loading defaults")
		loadDefaultBantimes(3)
	}
	
	new szDisplay[128], szTime[11]
	for(new i; i < g_flagtimesnum; i++) 
	{
		get_flagtime_string(id, g_FlagMenuValues[i], szDisplay, 127)
		num_to_str(g_FlagMenuValues[i], szTime, 10)
		menu_additem(menu, szDisplay, szTime)
	}
}

public callback_MenuGetPlayers(id, menu, item) 
{
	new acc, szInfo[3], szText[128], callb
	menu_item_getinfo(menu, item, acc, szInfo, 2, szText, 127, callb)
	
	new pid = str_to_num(szInfo)
	
	new szStatus[64]
	if(g_coloredMenus) 
	{
		if(!get_user_state(pid, PDATA_CONNECTED)) format(szStatus, 63, "%s \r(NOT CONNECTED)\w", szStatus)
		if(get_user_state(pid, PDATA_ADMIN)) format(szStatus, 63, "%s \r*\w", szStatus)
		if(get_user_state(pid, PDATA_BOT)) format(szStatus, 63, "%s \r(BOT)\w", szStatus)
		if(get_user_state(pid, PDATA_HLTV)) format(szStatus, 63, "%s \r(HLTV)\w", szStatus)
		if(get_user_state(pid, PDATA_FLAGGED)) format(szStatus, 63, "%s \r(%L)\w", szStatus, id, "FLAGGED")
		if(get_user_state(pid, PDATA_BEING_BANNED)) format(szStatus, 63, "%s \r(Banning...)\w", szStatus)
	} 
	else 
	{
		if(!get_user_state(pid, PDATA_CONNECTED)) format(szStatus, 63, "%s (NOT CONNECTED)", szStatus)
		if(get_user_state(pid, PDATA_ADMIN)) format(szStatus, 63, "%s *", szStatus)
		if(get_user_state(pid, PDATA_BOT)) format(szStatus, 63, "%s (BOT)", szStatus)
		if(get_user_state(pid, PDATA_HLTV)) format(szStatus, 63, "%s (HLTV)", szStatus)
		if(get_user_state(pid, PDATA_FLAGGED)) format(szStatus, 63, "%s (%L)", szStatus, id, "FLAGGED")
		if(get_user_state(pid, PDATA_BEING_BANNED)) format(szStatus, 63, "%s (Banning...)", szStatus)
	}
	
	formatex(szText, 127, "%s %s", playerData[pid][playerName], szStatus)
	menu_item_setname(menu, item, szText)
	
	if(get_user_state(pid, PDATA_IMMUNITY) || get_user_state(pid, PDATA_BOT) || get_user_state(pid, PDATA_BEING_BANNED) || is_user_disconnected(pid)) return ITEM_DISABLED
	
	return ITEM_ENABLED
}

stock get_bantime_string(id, btime, text[], len) 
{
	if(btime <=0) 
	{
		formatex(text, len, "%L", id, "BAN_PERMANENT")
	} 
	else 
	{
		new szTime[64]
		get_time_length(id, btime, timeunit_minutes, szTime, 63)
		formatex(text, len, "%L", id, "BAN_FOR_MINUTES", szTime)
	}
	
	return 1
}

stock get_flagtime_string(id, btime, text[], len, without = 0) 
{
	if(btime <=0) 
	{
		if(!without) 
		{
			formatex(text, len, "%L", id, "FLAG_PERMANENT")
		} 
		else 
		{
			formatex(text, len, "%L", id, "PERMANENT")
		}
	} 
	else 
	{
		if(!without) 
		{
			new szText[128]
			get_time_length(id, btime, timeunit_minutes, szText, 127)
			formatex(text, len, "%L", id, "FLAG_FOR_MINUTES", szText)
		} 
		else 
		{
			get_time_length(id, btime, timeunit_minutes, text, len)
		}
	}
	
	return 1
}

stock get_ban_type(type[], len, const steamid[], const ip[])
{
	switch(get_pcvar_num(pcvar_bantype))
	{
		case 0:
		{
			if(equal("HLTV", steamid)
			 || equal("STEAM_ID_LAN", steamid)
			 || equal("VALVE_ID_LAN", steamid)
			 || equal("VALVE_ID_PENDING", steamid)
			 || equal("STEAM_ID_PENDING", steamid)) 
			{
				formatex(type, len, "SI")
			} 
			else 
			{
				formatex(type, len, "S")
			}
			if(equal(ip,"127.0.0.1") && equal(type,"SI"))
			{
				return 0
			}
			return 1
		}
		case 1:
		{
			formatex(type, len, "SI")
			return 1
		}
		case 2:
		{
			formatex(type, len, "S")
			return 1
		}
	}
	
	return 0
}


public setCustomBanReason(id, level, cid)
{
	if(!cmd_access(id, level, cid, 1)) 
	{
		return PLUGIN_HANDLED
	}
	
	new szReason[128]
	read_argv(1, szReason, 127)
	copy(banData[id][banReason], 127, szReason)
	copy(flagData[id][flagReason], 127, szReason)
	
	if(get_user_state(id, PDATA_IN_FLAGGING))
	{
		FlagPlayer(id)
		remove_user_state(id, PDATA_IN_FLAGGING)
	} 
	else if(banData[id][banPlayer] == 0) 
	{
		cmdMenuBanDisc(id)
	} 
	else 
	{
		cmdMenuBan(id)
	}
	
	return PLUGIN_HANDLED
}
