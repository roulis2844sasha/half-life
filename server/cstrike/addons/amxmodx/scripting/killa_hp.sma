/* AMX Mod X Script
*
*	"Killa HP"
*	(c) jas0n, november 2007 
*
*	This file is provided as is (no warranties)	
*
*Перевод на русский выполнен (translated into russian by) Reg0 (icq: 7798098)
*		
*/

#include <amxmodx>
#include <cstrike>

new const PLUGIN[] = "Killa HP"
new const VERSION[] = "1.0"
new const AUTHOR[] = "jas0n"

#define MAX_MSG_LENGTH 255
#define MAX_NAME_LENGTH 32

new const g_msgTemplate[] = "^x04Вас убил ^x03%s ^x01, у него осталось ^x04%d^x01 HP и ^x04%d^x01 AP"

new g_msgSayText

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_event("DeathMsg", "eventDeath", "a", "1>0")
	g_msgSayText = get_user_msgid("SayText")
}

public eventDeath()
{
	static aID, vID, vTeam
	static aName[MAX_NAME_LENGTH+1]
	static msgText[MAX_MSG_LENGTH+1]
	static aHealth, aArmor, aFrags
	static CsArmorType:ArmorType
	
	aID = read_data(1)
	vID = read_data(2)
	
	vTeam = get_user_team(vID)
	if (vTeam < 1 || vTeam > 2)
	{
		return
	}
	
	if (!is_user_connected(vID) || is_user_alive(vID) || vID == aID)
	{
		return
	}
	
	get_user_name(aID, aName, MAX_NAME_LENGTH)
	aHealth = get_user_health(aID)
	aArmor = cs_get_user_armor(aID, ArmorType)
	aFrags = get_user_frags(aID)
		
	formatex(msgText, MAX_MSG_LENGTH, g_msgTemplate, aName, aHealth, aArmor, aFrags)
	
	msgSayText(vID, msgText)
}

msgSayText(id, message[])
{
	message_begin(MSG_ONE, g_msgSayText, _, id)
	write_byte(id)		
	write_string(message)
	message_end()
}
