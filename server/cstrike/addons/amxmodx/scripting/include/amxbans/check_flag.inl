#if defined _check_flag_included
    #endinput
#endif

#define _check_flag_included

#include <amxmodx>
#include <sqlx>

stock check_player_post(id)
{
	set_task(1.0, "prebanned_check", id + 204)
	
	if(!get_pcvar_num(pcvar_flag))
	{
		return PLUGIN_HANDLED
	}
	
	new pquery[512]
	
	if(get_pcvar_num(pcvar_flagged_all))
	{
		formatex(pquery, 511, "SELECT `fid`, `reason`, `created`, `length` FROM `%s%s` WHERE `player_id` = '%s' OR `player_ip` = '%s' ORDER BY `length` ASC;", g_dbPrefix, TBL_FLAGGED, playerData[id][playerSteamid], playerData[id][playerIp])
	}
	else
	{
		formatex(pquery, 511, "SELECT `fid`, `reason`, `created`, `length` FROM `%s%s` WHERE (`player_id` = '%s' OR `player_ip` = '%s') AND `server_ip` = '%s:%s' ORDER BY `length` ASC;", g_dbPrefix, TBL_FLAGGED, playerData[id][playerSteamid], playerData[id][playerIp], g_ip, g_port)
	}
	
	new data[1]
	data[0] = id
	
	return SQL_ThreadQuery(g_SqlX, "check_player_post_", pquery, data, 1)
}

public check_player_post_(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}
	
	new id = data[0]
	
	if(!SQL_NumResults(query) || !get_user_state(id, PDATA_CONNECTED))
	{
		return SQL_FreeHandle(query)
	}
	
	new length, reason[128], created, fid
	new cur_time = get_systime(get_pcvar_num(pcvar_offset))
	
	while(SQL_MoreResults(query))
	{
		fid = SQL_ReadResult(query, 0)
		SQL_ReadResult(query, 1, reason, 127)
		created = SQL_ReadResult(query, 2)
		length = SQL_ReadResult(query, 3)
		
		if((created + length * 60) > cur_time)
		{
			add_user_state(id, PDATA_FLAGGED)
		}
		else
		{
			remove_flagged(id, fid)
		}
		
		SQL_NextRow(query)
	}
	
	SQL_FreeHandle(query)
	
	if(!get_user_state(id, PDATA_FLAGGED))
	{
		return PLUGIN_HANDLED
	}
	
	playerData[id][playerFlagTime] = length
	copy(playerData[id][playerFlagReason], 127, reason)
	
	new ret

	return ExecuteForward(MFHandle[Player_Flagged], ret, id, ((created + length * 60) - cur_time), playerData[id][playerFlagReason])
}

stock remove_flagged(id, fid)
{
	new pquery[256]
	formatex(pquery, 255, "DELETE FROM `%s%s` WHERE `fid` = '%d';", g_dbPrefix, TBL_FLAGGED, fid)
	
	new data[1]
	data[0] = id
	
	return SQL_ThreadQuery(g_SqlX, "_remove_flagged", pquery, data, 1)
}

public _remove_flagged(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}

	return SQL_FreeHandle(query)
}