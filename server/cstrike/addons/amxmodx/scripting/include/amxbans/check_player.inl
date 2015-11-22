#if defined _check_player_included
    #endinput
#endif

#define _check_player_included

#include <amxmodx>
#include <amxmisc>
#include <sqlx>

public prebanned_check(id) 
{
	id -= 204
	
	if(!get_user_state(id, PDATA_CONNECTED) || get_user_state(id, PDATA_BOT) || get_user_state(id, PDATA_IMMUNITY) || !get_pcvar_num(pcvar_show_prebanned))
	{
		return PLUGIN_HANDLED
	}
	
	new pquery[512]

	formatex(pquery, 511, "SELECT COUNT(*) FROM `%s%s` WHERE ((`player_id` = '%s' AND `ban_type` = 'S') OR (`player_ip` = '%s' AND `ban_type` = 'SI')) AND `expired` = '1';", g_dbPrefix, TBL_BANS, playerData[id][playerSteamid], playerData[id][playerIp])
	
	new data[1]
	data[0] = id

	return SQL_ThreadQuery(g_SqlX, "prebanned_check_", pquery, data, 1)
}

public prebanned_check_(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}
	
	new id = data[0]
	
	new ban_count = SQL_ReadResult(query, 0)
	
	SQL_FreeHandle(query)
	
	if(!get_user_state(id, PDATA_CONNECTED) || ban_count < get_pcvar_num(pcvar_show_prebanned_num))
	{
		return PLUGIN_HANDLED
	}
	
	for(new i = 1; i <= plnum; i++) 
	{
		if(get_user_state(i, PDATA_BOT) || get_user_state(i, PDATA_HLTV) || !get_user_state(i, PDATA_CONNECTED) || i == id)
		{
			continue
		}
		if(get_user_flags(i) & ADMIN_CHAT) 
		{
			ColorChat(i, RED, "%s %L", PREFIX, i, "PLAYER_BANNED_BEFORE", playerData[id][playerName], playerData[id][playerIp], playerData[id][playerSteamid], ban_count)
		}
	}

	return log_amx("[AMXBans] %L", LANG_SERVER, "PLAYER_BANNED_BEFORE", playerData[id][playerName], playerData[id][playerSteamid], ban_count)
}


public check_player(id) 
{
	id -= 203
	
	if(is_user_disconnected(id) || get_user_state(id, PDATA_IMMUNITY))
	{
		return PLUGIN_HANDLED
	}

	new data[1], pquery[1024]

#if defined SET_NAMES_UTF8
	
	formatex(pquery, 1023, "SELECT `bid`, `ban_created`, `ban_length`, `cs_ban_reason`, `admin_nick`, `admin_id`, `admin_ip`, `player_nick`, `player_id`, `player_ip`, `server_name`, `server_ip`, `ban_type` FROM `%s%s` WHERE ((`player_id` = '%s' AND `ban_type` = 'S') OR (`player_ip` = '%s' AND `ban_type` = 'SI')) AND `expired` = '0';", g_dbPrefix, TBL_BANS, playerData[id][playerSteamid], playerData[id][playerIp])
	
#else

	formatex(pquery, 1023, "SELECT `bid`, `ban_created`, `ban_length`, `ban_reason`, `admin_nick`, `admin_id`, `admin_ip`, `player_nick`, `player_id`, `player_ip`, `server_name`, `server_ip`, `ban_type` FROM `%s%s` WHERE ((`player_id` = '%s' AND `ban_type` = 'S') OR (`player_ip` = '%s' AND `ban_type` = 'SI')) AND `expired` = '0';", g_dbPrefix, TBL_BANS, playerData[id][playerSteamid], playerData[id][playerIp])
	
#endif
	
	data[0] = id
	
	return SQL_ThreadQuery(g_SqlX, "check_player_", pquery, data, 1)
}

public check_player_(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}
	
	new id = data[0]
	
	if(!SQL_NumResults(query) || is_user_disconnected(id)) 
	{
		return SQL_FreeHandle(query)
	}
	
	new ban_reason[128], admin_nick[100], admin_steamid[50], admin_ip[30], ban_type[4]
	new player_nick[50], player_steamid[50], player_ip[30], server_name[100], server_ip[30]
	
	new bid = SQL_ReadResult(query, 0)
	new ban_created = SQL_ReadResult(query, 1)
	new ban_length_int = SQL_ReadResult(query, 2) * 60
	SQL_ReadResult(query, 3, ban_reason, 127)
	SQL_ReadResult(query, 4, admin_nick, 99)
	SQL_ReadResult(query, 5, admin_steamid, 49)
	SQL_ReadResult(query, 6, admin_ip, 29)
	SQL_ReadResult(query, 7, player_nick, 49)
	SQL_ReadResult(query, 8, player_steamid, 49)
	SQL_ReadResult(query, 9, player_ip, 29)
	SQL_ReadResult(query, 10, server_name, 99)
	SQL_ReadResult(query, 11, server_ip, 29)
	SQL_ReadResult(query, 12, ban_type, 3)

	SQL_FreeHandle(query)
	
	if(get_pcvar_num(pcvar_debug) >= 1)
	{
		log_amx("[AMXBans] Player Check on Connect:^nbid: %d ^nwhen: %d ^nlenght: %d ^nreason: %s ^nadmin: %s ^nadminsteamID: %s ^nPlayername %s ^nserver: %s ^nserverip: %s ^nbantype: %s",\
		bid, ban_created, ban_length_int, ban_reason, admin_nick, admin_steamid, player_nick, server_name, server_ip, ban_type)
	}

	new current_time_int = get_systime(get_pcvar_num(pcvar_offset))

	if((ban_length_int == 0) || (ban_created == 0) || ((ban_created + ban_length_int) > current_time_int)) 
	{
		new complain_url[256]
		get_pcvar_string(pcvar_complainurl, complain_url, 255)
		
		client_cmd(id, "echo ^"[AMXBans] ===============================================^"")
		
		new show_activity = get_pcvar_num(pcvar_activity)
		
		if(get_user_flags(id) & get_admin_mole_access_flag() || id == 0)
		{
			show_activity = 1
		}
		
		switch(show_activity)
		{
			case 1:
			{
				client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_9")
			}
			case 2:
			{
				client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_8", admin_nick)
			}
			case 3:
			{
				if(is_user_admin(id))
				{
					client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_8", admin_nick)
				}
				else
				{
					client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_9")
				}
			}
			case 4:
			{
				if(is_user_admin(id))
				{
					client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_8", admin_nick)
				}
			}
			case 5:
			{
				if(is_user_admin(id))
				{
					client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_9")
				}
			}
		}

		if(ban_length_int == 0) 
		{
			client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_10")
		} 
		else 
		{
			new cTimeLength[128]
			new iSecondsLeft = (ban_created + ban_length_int - current_time_int)
			get_time_length(id, iSecondsLeft, timeunit_seconds, cTimeLength, 127)
			client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_12", cTimeLength)
		}
		
		replace_all(complain_url, 255, "http://", "")
		
		client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_13", player_nick)
		client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_2", ban_reason)
		client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_7", complain_url)
		client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_4", player_steamid)
		client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_5", player_ip)
		client_cmd(id, "echo ^"[AMXBans] ===============================================^"")

		if(get_pcvar_num(pcvar_debug) >= 1)
		{
			log_amx("[AMXBans] BID:<%d> Player:<%s> <%s> connected and got kicked, because of an active ban", bid, player_nick, player_steamid)
		}

		if(get_pcvar_num(pcvar_debug) >= 1)
		{
			new id_str[3]
			num_to_str(id, id_str, 3)
			log_amx("[AMXBans] Delayed Kick-TASK ID1: <%d>  ID2: <%s>", id, id_str)
		}
		
		add_kick_to_db(bid)
		
		set_task(1.0, "delayed_kick", id + 200)

		return PLUGIN_HANDLED
	} 
	else 
	{
		client_cmd(id, "echo ^"[AMXBans] %L^"", id, "MSG_11")
		
		new pquery[256]
		formatex(pquery, 255, "UPDATE `%s%s` SET `expired` = '1' WHERE `bid` = '%d';", g_dbPrefix, TBL_BANS, bid)

		SQL_ThreadQuery(g_SqlX, "insert_to_banhistory", pquery)
		
		if(get_pcvar_num(pcvar_debug) >= 1)
		{
			log_amx("[AMXBans] PRUNE BAN: %s", pquery)
		}
	}
	
	return PLUGIN_HANDLED
}

public insert_to_banhistory(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}
	
	return SQL_FreeHandle(query)
}

public add_kick_to_db(bid) 
{
	new pquery[256]
	formatex(pquery, 255, "UPDATE `%s%s` SET `ban_kicks` = `ban_kicks` + 1 WHERE `bid` = '%d';", g_dbPrefix, TBL_BANS, bid)

	return SQL_ThreadQuery(g_SqlX, "_add_kick_to_db", pquery)
}

public _add_kick_to_db(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}
	
	return SQL_FreeHandle(query)
}