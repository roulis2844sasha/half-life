#if defined _menu_ban_included
    #endinput
#endif

#define _menu_ban_included

#include <amxmodx>
#include <amxmisc>

public cmdBanMenu(id, level, cid) 
{
	if(!cmd_access(id, level, cid, 1))
	{
		return PLUGIN_HANDLED
	}
	
	cmdBanMenu2(id)
	
	return PLUGIN_HANDLED
}
	
public cmdBanMenu2(id) 
{
	new menu = menu_create("menu_player", "actionBanMenu")
	
	MenuSetProps(id, menu, "BAN_MENU")

	new callback = menu_makecallback("callback_MenuGetPlayers")
	MenuGetPlayers(menu, callback)
	
	menu_display(id, menu, 0)
	
	return PLUGIN_HANDLED
}

public actionBanMenu(id, menu, item) 
{
	if(item < 0) 
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new acc, szInfo[3], szText[128], callb
	menu_item_getinfo(menu, item, acc, szInfo, 2, szText, 127, callb)
		
	new pid = str_to_num(szInfo)
	
	if(!get_user_state(pid, PDATA_CONNECTED))
	{
		ColorChat(id, RED, "%s %L", PREFIX, id, "PLAYER_LEAVED")
		return client_cmd(id, "amx_bandisconnectedmenu")
	}
	
	copy(banData[id][banName], 31, playerData[pid][playerName])
	copy(banData[id][banSteamid], 33, playerData[pid][playerSteamid])
	copy(banData[id][banIp], 21, playerData[pid][playerIp])
	banData[id][banPlayer] = pid
	
	if(get_pcvar_num(pcvar_debug) >= 2)
	{
		log_amx("[AMXBans PlayerMenu %d] %d choice: %d | %s | %s | %d", menu, id, banData[id][banName], banData[id][banSteamid], banData[id][banIp], banData[id][banPlayer])
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

public cmdBantimeMenu(id) 
{
	new menu = menu_create("menu_bantime", "actionBantimeMenu")
	
	MenuSetProps(id, menu, "BANTIME_MENU")
	MenuGetBantime(id, menu)

	return menu_display(id, menu, 0)
}

public actionBantimeMenu(id, menu, item) 
{
	if(item < 0) 
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new acc, szInfo[11], szText[128], callb
	menu_item_getinfo(menu, item, acc, szInfo, 10, szText, 127, callb)
	
	banData[id][banTime] = str_to_num(szInfo)
	
	if(get_pcvar_num(pcvar_debug) >= 2)
	{
		log_amx("[AMXBans BantimeMenu %d] %d choice: %d min", menu, id, banData[id][banTime])
	}
	
	set_task(0.2, "cmdReasonMenu", id)

	menu_destroy(menu)
	return PLUGIN_HANDLED
}

public cmdReasonMenu(id) 
{
	new menu = menu_create("menu_banreason", "actionReasonMenu")
	
	MenuSetProps(id, menu, "REASON_MENU")
	MenuGetReason(id, menu, amxbans_get_static_bantime(id))

	return menu_display(id, menu, 0)
}

public actionReasonMenu(id, menu, item) 
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
		if(amxbans_get_static_bantime(id)) banData[id][banTime] = get_pcvar_num(pcvar_custom_statictime)
		remove_user_state(id, PDATA_IN_FLAGGING)
		client_cmd(id, "messagemode amxbans_custombanreason")
		menu_destroy(menu)
		return PLUGIN_HANDLED
	} 
	else 
	{
		ArrayGetString(g_banReasons, aid, banData[id][banReason], 127)
		if(amxbans_get_static_bantime(id)) banData[id][banTime] = ArrayGetCell(g_banReasons_Bantime, aid)
	}
	
	if(get_pcvar_num(pcvar_debug) >= 2)
	{
		log_amx("[AMXBans ReasonMenu %d] %d choice: %s (%d min)", menu, id, banData[id][banReason], banData[id][banTime])
	}
	
	if(banData[id][banPlayer] == -1) 
	{
		cmdMenuBanDisc(id)
	} 
	else 
	{
		cmdMenuBan(id)
	}

	menu_destroy(menu)
	return PLUGIN_HANDLED
}