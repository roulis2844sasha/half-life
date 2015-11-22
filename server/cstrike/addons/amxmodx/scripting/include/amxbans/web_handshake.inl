#if defined _web_handshake_included
    #endinput
#endif
#define _web_handshake_included

#include <amxmodx>

public cmdLst(id, level, cid)
{
	if(id) 
	{
		return PLUGIN_HANDLED
	}
	
	new status, immun, userid
	
	for(new pid = 1; pid <= plnum; pid++)
	{
		if(get_user_state(pid, PDATA_CONNECTED)) 
		{
			userid = get_user_userid(pid)
			
			status = 0
			if(get_user_state(pid, PDATA_BOT))
			{
				status = 1
			}
			if(get_user_state(pid, PDATA_HLTV))
			{
				status = 2
			}
			
			immun = 0
			
			if(get_user_state(pid, PDATA_IMMUNITY))
			{
				immun = 1
			}
			
			console_print(id,"%s%c%d%c%s%c%s%c%d%c%d", playerData[pid][playerName], -4, userid, -4, playerData[pid][playerSteamid], -4, playerData[pid][playerIp], -4, status, -4, immun)
		}
	}
	return PLUGIN_HANDLED
}
