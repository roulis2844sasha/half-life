#include <amxmodx>
#include <amxmisc>

#define PLUGIN "Colored Translit Config"
#define VERSION "3.0"
#define AUTHOR "Sho0ter"

#define INTCVARS 29
#define ACCESS_LEVEL ADMIN_RCON

#define CT_TRANSLIT 0
#define CT_LOG 1
#define CT_ADMIN_PREFIX 2
#define CT_NAME_COLOR 3
#define CT_CHAT_COLOR 4
#define CT_ALLCHAT 5
#define CT_LISTEN 6
#define CT_SOUNDS 7
#define CT_COUNTRY 8
#define CT_SWEAR 9
#define CT_SWEAR_WARNS 10
#define CT_SWEAR_IMMUN 11
#define CT_SWEAR_GAG 12
#define CT_SWEAR_GAG_TIME 13
#define CT_AUTO_RUS 14
#define CT_SHOW_INFO 15
#define CT_IGNORE 16
#define CT_IGNORE_MODE 17
#define CT_GAG_IMMUN 18
#define CT_FLOOD 19
#define CT_SPAM 20
#define CT_SPAM_IMMUN 21
#define CT_SPAM_WARNS 22
#define CT_SPAM_ACTION 23
#define CT_SPAM_TIME 24
#define CT_CHEAT 25
#define CT_CHEAT_IMMUN 26
#define CT_CHEAT_ACTION 27
#define CT_CHEAT_TIME 28

new sCvars[INTCVARS][] =
{
	"amx_translit",
	"amx_translit_log", 
	"amx_admin_prefix", 
	"amx_name_color", 
	"amx_chat_color",
	"amx_allchat",
	"amx_listen",
	"amx_ctsounds",
	"amx_country_chat",
	"amx_swear_filter",
	"amx_swear_warns",
	"amx_swear_immunity",
	"amx_swear_gag",
	"amx_swear_gag_time",
	"amx_auto_rus",
	"amx_show_info",
	"amx_ignore",
	"amx_ignore_mode", 
	"amx_gag_immunity",
	"amx_flood_time",
	"amx_spam_filter",
	"amx_spam_immunity",
	"amx_spam_warns",
	"amx_spam_action",
	"amx_spam_time",
	"amx_cheat_filter",
	"amx_cheat_immunity",
	"amx_cheat_action",
	"amx_cheat_time"
}

new cOnOff[2][] =
{
	"CT_OFF",
	"CT_ON"
}

new cChatColors[7][] =
{
	"",
	"CT_COLOR_YELLOW",
	"CT_COLOR_GREEN",
	"CT_COLOR_GRAY",
	"CT_COLOR_BLUE",
	"CT_COLOR_RED",
	"CT_COLOR_TEAM"
}

new cAllChat[3][] =
{
	"CT_OFF",
	"CT_ON",
	"CT_ALLCHAT_ADMIN"
}

new cCountry[4][] =
{
	"CT_OFF",
	"CT_COUNTRY_FULL",
	"CT_COUNTRY_2",
	"CT_COUNTRY_3"
}

new cAutoRus[3][] =
{
	"CT_OFF",
	"CT_AUTO_RUS_CONNECT",
	"CT_AUTO_RUS_ALWAYS"
}

new cIgnoreMode[4][] =
{
	"",
	"CT_IGNORE_NO_TRANSLIT",
	"CT_IGNORE_HIDE",
	"CT_IGNORE_STATSX_SHELL"
}

new cSpamAction[7][] =
{
	"CT_OFF",
	"CT_SPAM_KICK",
	"CT_SPAM_GAG",
	"CT_SPAM_BAN_STEAMID",
	"CT_SPAM_BAN_IP",
	"CT_SPAM_BAN_STEAMID_AMXBANS",
	"CT_SPAM_BAN_IP_AMXBANS"
}

new cCheatAction[7][] =
{
	"CT_OFF",
	"CT_CHEAT_KICK",
	"CT_CHEAT_BAN_STEAMID",
	"CT_CHEAT_BAN_IP",
	"CT_CHEAT_BAN_STEAMID_AMXBANS",
	"CT_CHEAT_BAN_IP_AMXBANS",
	"CT_CHEAT_CUSTOM"
}

new iLines[INTCVARS]
new iCvars[INTCVARS]

new Edited[33]
new Position[33]


public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_dictionary("colored_translit_config.txt")
	register_menucmd(register_menuid("Config Menu"), 1023, "action_configs_menu")
	register_concmd("colored_translit_config", "cmd_admin_menu", ACCESS_LEVEL)
	cache_lines()
	read_cvars()
	add_menu()
	return PLUGIN_CONTINUE
}

public add_menu()
{
	new mName[128]
	format(mName, charsmax(mName), "%L", LANG_SERVER, "CT_MENU_TITLE")
	AddMenuItem(mName, "colored_translit_config", ADMIN_RCON, PLUGIN)
}

public write_cvars(id)
{
	new cFile[128], sLine[32]
	get_configsdir(cFile, charsmax(cFile))
	format(cFile, charsmax(cFile), "%s/colored_translit/config.cfg", cFile)
	for(new i; i < INTCVARS-1; i++)
	{
		format(sLine, charsmax(sLine), "%s ^"%d^"", sCvars[i], iCvars[i])
		write_file(cFile, sLine, iLines[i])
	}
	server_cmd("exec %s", cFile)
	server_exec()
	client_print(id, print_chat, "[%s] %L", PLUGIN, id, "CT_SAVED")
	return PLUGIN_CONTINUE
}

public read_cvars()
{
	for(new i; i < INTCVARS; i++)
	{
		iCvars[i] = get_cvar_num(sCvars[i])
	}
	return PLUGIN_CONTINUE
}

public cache_lines()
{
	new cFile[128]
	get_configsdir(cFile, charsmax(cFile))
	format(cFile, charsmax(cFile), "%s/colored_translit/config.cfg", cFile)
	if(!file_exists(cFile))
	{
		new errMsg[128]
		format(errMsg, charsmax(errMsg), "Config file <%s> not found!", cFile)
		set_fail_state(errMsg)
		return PLUGIN_HANDLED
	}
	new Buffer[512], Len, Cached
	new AllLines =  file_size(cFile, 1)
	while(Cached < INTCVARS-1)
	{
		for(new i; i <= AllLines; i++)
		{
			read_file(cFile, i, Buffer, charsmax(Buffer), Len)
			if(Buffer[0] == ';' || Buffer[0] == '/' || !strlen(Buffer))
			{
				continue
			}
			if(containi(Buffer, sCvars[Cached]) == 0)
			{
				iLines[Cached] = i
				Cached++
				i = AllLines
			}
		}
	}
	return PLUGIN_CONTINUE
}

public cmd_admin_menu(id, level, cid)
{
	if(!access(id, level))
	{
		return PLUGIN_HANDLED
	}
	show_configs_menu(id, Position[id] = 1, 1)
	return PLUGIN_CONTINUE
}

public show_configs_menu(id, position, firstopen)
{
	if(firstopen)
	{
		read_cvars()
		Edited[id] = 0
	}
	new Len, MenuBody[1024]
	new Keys = MENU_KEY_0
	Len = format(MenuBody, charsmax(MenuBody), "\y%L\R\r%d/5^n^n", id, "CT_MENU_TITLE", position)
	switch(position)
	{
		case 1:
		{
			Keys |= (1 << 0)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r1. \w%L\R\y%L^n", id, "CT_MENU_TRANSLIT", id, cOnOff[iCvars[CT_TRANSLIT]])
			Keys |= (1 << 1)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r2. \w%L\R\y%L^n", id, "CT_MENU_LOG", id, cOnOff[iCvars[CT_LOG]])
			Keys |= (1 << 2)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r3. \w%L\R\y%L^n", id, "CT_MENU_ADMIN_PREFIX", id, cOnOff[iCvars[CT_ADMIN_PREFIX]])
			Keys |= (1 << 3)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r4. \w%L\R\y%L^n", id, "CT_MENU_NAME_COLOR", id, cChatColors[iCvars[CT_NAME_COLOR]])
			Keys |= (1 << 4)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r5. \w%L\R\y%L^n", id, "CT_MENU_CHAT_COLOR", id, cChatColors[iCvars[CT_CHAT_COLOR]])
			Keys |= (1 << 5)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r6. \w%L\R\y%L^n", id, "CT_MENU_ALLCHAT", id, cAllChat[iCvars[CT_ALLCHAT]])
		}
		case 2:
		{
			Keys |= (1 << 0)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r1. \w%L\R\y%L^n", id, "CT_MENU_LISTEN", id, cOnOff[iCvars[CT_LISTEN]])
			Keys |= (1 << 1)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r2. \w%L\R\y%L^n", id, "CT_MENU_SOUNDS", id, cOnOff[iCvars[CT_SOUNDS]])
			Keys |= (1 << 2)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r3. \w%L\R\y%L^n", id, "CT_MENU_COUNTRY", id, cCountry[iCvars[CT_COUNTRY]])
			Keys |= (1 << 3)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r4. \w%L\R\y%L^n", id, "CT_MENU_SWEAR", id, cOnOff[iCvars[CT_SWEAR]])
			Keys |= (1 << 4)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r5. \w%L\R\y%d^n", id, "CT_MENU_SWEAR_WARNS", iCvars[CT_SWEAR_WARNS])
			Keys |= (1 << 5)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r6. \w%L\R\y%L^n", id, "CT_MENU_SWEAR_IMMUN", id, cOnOff[iCvars[CT_SWEAR_IMMUN]])
		}
		case 3:
		{
			Keys |= (1 << 0)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r1. \w%L\R\y%L^n", id, "CT_MENU_SWEAR_GAG", id, cOnOff[iCvars[CT_SWEAR_GAG]])
			Keys |= (1 << 1)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r2. \w%L\R\y%d %L^n", id, "CT_MENU_SWEAR_GAG_TIME", iCvars[CT_SWEAR_GAG_TIME], id, "CT_MIN")
			Keys |= (1 << 2)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r3. \w%L\R\y%L^n", id, "CT_MENU_AUTO_RUS", id, cAutoRus[iCvars[CT_AUTO_RUS]])
			Keys |= (1 << 3)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r4. \w%L\R\y%L^n", id, "CT_MENU_SHOW_INFO", id, cOnOff[iCvars[CT_SHOW_INFO]])
			Keys |= (1 << 4)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r5. \w%L\R\y%L^n", id, "CT_MENU_IGNORE", id, cOnOff[iCvars[CT_IGNORE]])
			Keys |= (1 << 5)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r6. \w%L\R\y%L^n", id, "CT_MENU_IGNORE_MODE", id, cIgnoreMode[iCvars[CT_IGNORE_MODE]])
		}
		case 4:
		{
			Keys |= (1 << 0)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r1. \w%L\R\y%L^n", id, "CT_MENU_GAG_IMMUN", id, cOnOff[iCvars[CT_GAG_IMMUN]])
			Keys |= (1 << 1)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r2. \w%L\R\y%d %L^n", id, "CT_MENU_FLOOD", iCvars[CT_FLOOD], id, "CT_SEC")
			Keys |= (1 << 2)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r3. \w%L\R\y%L^n", id, "CT_MENU_SPAM", id, cOnOff[iCvars[CT_SPAM]])
			Keys |= (1 << 3)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r4. \w%L\R\y%L^n", id, "CT_MENU_SPAM_IMMUN", id, cOnOff[iCvars[CT_SPAM_IMMUN]])
			Keys |= (1 << 4)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r5. \w%L\R\y%d^n", id, "CT_MENU_SPAM_WARNS", iCvars[CT_SPAM_WARNS])
			Keys |= (1 << 5)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r6. \w%L\R\y%L^n", id, "CT_MENU_SPAM_ACTION", id, cSpamAction[iCvars[CT_SPAM_ACTION]])
		}
		case 5:
		{
			Keys |= (1 << 0)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r1. \w%L\R\y%d %L^n", id, "CT_MENU_SPAM_TIME", iCvars[CT_SPAM_TIME], id, "CT_MIN")
			Keys |= (1 << 1)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r2. \w%L\R\y%L^n", id, "CT_MENU_CHEAT", id, cOnOff[iCvars[CT_CHEAT]])
			Keys |= (1 << 2)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r3. \w%L\R\y%L^n", id, "CT_MENU_CHEAT_IMMUN", id, cOnOff[iCvars[CT_CHEAT_IMMUN]])
			Keys |= (1 << 3)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r4. \w%L\R\y%L^n", id, "CT_MENU_CHEAT_ACTION", id, cCheatAction[iCvars[CT_CHEAT_ACTION]])
			Keys |= (1 << 4)
			Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r5. \w%L\R\y%d %L^n", id, "CT_MENU_CHEAT_TIME", iCvars[CT_CHEAT_TIME], id, "CT_MIN")
		}
	}
	Keys |= (1 << 6)
	Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "^n\r7. \w%L^n", id, "CT_MENU_CLEAR")
	if(Edited[id])
	{
		Keys |= (1 << 7)
		Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r8. \w%L \r*^n^n", id, "CT_MENU_SAVE")
	}
	else
	{
		Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r8. \d%L^n^n", id, "CT_MENU_SAVE")
	}
	if(position != 5)
	{
		Keys |= (1 << 8)
		Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r9. \w%L^n", id, "CT_MENU_MORE")
	}
	else
	{
		Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r9. \d%L^n", id, "CT_MENU_MORE")
	}
	if(position != 1)
	{
		Keys |= (1 << 9)
		Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r0. \w%L^n^n\y%s v%s by %s", id, "CT_MENU_BACK", PLUGIN, VERSION, AUTHOR)
	}
	else
	{
		Keys |= (1 << 9)
		Len += format(MenuBody[Len], charsmax(MenuBody) - Len, "\r0. \w%L^n^n\y%s v%s by %s", id, "CT_MENU_EXIT", PLUGIN, VERSION, AUTHOR)
	}
	show_menu(id, Keys, MenuBody, -1, "Config Menu")
}

public action_configs_menu(id, key)
{
	switch(key)
	{
		case 6:
		{
			show_configs_menu(id, Position[id], 1)
			return PLUGIN_HANDLED
		}
		case 7:
		{
			if(Edited[id])
			{
				write_cvars(id)
			}
			Edited[id] = 0
			show_configs_menu(id, Position[id], 0)
			return PLUGIN_HANDLED
		}
		case 8:
		{
			if(Position[id] != 5)
			{
				Position[id]++
				show_configs_menu(id, Position[id], 0)
			}
			return PLUGIN_HANDLED
		}
		case 9:
		{
			if(Position[id] == 1)
			{
				return PLUGIN_HANDLED
			}
			Position[id]--
			show_configs_menu(id, Position[id], 0)
			return PLUGIN_HANDLED
		}
		default:
		{
			new Choosed
			if(Position[id] == 1)
			{
				Choosed = Position[id] * key
			}
			else
			{
				Choosed = (Position[id] - 1) * 6 + key
			}
			iCvars[Choosed]++
			if(Choosed == CT_NAME_COLOR || Choosed == CT_CHAT_COLOR)
			{
				if(iCvars[Choosed] >= 7) 
				{
					iCvars[Choosed] = 1
				}
			}
			else if(Choosed == CT_ALLCHAT || Choosed == CT_AUTO_RUS)
			{
				if(iCvars[Choosed] >= 3)
				{
					iCvars[Choosed] = 0
				}
			}
			else if(Choosed == CT_COUNTRY)
			{
				if(iCvars[Choosed] >= 4)
				{
					iCvars[Choosed] = 0
				}
			}
			else if(Choosed == CT_SWEAR_WARNS || Choosed == CT_SPAM_WARNS || Choosed == CT_SWEAR_GAG_TIME || Choosed == CT_FLOOD)
			{
				if(iCvars[Choosed] >= 31)
				{
					iCvars[Choosed] = 0
				}
			}
			else if(Choosed == CT_CHEAT_TIME || Choosed == CT_SPAM_TIME)
			{
				if(iCvars[Choosed] < 30)
				{
					iCvars[Choosed] += 4
				}
				else if(30 <= iCvars[Choosed] < 240)
				{
					iCvars[Choosed] += 29
				}
				else if(240 <= iCvars[Choosed] < 1440)
				{
					iCvars[Choosed] += 59
				}
				else if(1440 <= iCvars[Choosed] < 10080)
				{
					iCvars[Choosed] += 1439
				}
				else if(10080 <= iCvars[Choosed] < 50000)
				{
					iCvars[Choosed] += 10079
				}
				else 
				{
					iCvars[Choosed] = 0
				}
			}
			else if(Choosed == CT_IGNORE_MODE)
			{
				if(iCvars[Choosed] >= 4)
				{
					iCvars[Choosed] = 1
				}
			}
			else if(Choosed == CT_SPAM_ACTION || Choosed == CT_CHEAT_ACTION)
			{
				if(iCvars[Choosed] >= 7)
				{
					iCvars[Choosed] = 0
				}
			}
			else if(iCvars[Choosed] >= 2)
			{
				iCvars[Choosed] = 0
			}
			Edited[id] = 1
			show_configs_menu(id, Position[id], 0)
		}
	}
	return PLUGIN_HANDLED
}