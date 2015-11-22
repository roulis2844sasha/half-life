#if defined _color_chat_included
    #endinput
#endif

#define _color_chat_included

#include <amxmodx>

enum Color
{
	YELLOW = 1,
	GREEN,
	TEAM_COLOR,
	GREY,
	RED,
	BLUE
}

new TeamInfo
new SayText
new mplayers

new TeamName[][] = 
{
	"",
	"TERRORIST",
	"CT",
	"SPECTATOR"
}


stock color_chat_init()
{
	TeamInfo = get_user_msgid("TeamInfo")
	SayText = get_user_msgid("SayText")
	mplayers = get_maxplayers()
	
	return PLUGIN_CONTINUE
}

public ColorChat(id, Color:type, const msg[], any:...)
{
	new message[192]
	
	switch(type)
	{
		case YELLOW:
		{
			message[0] = 0x01
		}
		case GREEN:
		{
			message[0] = 0x04
		}
		default:
		{
			message[0] = 0x03
		}
	}
	
	vformat(message[1], 191, msg, 4)
	replace_all(message, 191, "!g", "^x04")
	replace_all(message, 191, "!t", "^x03")
	replace_all(message, 191, "!y", "^x01")
	
	message[191] = '^0'
	new team, ColorChange, index, MSG_Type
	if(!id)
	{
		index = FindPlayer()
		MSG_Type = MSG_ALL
	
	} 
	else 
	{
		MSG_Type = MSG_ONE
		index = id
	}
	
	team = get_user_team(index)
	
	ColorChange = ColorSelection(index, MSG_Type, type)
	ShowColorMessage(index, MSG_Type, message)
	if(ColorChange)
	{
		Team_Info(index, MSG_Type, TeamName[team])
	}
	
	return PLUGIN_CONTINUE
}

stock ShowColorMessage(id, type, const message[])
{
	message_begin(type, SayText, _, id)
	write_byte(id)		
	write_string(message)
	message_end()
	
	return PLUGIN_CONTINUE
}

stock Team_Info(id, type, team[])
{
	message_begin(type, TeamInfo, _, id)
	write_byte(id)
	write_string(team)
	message_end()
	
	return 1
}

stock ColorSelection(index, type, Color:Type)
{
	switch(Type)
	{
		case RED:
		{
			return Team_Info(index, type, TeamName[1])
		}
		case BLUE:
		{
			return Team_Info(index, type, TeamName[2])
		}
		case GREY:
		{
			return Team_Info(index, type, TeamName[0])
		}
	}
	
	return 0
}

stock FindPlayer()
{
	new i = -1
	while(i <= mplayers)
	{
		if(is_user_connected(++i))
		{
			return i
		}
	}
	return -1
}