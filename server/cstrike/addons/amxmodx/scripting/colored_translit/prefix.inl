/*
* 	Colored Translit v3.0 by Sho0ter
*/
public ct_message_format(id)
{
	new szName[32], pos[2][127], szPr[32], szSteamID[64];
	get_user_name(id, szName, 31);
	get_user_authid(id, szSteamID, 63);
	for(new i; i < iLinesPrefix; i++)
	{
		parse(szStringFilePrefix[i], pos[0], 126, pos[1], 126);
		format(szPr, 31, "[^x04%s^x01]", pos[1]);
		if(equali(szName, pos[0]) || equali(szSteamID, pos[0]))
		{
			ct_add_to_msg(CT_MSGPOS_PREFIX, szPr)
		}
	}
}