#include <amxmodx>
#include <amxmisc>

#define PLUGIN 		"ADMIN Name"
#define VERSION 	"1.0"
#define AUTHOR 		"DJBosma"

#define ACCESS_LEVEL	ADMIN_LEVEL_C
#define ADMIN_LISTEN	ADMIN_RCON

new message[192]
new sayText
new teamInfo
new maxPlayers

new g_MessageColor
new g_NameColor
new g_AdminListen

new strName[191]
new strText[191]
new alive[11]

public plugin_init()
{
	register_plugin (PLUGIN , VERSION , AUTHOR)
	
	g_MessageColor = register_cvar ("amx_color", "3")

	g_NameColor = register_cvar ("amx_namecolor", "2")
	
	g_AdminListen = register_cvar ("amx_listen", "1")
	
	
	sayText = get_user_msgid ("SayText")
	teamInfo = get_user_msgid ("TeamInfo")
	maxPlayers = get_maxplayers()
	
	
	register_message (sayText, "arubaid_duplicated")
	
	register_clcmd ("amx_color", "set_color", ACCESS_LEVEL, "<color>")
	register_clcmd ("amx_namecolor", "set_name_color", ACCESS_LEVEL, "<color>")
	register_clcmd ("amx_listen", "set_listen", ACCESS_LEVEL, "<1 | 0>")
	
	register_clcmd ("say", "hook_say")
	register_clcmd ("say_team", "hook_teamsay")
}


public arubaid_duplicated (msgId, msgDest, receiver)
{
	return PLUGIN_HANDLED
}


public hook_say(id)
{
	read_args (message, 191)
	remove_quotes (message)
	
	if (message[0] == '@' || message[0] == '/' || message[0] == '!' || equal (message, "")) // Ignores Admin Hud Messages, Admin Slash commands, 

		return PLUGIN_CONTINUE

		
	new name[32]
	get_user_name (id, name, 31)
	
	new bool:admin = false
	
	if (get_user_flags(id) & ACCESS_LEVEL)
		admin = true
		
	
	new isAlive
	
	if (is_user_alive (id))
		{
			isAlive = 1
			alive = "^x01"
		}
	else
		{
			isAlive = 0
			alive = "^x01"
		}
	
	static color[10]
	

	
	if (admin)
		{
			switch (get_pcvar_num (g_NameColor))
				{
					case 1:
						format (strName, 191, "%s^x03[Админ] ^x04%s", alive, name)

					case 2:
						format (strName, 191, "%s^x03[Админ] ^x04%s", alive, name)
						
					case 3:
						{
							color = "SPECTATOR"
							format (strName, 191, "%s^x03[Админ] ^x04%s", alive, name)
						}
						
					case 4:
						{
							color = "CT"
							format (strName, 191, "%s^x03[Админ] ^x04%s", alive, name)
						}

					case 5:
						{
							color = "TERRORIST"
							format (strName, 191, "%s^x03[Админ] ^x04%s", alive, name)
						}
					
					case 6:
						{
							get_user_team (id, color, 9)
								
							format (strName, 191, "%s^x03[Админ] ^x04%s", alive, name)
						}
				}
			
			switch (get_pcvar_num (g_MessageColor))
				{
					case 1:	// Yellow
						format (strText, 191, "%s", message)
						
					case 2:	// Green
						format (strText, 191, "^x04%s", message)
						
					case 3:	// White
						{
							copy (color, 9, "SPECTATOR")
							format (strText, 191, "^x03%s", message)
						}

					case 4:	// Blue
						{
							copy (color, 9, "CT")
							format (strText, 191, "^x03%s", message)
						}
						
					case 5:	// Red
						{
							copy (color, 9, "TERRORIST")
							format (strText, 191, "^x03%s", message)
						}
				}
		}
	
	else
		{
			get_user_team (id, color, 9)
			
			format (strName, 191, "%s^x03%s", alive, name)
			
			format (strText, 191, "%s", message)
		}

	format (message, 191, "%s^x01: %s", strName, strText)
			
	sendMessage (color, isAlive)
	
	return PLUGIN_CONTINUE
}


public hook_teamsay(id)
{
	new playerTeam = get_user_team(id)
	new playerTeamName[19]
	
	switch (playerTeam)
		{
			case 1:
				copy (playerTeamName, 11, "Terrorists")
				
			case 2:
				copy (playerTeamName, 18, "Counter-Terrorists")
				
			default:
				copy (playerTeamName, 9, "Spectator")
		}
		
	read_args (message, 191)
	remove_quotes (message)
	
	if (message[0] == '@' || message[0] == '/' || message[0] == '!' || equal (message, "")) // Ignores Admin Hud Messages, Admin Slash commands, 

		return PLUGIN_CONTINUE

		
	new name[32]
	get_user_name (id, name, 31)
	
	new bool:admin = false
	
	if (get_user_flags(id) & ACCESS_LEVEL)
		admin = true
		
	
	new isAlive
	
	if (is_user_alive (id))
		{
			isAlive = 1
			alive = "^x01"
		}
	else
		{
			isAlive = 0
			alive = "^x01"
		}
	
	static color[10]
	

	
	if (admin)
		{
			switch (get_pcvar_num (g_NameColor))
				{
					case 1:
						format (strName, 191, "%s^x03[Админ] ^x04%s", alive, name)

					case 2:
						format (strName, 191, "%s^x03[Админ] ^x04%s", alive, name)
						
					case 3:
						{
							color = "SPECTATOR"
							format (strName, 191, "%s^x03[Админ] ^x04%s", alive, name)
						}
						
					case 4:
						{
							color = "CT"
							format (strName, 191, "%s^x03[Админ] ^x04%s", alive, name)
						}

					case 5:
						{
							color = "TERRORIST"
							format (strName, 191, "%s^x03[Админ] ^x04%s", alive, name)
						}
					
					case 6:
						{
							get_user_team (id, color, 9)
								
							format (strName, 191, "%s^x03[Админ] ^x04%s", alive, name)
						}
				}
			
			switch (get_pcvar_num (g_MessageColor))
				{
					case 1:	// Yellow
						format (strText, 191, "%s", message)
						
					case 2:	// Green
						format (strText, 191, "^x04%s", message)
						
					case 3:	// White
						{
							copy (color, 9, "SPECTATOR")
							format (strText, 191, "^x03%s", message)
						}

					case 4:	// Blue
						{
							copy (color, 9, "CT")
							format (strText, 191, "^x03%s", message)
						}
						
					case 5:	// Red
						{
							copy (color, 9, "TERRORIST")
							format (strText, 191, "^x03%s", message)
						}
				}
		}
	
	else
		{
			get_user_team (id, color, 9)
			
			format (strName, 191, "%s^x03%s", alive, name)
			
			format (strText, 191, "%s", message)
		}
	
	format (message, 191, "%s^x01: %s", strName, strText)
	
	sendTeamMessage (color, isAlive, playerTeam)
	
	return PLUGIN_CONTINUE	
}


public set_color (id, level, cid)
{
	if (!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED
		
	new arg[1], newColor
	read_argv (1, arg, 1)
	
	newColor = str_to_num (arg)
	
	if (newColor >= 1 && newColor <= 5)
		{
			set_cvar_num ("amx_color", newColor)
			set_pcvar_num (g_MessageColor, newColor)
	
			if (get_pcvar_num (g_NameColor) != 1 &&
			       ((newColor == 3 &&  get_pcvar_num (g_NameColor) != 3)
			     || (newColor == 4 &&  get_pcvar_num (g_NameColor) != 4)
			     || (newColor == 5 &&  get_pcvar_num (g_NameColor) != 5)))
				{
					set_cvar_num ("amx_namecolor", 2)
					set_pcvar_num (g_NameColor, 2)
				}
		}
		
	return PLUGIN_HANDLED
}


public set_name_color (id, level, cid)
{
	if (!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED
		
	new arg[1], newColor
	read_argv (1, arg, 1)
	
	newColor = str_to_num (arg)
	
	if (newColor >= 1 && newColor <= 6)
		{
			set_cvar_num ("amx_namecolor", newColor)
			set_pcvar_num (g_NameColor, newColor)
			
			if ((get_pcvar_num (g_MessageColor) != 1
			    && ((newColor == 3 &&  get_pcvar_num (g_MessageColor) != 3)
			     || (newColor == 4 &&  get_pcvar_num (g_MessageColor) != 4)
			     || (newColor == 5 &&  get_pcvar_num (g_MessageColor) != 5)))
			     || get_pcvar_num (g_NameColor) == 6)
				{
					set_cvar_num ("amx_color", 2)
					set_pcvar_num (g_MessageColor, 2)
				}
		}
	
	return PLUGIN_HANDLED
}


public set_listen (id, level, cid)
{
	if (!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED
		
	new arg[1], newListen
	read_argv(1, arg, 1)
	
	newListen = str_to_num (arg)
	
	set_cvar_num ("amx_listen", newListen)
	set_pcvar_num (g_AdminListen, newListen)
	
	return PLUGIN_HANDLED
}


public sendMessage (color[], alive)
{
	new teamName[10]
	
	for (new player = 1; player < maxPlayers; player++)
		{
			if (!is_user_connected(player))
				continue

			if (alive && is_user_alive(player) || !alive && !is_user_alive(player) || get_pcvar_num(g_AdminListen) && get_user_flags(player) & ADMIN_LISTEN)
				{
					get_user_team (player, teamName, 9)
					
					changeTeamInfo (player, color)
					
					writeMessage (player, message)
					
					changeTeamInfo (player, teamName)
				}
		}
}


public sendTeamMessage (color[], alive, playerTeam)
{
	new teamName[10]
	
	for (new player = 1; player < maxPlayers; player++)
		{
			if (!is_user_connected(player))
				continue

			if (get_user_team(player) == playerTeam || get_pcvar_num(g_AdminListen) && get_user_flags(player) & ADMIN_LISTEN)
				{
					if (alive && is_user_alive(player) || !alive && !is_user_alive(player) || get_pcvar_num(g_AdminListen) && get_user_flags(player) & ADMIN_LISTEN)
						{
							get_user_team (player, teamName, 9)
							
							changeTeamInfo (player, color)
							
							writeMessage (player, message)
							
							changeTeamInfo (player, teamName)
						}
				}
		}
}


public changeTeamInfo (player, team[])
{
	message_begin (MSG_ONE, teamInfo, _, player)
	write_byte (player)
	write_string (team)
	message_end()
}


public writeMessage (player, message[])
{
	message_begin (MSG_ONE, sayText, {0, 0, 0}, player)
	write_byte (player)
	write_string (message)
	message_end ()
}
