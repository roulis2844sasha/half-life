#if defined _init_functions_included
    #endinput
#endif

#define _init_functions_included

#include <amxmodx>
#include <amxmisc>
#include <sqlx>
#include <time>

public banmod_online()
{
	new ip_port[32]
	get_pcvar_string(pcvar_serverip, ip_port, 31)
	if(contain(ip_port, ":") == -1) 
	{
		get_user_ip(0, ip_port, 31)
	}
	strtok(ip_port, g_ip, 31, g_port, 9, ':')

	if(get_pcvar_num(pcvar_debug) >= 1)
	{
		log_amx("[AMXBans] The server IP:PORT is: %s:%s", g_ip, g_port)
	}
	
	new pquery[256]
	formatex(pquery, 255, "SELECT `motd_delay` FROM `%s%s` WHERE address = '%s:%s';", g_dbPrefix, TBL_SERVERINFO, g_ip, g_port)

	return SQL_ThreadQuery(g_SqlX, "banmod_online_", pquery)
}

public banmod_online_(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}

	new servername[100]
	mysql_get_servername_safe(servername, 99)
	
	new modname[32]
	get_modname(modname, 31)
	
	new pquery[1024]
	
	if(!SQL_NumResults(query)) 
	{
		if(get_pcvar_num(pcvar_debug) >= 1) 
		{
			log_amx("[AMXBans] INSERT INTO `%s%s` VALUES ('', '', '%s', '%s:%s', '%s', '', '%s', '', '', '0')", g_dbPrefix, TBL_SERVERINFO, servername, g_ip, g_port, modname, AMXBANS_VERSION)
		}
		
#if defined SET_NAMES_UTF8		
		
		formatex(pquery, 1023, "SET NAMES UTF8; INSERT INTO `%s%s` (`timestamp`, `hostname`, `address`, `gametype`, `amxban_version`, `amxban_menu`) VALUES \
			(UNIX_TIMESTAMP(NOW()), '%s', '%s:%s', '%s', '%s', '1');", g_dbPrefix, TBL_SERVERINFO, servername, g_ip, g_port, modname, AMXBANS_VERSION)
			
#else

		formatex(pquery, 1023, "INSERT INTO `%s%s` (`timestamp`, `hostname`, `address`, `gametype`, `amxban_version`, `amxban_menu`) VALUES \
			(UNIX_TIMESTAMP(NOW()), '%s', '%s:%s', '%s', '%s', '1');", g_dbPrefix, TBL_SERVERINFO, servername, g_ip, g_port, modname, AMXBANS_VERSION)

#endif		
	
	} 
	else 
	{
		new kick_delay_str[10]
		SQL_ReadResult(query, 0, kick_delay_str, 9)

		if(floatstr(kick_delay_str) > 2.0) 
		{
			kick_delay = floatstr(kick_delay_str)
		} 
		else 
		{
			kick_delay = 10.0
		}

		if(get_pcvar_num(pcvar_debug) >= 1) 
		{
			log_amx("[AMXBANS DEBUG] UPDATE `%s%s` SET `timestamp` = '', `hostname` = '%s', `gametype` = '%s', `amxban_version` = '%s', `amxban_menu` = '1' WHERE `address` = '%s:%s'", g_dbPrefix, TBL_SERVERINFO, servername, modname, AMXBANS_VERSION, g_ip, g_port)
		}

#if defined SET_NAMES_UTF8		
		
		formatex(pquery, 1023, "SET NAMES UTF8; UPDATE `%s%s` SET `timestamp` = UNIX_TIMESTAMP(NOW()), `hostname` = '%s', `gametype` = '%s', `amxban_version` = '%s', `amxban_menu` = '1' WHERE `address` = '%s:%s';", g_dbPrefix, TBL_SERVERINFO, servername, modname, AMXBANS_VERSION, g_ip, g_port)
		
#else

		formatex(pquery, 1023, "UPDATE `%s%s` SET `timestamp` = UNIX_TIMESTAMP(NOW()), `hostname` = '%s', `gametype` = '%s', `amxban_version` = '%s', `amxban_menu` = '1' WHERE `address` = '%s:%s';", g_dbPrefix, TBL_SERVERINFO, servername, modname, AMXBANS_VERSION, g_ip, g_port)

#endif		
		
	}
	
	SQL_FreeHandle(query)	
	
	SQL_ThreadQuery(g_SqlX, "banmod_online_update", pquery)
	
	return log_amx("[AMXBans] %L", LANG_SERVER, "SQL_BANMOD_ONLINE", VERSION, DATE)
}

public banmod_online_update(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}
	
	return SQL_FreeHandle(query)
}

public cmdFetchReasons(id, level, cid) 
{
	if(!cmd_access(id, level, cid, 1))
	{
		return PLUGIN_HANDLED
	}
	
	return load_reasons()
}

public load_reasons()
{

#if defined SET_NAMES_UTF8

	new error[128], errno
	new Handle:sql = SQL_Connect(g_SqlX, errno, error, 127)
	
	if(sql == Empty_Handle)
	{
		return server_print("[AMXBans] %L", LANG_SERVER, "SQL_CANT_CON", error)
	}
	
	SQL_QueryAndIgnore(sql, "SET NAMES UTF8;")
	
#endif	
	
	ArrayClear(g_banReasons)
	ArrayClear(g_banReasons_Bantime)
	
	new pquery[1024]
	formatex(pquery, 1023, "SELECT `re`.`reason`, `re`.`static_bantime` FROM `%s%s` AS `re`, `%s%s` AS `rs`, `%s%s` AS `si` \
				WHERE `si`.`address` = '%s:%s' AND `si`.`reasons` = `rs`.`setid` AND `rs`.`reasonid` = `re`.`id` \
				ORDER BY `re`.`id`;", g_dbPrefix, TBL_REASONS, g_dbPrefix, TBL_REASONSSET, g_dbPrefix, TBL_SERVERINFO, g_ip, g_port)
				
#if defined SET_NAMES_UTF8				
				
	new Handle:query = SQL_PrepareQuery(sql, pquery)
	
	if(!SQL_Execute(query))
	{
		new error[512]
		new errornum = SQL_QueryError(query, error, 511)
		
		return SQL_Error(query, error, errornum, TQUERY_QUERY_FAILED)
	}

#else

	return SQL_ThreadQuery(g_SqlX, "load_resasons_post", pquery)
}

public load_resasons_post(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}
	
#endif	
	
	new aNum
	
	if(!SQL_NumResults(query)) 
	{
		SQL_FreeHandle(query)
		
		server_print("[AMXBans] %L", LANG_SERVER, "NO_REASONS")
		new temp[128]
		formatex(temp, 127, "%L", LANG_SERVER, "REASON_1")
		ArrayPushReasons(temp, 0)
		formatex(temp, 127, "%L", LANG_SERVER, "REASON_2")
		ArrayPushReasons(temp, 0)
		formatex(temp, 127, "%L", LANG_SERVER, "REASON_3")
		ArrayPushReasons(temp, 0)
		formatex(temp, 127, "%L", LANG_SERVER, "REASON_4")
		ArrayPushReasons(temp, 0)
		formatex(temp, 127, "%L", LANG_SERVER, "REASON_5")
		ArrayPushReasons(temp, 0)
		formatex(temp, 127, "%L", LANG_SERVER, "REASON_6")
		ArrayPushReasons(temp, 0)
		formatex(temp, 127, "%L", LANG_SERVER, "REASON_7")
		ArrayPushReasons(temp, 0)
	
		log_amx("[AMXBans] %L", LANG_SERVER, "SQL_LOADED_STATIC_REASONS")

		aNum = 7

		return PLUGIN_HANDLED
	} 
	else 
	{
		new reason[128]
		new reason_time
		while(SQL_MoreResults(query)) 
		{
			SQL_ReadResult(query, 0, reason, 127)
			reason_time = SQL_ReadResult(query, 1)
			ArrayPushReasons(reason, reason_time)
			SQL_NextRow(query)
			aNum++
		}
	}
	
	SQL_FreeHandle(query)

#if defined SET_NAMES_UTF8	
	
	SQL_FreeHandle(sql)
	
#endif	
	
	if(aNum == 1)
	{
		server_print("[AMXBans] %L", LANG_SERVER, "SQL_LOADED_REASON")
	}
	else
	{
		server_print("[AMXBans] %L", LANG_SERVER, "SQL_LOADED_REASONS", aNum)
	}
	
	return PLUGIN_HANDLED
	
}

stock ArrayPushReasons(const reason[], bantime) 
{
	ArrayPushString(g_banReasons, reason)
	ArrayPushCell(g_banReasons_Bantime, bantime)
	return 1
}

public get_offset()
{
	new pquery[256]
	formatex(pquery, 255, "SELECT (SELECT UNIX_TIMESTAMP(NOW()) - '%d') AS `offset`;", get_systime(0))
	
	return SQL_ThreadQuery(g_SqlX, "get_offset_post", pquery)
}

public get_offset_post(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}

	set_pcvar_num(pcvar_offset, SQL_ReadResult(query, 0))
	
	return SQL_FreeHandle(query)
}