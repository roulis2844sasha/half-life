#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <csstats>
#include <fakemeta>
#include <fun>

//#define STATUS_VALUE // Показывать звание игрока при наведении прицела (Выключено по умолчанию)
#define PREFIX  // Включить префиксы Админа и Випа (Включено по умолчанию, закомментируйте если хотите выключить)
#define HUD_UPD 10.0  // Через сколько секунд обновлять информер (по умолчанию стоит 10 секунд), если значение меньше, то соответственно нагрузка больше

#if defined PREFIX
#define ADMIN_PREFIX ADMIN_BAN   // Флаг для префикса админа (по умолчанию флаг d)
#define VIP_PREFIX ADMIN_LEVEL_H   // Флаг для префикса випа (по умолчанию флаг t)
#endif

new szMessage[191]
new iPlayerRus[33], iPlayerRusInfo[33]

#define PLUGIN "Lite Rank System"
#define VERSION "2.2b"
#define AUTHOR "xoymiii"

#define TASKID_INFO 7777

new round_count
new PlayerXP[33], PlayerLevel[33], g_MsgHud, levelUp[33]
#if defined STATUS_VALUE
new g_MsgHud2
#endif
new g_XPvalue, g_XPheadshot, g_Bomb, g_XPc4def, g_XPc4pl, g_MinPlayers
new g_Levels, bonus, g_Smoke, g_Flash, g_He, g_Armor, g_Bonus_Smoke, g_Bonus_Flash, g_Bonus_Flash2, g_Bonus_He, g_Bonus_Armor, g_Money, g_Bonus_Money, g_Lvl_Money, g_Block_Map
new Array:g_array_block_bonus
new bool:bonus_blocked
new LEVELS[31]
new const CLASSES[][] = { "I_1", "I_1", "I_2", "I_3", "I_4", "I_5", "I_6", "I_7", "I_8", "I_9", "I_10", "I_11", "I_12", "I_13", "I_14", "I_15", "I_16", "I_17", "I_18", "I_19", "I_20", "I_21", "I_22", "I_23", "I_24", "I_25", "I_26", "I_27", "I_28", "I_29", "I_30" }
new const eng[][]={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","{","}",":",'"',"<",">","~","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","[","]",";","'",",",".","`","?","/","@","$","^^","&"}
new const rus[][]={"Ф","И","С","В","У","А","П","Р","Ш","О","Л","Д","Ь","Т","Щ","З","Й","К","Ы","Е","Г","М","Ц","Ч","Н","Я","Х","Ъ","ж","Э","Б","Ю","Ё","ф","и","с","в","у","а","п","р","ш","о","л","д","ь","т","щ","з","й","к","ы","е","г","м","ц","ч","н","я","х","ъ","ж","э","б","ю","ё",",",".","'",";", ":","?"}	
enum _:CVARS {g1,g2,g3,g4,g5,g6,g7,g8,g9,g10,g11,g12,g13,g14,g15,g16,g17,g18,g19,g20}
new pcv[CVARS]
new g_oldrank[33], maxrank
                       
public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR)	
	register_dictionary("Lite_Rank_System.txt" )
	
	register_event("DeathMsg", "EventDeath", "a", "1>0")
	register_event("HLTV", "RoundStart", "a", "1=0", "2=0")
	register_event("TextMsg","RoundRestart","a","2&#Game_w")

	set_task(HUD_UPD, "Info", TASKID_INFO, "", 0, "b")
	
	g_MsgHud = CreateHudSyncObj()
	#if defined STATUS_VALUE
	register_event("StatusValue", "StatusValueShow", "be", "1=2", "2!0")
	register_event("StatusValue", "StatusValueHide", "be", "1=1", "2=0")
	g_MsgHud2 = CreateHudSyncObj()
	#endif
	
	g_array_block_bonus = ArrayCreate(32, 1)
	
	g_XPvalue = register_cvar("lrs_xp_value", "1")
	g_Bomb = register_cvar("lrs_bomb", "1")
	g_MinPlayers = register_cvar("lrs_min_players", "3")
	g_XPc4def = register_cvar("lrs_xp_c4def", "3")
	g_XPc4pl = register_cvar("lrs_xp_c4pl", "3")
	g_XPheadshot = register_cvar("lrs_xp_hs", "1")
	g_Levels = register_cvar("lrs_levels", "0 10 20 30 50 100 150 200 250 300 350 400 500 600 700 800 1000 1200 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000")
	bonus = register_cvar("lrs_bonus", "1")
	g_Block_Map = register_cvar("lrs_block_map", "1")
	g_Smoke = register_cvar("lrs_smoke", "1")
	g_Flash = register_cvar("lrs_flash", "1")
	g_He = register_cvar("lrs_he", "1")
	g_Armor = register_cvar("lrs_armor", "1")
	g_Money = register_cvar("lrs_money", "1")
	g_Bonus_Smoke = register_cvar("lrs_b_smoke", "10")
	g_Bonus_Flash = register_cvar("lrs_b_flash", "15")
	g_Bonus_Flash2 = register_cvar("lrs_b_flash2", "17")
	g_Bonus_He = register_cvar("lrs_b_he", "20")
	g_Bonus_Armor = register_cvar("lrs_b_armor", "22")
	g_Lvl_Money = register_cvar("lrs_lvl_money", "25")
	g_Bonus_Money = register_cvar("lrs_b_money", "1000")
	register_concmd("lrs_lockmap", "MapConst", ADMIN_RCON, "Lock Map. <map>")
	
	new const szRegisterClmd[][] =
	{
		"say /rus",	"LangRus",
		"say /eng",	"LangEng",
		"say",		"Say",
		"say_team",	"SayTeam"
	}
	for(new a; a < sizeof szRegisterClmd; a += 2)
		register_clcmd(szRegisterClmd[a],szRegisterClmd[a + 1])
}

public plugin_cfg()
{
	new configsDir[64]
	get_localinfo("amxx_configsdir", configsDir, 63)
	server_cmd("exec %s/Lite_Rank_System.cfg", configsDir)
	
	pcv[g1] = get_pcvar_num(g_XPvalue)
	pcv[g2] = get_pcvar_num(g_Bomb)
	pcv[g3] = get_pcvar_num(g_MinPlayers)
	pcv[g4] = get_pcvar_num(g_XPc4def)
	pcv[g5] = get_pcvar_num(g_XPc4pl)
	pcv[g6] = get_pcvar_num(g_XPheadshot)
	pcv[g7] = get_pcvar_num(bonus)
	pcv[g8] = get_pcvar_num(g_Block_Map)
	pcv[g9] = get_pcvar_num(g_Smoke)
	pcv[g10] = get_pcvar_num(g_Flash)
	pcv[g11] = get_pcvar_num(g_He)
	pcv[g12] = get_pcvar_num(g_Armor)
	pcv[g13] = get_pcvar_num(g_Money)
	pcv[g14] = get_pcvar_num(g_Bonus_Smoke)
	pcv[g15] = get_pcvar_num(g_Bonus_Flash)
	pcv[g16] = get_pcvar_num(g_Bonus_Flash2)
	pcv[g17] = get_pcvar_num(g_Bonus_He)
	pcv[g18] = get_pcvar_num(g_Bonus_Armor)
	pcv[g19] = get_pcvar_num(g_Lvl_Money)
	pcv[g20] = get_pcvar_num(g_Bonus_Money)		
	
	BlockMapBonus()
	LoadSettings()
}

///////////////// BLOCK MAP BONUS /////////////////////
public BlockMapBonus() 
{
    if(pcv[g8]) 
    {
        new Map[32]
        new block_bonus[32]
        get_mapname(Map, 31)
        for(new i = 0; i < ArraySize(g_array_block_bonus); i++)
        {           
            ArrayGetString(g_array_block_bonus, i, block_bonus, 31)          
            if(equal(Map, block_bonus))
            {
                bonus_blocked = true
                break
            }
            else
                bonus_blocked = false
        }
    }
}

public MapConst(id, level, cid)
{
    if(!cmd_access(id, level, cid, 2))
        return PLUGIN_HANDLED
        
    new arg[32]
    read_argv(1, arg, 31)
    ArrayPushString(g_array_block_bonus, arg)
    
    return PLUGIN_HANDLED
}
///////////////////////////////////////////////////////////////////

/////////////////// CHAT /////////////////////
public LangRus(id)
{
	if(!iPlayerRus[id])
	{
		iPlayerRus[id] = true
		PrintMsg(id, 0, "^4Русский ^1чат активирован!")
	}
	else PrintMsg(id, 0, "^3Русский ^1чат уже активирован!")
}
 
public LangEng(id)
{
	if(iPlayerRus[id])
	{
		iPlayerRus[id] = false
		PrintMsg(id, 0, "^4Английский ^1чат активирован!")
	}
	else PrintMsg(id, 0, "^3Английский ^1чат уже активирован!")
}

public Say(id)
	return SayHandler(id, false)
	
public SayTeam(id)
	return SayHandler(id, true)

public SayHandler(id, bool:is_say_team)
{
	read_args(szMessage, charsmax(szMessage))
	remove_quotes(szMessage)
	if(!szMessage[0] || szMessage[0] == '/') return PLUGIN_HANDLED_MAIN 
	replace_all2(szMessage, charsmax(szMessage), "%", "")
	if(!iPlayerRusInfo[id])
	{
		if(!iPlayerRus[id])
		{
			iPlayerRusInfo[id] = true
			PrintMsg(id, 0, "^1У Вас есть возможность писать ^3по-русски. ^1Наберите ^4/rus ^1или ^4/eng ^1для переключения.")
		}
	}
	if(iPlayerRus[id])
	{	
		for(new i; i < sizeof eng; i++)
			replace_all2(szMessage, charsmax(szMessage), eng[i], rus[i])
	}
	new szFormatedMsg[191], szLen, szName[32], iAlive = is_user_alive(id), iTeam = get_pdata_int(id, 114)
	
	get_user_name(id, szName, charsmax(szName))
	if(is_say_team)
	{
		switch(iTeam)
		{
			case 1: szLen = formatex(szFormatedMsg[szLen], charsmax(szFormatedMsg), "%s(Команде) ", iAlive ? "^1" : "^1*УБИТ* ")
			case 2: szLen = formatex(szFormatedMsg[szLen], charsmax(szFormatedMsg), "%s(Команде) ", iAlive ? "^1" : "^1*УБИТ* ")
			case 3: szLen = formatex(szFormatedMsg[szLen], charsmax(szFormatedMsg), "^1(Наблюдатель) ")
		}
	}
	else 
	{
		if(iTeam == 3) szLen = formatex(szFormatedMsg[szLen], charsmax(szFormatedMsg), "^1(Наблюдатель) ")
		else szLen = formatex(szFormatedMsg[szLen], charsmax(szFormatedMsg) - szLen, "%s", iAlive ? "^1" : "^1*УБИТ* ")
	}	
 
        #if defined PREFIX
        new iFlags = get_user_flags(id)       
	if(iFlags & ADMIN_PREFIX)
		szLen += formatex(szFormatedMsg[szLen], charsmax(szFormatedMsg) - szLen, "%L [^3%L^1] ^3%s^1 :^4 ", LANG_PLAYER, "ADMIN", LANG_PLAYER, CLASSES[PlayerLevel[id]], szName)
	else if(iFlags & VIP_PREFIX)
		szLen += formatex(szFormatedMsg[szLen], charsmax(szFormatedMsg) - szLen, "%L [^3%L^1] ^3%s^1 : ", LANG_PLAYER, "VIP", LANG_PLAYER, CLASSES[PlayerLevel[id]], szName)		
	else			
		szLen += formatex(szFormatedMsg[szLen], charsmax(szFormatedMsg) - szLen, "[^3%L^1] ^3%s^1 : ", LANG_PLAYER, CLASSES[PlayerLevel[id]], szName)
	#else			
		szLen += formatex(szFormatedMsg[szLen], charsmax(szFormatedMsg) - szLen, "[^3%L^1] ^3%s^1 : ", LANG_PLAYER, CLASSES[PlayerLevel[id]], szName)	
	#endif
		
	szLen += formatex(szFormatedMsg[szLen], charsmax(szFormatedMsg) - szLen, "%s", szMessage)	

	static players[32], pcount; get_players(players, pcount, "c")
	if(is_say_team)
	{
		for(new i; i < pcount; i++)
			if(get_user_flags(players[i]) & ADMIN_BAN || (iTeam == get_user_team(players[i]) && iAlive == is_user_alive(players[i])))
				PrintMsg(players[i], id, szFormatedMsg)
	}
	else
	{
		for(new i; i < pcount; i++)
			PrintMsg(players[i], id, szFormatedMsg)
	}
	return PLUGIN_HANDLED
}

stock PrintMsg(const iReceiver, const iSender, const szMessage[], any:...)
{
	new szMsg[191]
	vformat(szMsg, charsmax(szMsg), szMessage, 4)
	message_begin(MSG_ONE_UNRELIABLE, 76, _, iReceiver)
	write_byte(iSender ? iSender : iReceiver)
	write_string(szMsg)
	message_end()
}

stock replace_all2(string[], len, const what[], const with[])
{
	new pos
	if((pos = contain(string, what)) == -1) return 0
	new total, with_len = strlen(with), diff = strlen(what) - with_len, total_len = strlen(string), temp_pos
	while(total_len + with_len < len && replace(string[pos], len - pos, what, with) != 0)
	{
		total++
		pos += with_len
		total_len -= diff
		if (pos >= total_len) break
		temp_pos = contain(string[pos], what)
		if (temp_pos == -1) break
		pos += temp_pos
	}
	return total
}
/////////////////////////////////////////////////////////////////////////////

/////////////////////// RANK, LEVEL i td... ////////////////////	
public LoadSettings() 
{
	new i, cvLevels[256], LVL[31][16]

	get_pcvar_string(g_Levels, cvLevels, 255)
	trim(cvLevels)
	parse(cvLevels, LVL[0], 15, LVL[1], 15, LVL[2], 15, LVL[3], 15, LVL[4], 15, LVL[5], 15, LVL[6], 15, LVL[7], 15, LVL[8], 15, LVL[9], 15, LVL[10], 15, LVL[11], 15, LVL[12], 15, LVL[13], 15, LVL[14], 15, LVL[15], 15, LVL[16], 15, LVL[17], 15, LVL[18], 15, LVL[19], 15, LVL[20], 15, LVL[21], 15, LVL[22], 15, LVL[23], 15, LVL[24], 15, LVL[25], 15, LVL[26], 15, LVL[27], 15, LVL[28], 15, LVL[29], 15, LVL[30], 15)
	
	for (i = 0; i < 30; i++)
		LEVELS[i+1] = str_to_num(LVL[i])

	return PLUGIN_HANDLED
}

public checkLvl(id) 
{
        new Name[32]
	get_user_name(id, Name, 31)
	
	if(id > 0 && id < 33) 
	{
		if (PlayerLevel[id] <= 0)
			PlayerLevel[id] = 1
			
		if (PlayerLevel[id] < 30) 
		{
			while(PlayerXP[id] >= LEVELS[PlayerLevel[id]+1]) 
			{
				PlayerLevel[id]++
				levelUp[id] = 1				
				ChatColor(0, "%L %L", LANG_PLAYER,"LRS_TAG", LANG_PLAYER,"NEW_LEVEL", Name, LANG_PLAYER,CLASSES[PlayerLevel[id]])
			}
		}
	}	
}

public EventDeath() 
{
	new iKiller = read_data(1)
	new iVictim = read_data(2)
	
	if(iKiller != iVictim && get_pdata_int(iKiller, 114) != get_pdata_int(iVictim, 114) && is_user_connected(iKiller) && PlayerLevel[iKiller] < 30) 
	{
		if (pcv[g6]) 
		{
			if(read_data(3))
				PlayerXP[iKiller] += pcv[g1] * 2
			else
				PlayerXP[iKiller] += pcv[g1]
		}
		else
			PlayerXP[iKiller] += pcv[g1]

		checkLvl(iKiller)
	}	                             
	return PLUGIN_CONTINUE
}

public bomb_explode(id)
{
   if(pcv[g5] < 1 || pcv[g2] != 1)
	return

   if(get_playersnum() <= pcv[g3])
   {  
         ChatColor(id, "%L", LANG_PLAYER,"MIN_PLAYERS")
   } 
   else 
   {
         PlayerXP[id] += pcv[g5]
   }
}

public bomb_defused(id) 
{
   if(pcv[g4] < 1 || pcv[g2] != 1)
	return

   if(get_playersnum() <= pcv[g3])
   {  
         ChatColor(id, "%L", LANG_PLAYER,"MIN_PLAYERS")
   } 
   else 
   {
         PlayerXP[id] += pcv[g4]
   }
}

public client_putinserver(id)     
	set_task(1.0, "load_client_data", id)

public load_client_data(id) 
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED

	new stats[8], bodyhits[8], stats2[4]
	get_user_stats(id, stats, bodyhits)

	if (pcv[g4])
		get_user_stats2(id, stats2)
	
	if (pcv[g6])
		PlayerXP[id] = ((stats[2]*2 + (stats[0] - stats[2])) + (stats2[1]*3 + stats2[3]*3)) * pcv[g1]
	else
		PlayerXP[id] = (stats2[1]*3 + stats2[3]*3 + stats[0]) * pcv[g1]

	for(new i = 1; i <= 30; i++) 
	{
		if (i < 30) 
		{
			if (PlayerXP[id] >= LEVELS[i] && PlayerXP[id] < LEVELS[i+1])
				PlayerLevel[id] = i
		}
		else 
		{
			if (PlayerXP[id] >= LEVELS[30])
				PlayerLevel[id] = 30
		}
	}
	return PLUGIN_HANDLED
}
///////////////////////////////////////////////////////////////////////////

#if defined STATUS_VALUE
public StatusValueShow(id)
{
    new name[32], pid = read_data(2)
    get_user_name(pid, name, 31)
    
    if(get_pdata_int(id, 114) == get_pdata_int(pid, 114))
    {
        set_hudmessage(255, 127, 0, -1.0, 0.6, 1, 0.01, 3.0, 0.01, 0.01, -1)
        ShowSyncHudMsg(id, g_MsgHud2, "Ник: %s ^n%L: %L", name, LANG_PLAYER, "ZVANIE", LANG_PLAYER, CLASSES[PlayerLevel[pid]])
    }
}

public StatusValueHide(id)
    ClearSyncHud(id, g_MsgHud2)
#endif

/////////////////// BONUS //////////////////
public RoundRestart(id)
	round_count = 1
	
public RoundStart()
{
   round_count++
   maxrank = get_statsnum()

   if(!pcv[g7] || bonus_blocked) return
       
   static Players[32], Count
   new id, Money
   
   get_players(Players, Count, "ach")
     
   for(new i = 0; i < Count; i++)
   {
       id = Players[i]
       Money = cs_get_user_money(id) 
       
       if(round_count > 2)
       {
           if(pcv[g9] && PlayerLevel[id] >= pcv[g14])
              give_item(id,"weapon_smokegrenade")
              
           if(pcv[g10] && PlayerLevel[id] >= pcv[g15])
              give_item(id,"weapon_flashbang")
              
           if(pcv[g10] && PlayerLevel[id] >= pcv[g16])
              give_item(id,"weapon_flashbang")
              
           if(pcv[g11] && PlayerLevel[id] >= pcv[g17])
              give_item(id,"weapon_hegrenade")
              
           if(pcv[g12] && PlayerLevel[id] >= pcv[g18])
              cs_set_user_armor(id, 100, CS_ARMOR_VESTHELM)
              
           if(pcv[g13] && PlayerLevel[id] >= pcv[g19])
           {
              if(Money < 5000)
              {
                 cs_set_user_money(id, Money + pcv[g20])
                 ChatColor(id, "%L %L", LANG_PLAYER, "LRS_TAG", LANG_PLAYER, "BONUS_MONEY", pcv[g20])
              }
           }  
        }        
    }
}
//////////////////////////////////////////////////////////////

////////////////// INFORMER ///////////////////////    
public Info() 
{
    static Players[32], Count, buffer[192], len
    new id, id2, Name2[32], live, osef[8]           
    get_players(Players, Count, "ch")    						                                       

    for(new i = 0; i < Count; i++) 
    {
        id = Players[i]
        live = is_user_alive(id)
        id2 = pev(id, pev_iuser2)
        get_user_name(id2, Name2, 31)        
        g_oldrank[id] = get_user_stats(id, osef, osef) 
        
        if(!live) 
	{	    	    	    							
	    if(id2 > 0) 
	    {										
	        if(PlayerLevel[id2] < 30) 
		{
			len = format(buffer, charsmax(buffer), "%L: %s", LANG_PLAYER,"A_NAME", Name2)
			len += format(buffer[len], charsmax(buffer) - len, "^n%L:", LANG_PLAYER,"ZVANIE")
			len += format(buffer[len], charsmax(buffer) - len, " %L", LANG_PLAYER,CLASSES[PlayerLevel[id2]])
			len += format(buffer[len], charsmax(buffer) - len, "^n%L: %d", LANG_PLAYER,"PL_XP",PlayerXP[id2])
			len += format(buffer[len], charsmax(buffer) - len, "^n%L: %d", LANG_PLAYER,"RANK", g_oldrank[id2])
		}
		else 
		{
			len = format(buffer, charsmax(buffer), "%L: %s", LANG_PLAYER,"A_NAME", Name2)
			len += format(buffer[len], charsmax(buffer) - len, "^n%L:",LANG_PLAYER,"ZVANIE")
			len += format(buffer[len], charsmax(buffer) - len, " %L",LANG_PLAYER,CLASSES[PlayerLevel[id2]])
			len += format(buffer[len], charsmax(buffer) - len, "^n%L: %L",LANG_PLAYER,"PL_XP", LANG_PLAYER,"PL_MAX")
			len += format(buffer[len], charsmax(buffer) - len, "^n%L: %d", LANG_PLAYER,"RANK", g_oldrank[id2])
		}					
	    }
	    else 
	    {
		if(PlayerLevel[id] < 30) 
		{
			len = format(buffer, charsmax(buffer) - len, "%L: %L", LANG_PLAYER,"ZVANIE", LANG_PLAYER,CLASSES[PlayerLevel[id]])
			len += format(buffer[len], charsmax(buffer) - len, "^n%L: %d",LANG_PLAYER,"PL_XP",PlayerXP[id])
			len += format(buffer[len], charsmax(buffer) - len, "^n%L: %d", LANG_PLAYER,"RANK", g_oldrank[id])
		}
		else 
		{
			len = format(buffer, charsmax(buffer) - len, "%L: %L", LANG_PLAYER,"ZVANIE", LANG_PLAYER,CLASSES[PlayerLevel[id]])
			len += format(buffer[len], charsmax(buffer) - len, "^n%L",LANG_PLAYER,"PL_MAX")
			len += format(buffer[len], charsmax(buffer) - len, "^n%L: %d", LANG_PLAYER,"RANK", g_oldrank[id])
		}
	    }
	}
	else 
	{
		if((PlayerLevel[id] < 30) && live) 
		{
			len = format(buffer, charsmax(buffer), "%L", LANG_PLAYER,CLASSES[PlayerLevel[id]])
			len += format(buffer[len], charsmax(buffer) - len, "^n%L: %d %L %d", LANG_PLAYER,"PL_XP",PlayerXP[id], LANG_PLAYER,"IZ", LEVELS[PlayerLevel[id]+1])
			len += format(buffer[len], charsmax(buffer) - len, "^n%L: %d %L %d", LANG_PLAYER,"RANK", g_oldrank[id], LANG_PLAYER,"IZ", maxrank)
		}
		else 
		{
			len = format(buffer, charsmax(buffer), "%L",LANG_PLAYER,CLASSES[PlayerLevel[id]])
			len += format(buffer[len], charsmax(buffer) - len, "^n%L: %L",LANG_PLAYER,"PL_XP", LANG_PLAYER,"PL_MAX")
			len += format(buffer[len], charsmax(buffer) - len, "^n%L: %d %L %d", LANG_PLAYER,"RANK", g_oldrank[id], LANG_PLAYER,"IZ", maxrank)
		}
	}
	set_hudmessage(255, 255, 255, 0.01, 0.19, 0, 0.0, HUD_UPD, _, _, -1)
	ShowSyncHudMsg(id, g_MsgHud, "%s", buffer)
    }
    return PLUGIN_CONTINUE
}
/////////////////////////////////////////////////////////////////

////////////////// STOCK //////////////////////	
stock ChatColor(const id, const input[], any:...)
{
    new count = 1, players[32]
    static msg[192]
    vformat(msg, 191, input, 3)
   
    replace_all(msg, 191, "!g", "^4") // Green Color
    replace_all(msg, 191, "!y", "^1") // Default Color
    replace_all(msg, 191, "!t", "^3") // Team Color
   
    if (id) players[0] = id; else get_players(players, count, "ch")
    {
        for (new i = 0; i < count; i++)
        {
            if (is_user_connected(players[i]))
            {
                message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i])
                write_byte(players[i])
                write_string(msg)
                message_end()
            }
        }
    }
}
/////////////////////////////////////////////////////////////