#if defined _menu_history_included
    #endinput
#endif
#define _menu_history_included

#include <amxmodx>

public cmdBanhistoryMenu(id, level, cid) 
{
	if(!cmd_access(id, level, cid, 1) || !get_pcvar_num(pcvar_history))
	{
		return PLUGIN_HANDLED
	}
	
	new menu = menu_create("menu_history", "actionHistoryMenu")
	new callback = menu_makecallback("callback_MenuGetPlayers")
	
	MenuSetProps(id, menu, "BANHISTORY_MENU")
	MenuGetPlayers(menu, callback)

	return menu_display(id, menu, 0)
}

public actionHistoryMenu(id, menu, item) 
{
	if(item < 0) 
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new acc, szInfo[3], szText[128], callb
	menu_item_getinfo(menu, item, acc, szInfo, 2, szText, 127, callb)
	
	new pid = str_to_num(szInfo)
	
	menu_destroy(menu)
	
	new pquery[256]
	format(pquery, 255, "SELECT `amxban_motd` FROM `%s%s` WHERE `address` = '%s:%s';", g_dbPrefix, TBL_SERVERINFO, g_ip, g_port)
	
	new data[2]
	data[0] = id
	data[1] = pid

	return SQL_ThreadQuery(g_SqlX, "select_motd_history", pquery, data, 2)
}

public select_motd_history(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}
	
	new id = data[0]
	new pid = data[1]
	
	new motd_url[256]
	if(!SQL_NumResults(query)) 
	{
		return SQL_FreeHandle(query)
	}
	
	SQL_ReadResult(query, 0, motd_url, 256)
	
	SQL_FreeHandle(query)
	
	if(contain(motd_url,"?sid=%s&adm=%d&lang=%s") != -1) 
	{
		new url[256], lang[5], title[128]
		
		formatex(title, 127, "%L", id, "HISTORY_MOTD", playerData[pid][playerName])
		
		get_user_info(id, "lang", lang, 4)
		if(equal(lang, ""))
		{
			get_cvar_string("amx_language", lang, 4)
		}
		
		formatex(url, 255, motd_url, playerData[pid][playerSteamid], 1, lang)
		if(get_pcvar_num(pcvar_debug) >= 2)
		{
			log_amx("[AMXBans BanHistory Motd] %s", url)
		}
		
		show_motd(id, url, title)
	} 
	else 
	{
		log_amx("[AMXBans ERROR BanHistory] %L", LANG_SERVER, "NO_MOTD")
		ColorChat(id, RED, "%s %L", PREFIX, id, "NO_MOTD")
	}
	
	return PLUGIN_HANDLED
}