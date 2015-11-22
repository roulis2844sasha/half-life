/* AMX Mod X
*   Anti Reconnect Plugin 3.0
*   
*   Версии антиреконнекта:
	3.0 - два режима работы: отсчёт времени после попытки зайти или отсчёт времени после использования команды reconnect
		задаётся командой amx_reconnect_static <0|1> 0 - каждый раз заного отсчитывать время, запрещающее заходить.
		1 - отсчитывать время только после выхода с сервера
		amx_reconnect_stime - кол-во секунд, на протяжении которых сохраняется счёт для пользователя по ip юзера.
	    - перед киком проверка производится так же на ip пользователя... если зашёдший имеет другой ip - он не кикается.
      2.0 - исправлен баг с уведомлением о том, что надо подождать, прежде чем войти на сервер
   	    - добавлена команда amx_reconnect_ss <1|0> - запоминать счёт игрока или нет (работает при amx_reconnect_can 1)
      1.01 - кикает всех, кто заходит раньше установленного времени после того как вышел (т.е. использует реконнект)
           - поддерживаемые команды:
             amx_reconnect_can <1|0> - можно или нет реконнектиться
             amx_reconnect_time <sec> - время в секундах, которое нужно ждать после ухода с сервера, чтобы сного на него зайти

*/

#include <amxmodx>
#include <cstrike>
#include <fun>

new PLUGIN[]="Anti reconnect"
new AUTHOR[]="kzesc"
new VERSION[]="3.0"

new RTIME[]="amx_reconnect_time"
new RCAN[]="amx_reconnect_can"
new SCORESAVE[]="amx_reconnect_ss"
new RSTATIC[]="amx_reconnect_static"
new RSTIME[]="amx_reconnect_stime"

new t_disconnect[33] = {0, ...}
new t_scoresave[33] = {0, ...}
new ips[33][24]
new sfrags[33] = {0, ...}
new sdeaths[33] = {0, ...}
new money[33] = {0, ...}
new useretry[33] = {0, ...}

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_cvar(RTIME, "7")
	register_cvar(RCAN, "1")
	register_cvar(SCORESAVE, "1")
	register_cvar(RSTATIC, "1")
	register_cvar(RSTIME, "7")
	register_event("TeamInfo","outspec","a") 	// восстанавливает счёт игроку в соответствии с настройками как только тот зайдёт за команду
}

public client_connect(id)
{
	if ((is_user_bot(id)) || (get_user_flags(id) & ADMIN_RESERVATION) || (is_user_hltv(id)))
		return PLUGIN_HANDLED
	new maxexit = get_cvar_num(RTIME)
	new maxstata = get_cvar_num(RSTIME)
	new canreconnect = get_cvar_num(RCAN)
	new ssave = get_cvar_num(SCORESAVE)
	new ip[24]
	get_user_ip(id,ip,23,0)

	if ((maxexit>0) && (canreconnect==0) && (equali(ip,ips[id])))
	{
		new Float:nexTime = get_gametime()
		
		if (t_disconnect[id] > nexTime)
		{
		 new stat = get_cvar_num(RSTATIC)
		 new timewait
		 if (stat==0)
		 {
 		  t_disconnect[id] = floatround(nexTime) + maxexit
		  t_scoresave[id] = floatround(nexTime) + maxstata
		  timewait=maxexit
		 }
		 else
		 {
		  timewait=t_disconnect[id]-floatround(nexTime)
		 }
 	  	 server_cmd("kick #%d ^"Повторное подключение будет доступно через %d секунд^"", get_user_userid(id), timewait)
		 return PLUGIN_CONTINUE
		}
	}
	if (ssave==1 && (equali(ip,ips[id])))
	{
		new Float:nexTime = get_gametime()

		if (t_scoresave[id] <= nexTime)
		{
		 sdeaths[id]=false
		 money[id]=false
		 sfrags[id]=false
		 useretry[id]=false
		}
		return PLUGIN_CONTINUE
	}

	return PLUGIN_CONTINUE
}

public outspec()
{
 new id=read_data(1)
 if ((useretry[id]) && (is_user_connected(id)))
 {
  cs_set_user_deaths(id,sdeaths[id])
  set_user_frags(id,sfrags[id])
  cs_set_user_money(id, money[id])
  useretry[id]=false
  sdeaths[id]=false
  sfrags[id]=false
  money[id]=false
 }
 return PLUGIN_CONTINUE
}

public client_disconnect(id)
{
	if ((is_user_bot(id)) || (get_user_flags(id) & ADMIN_RESERVATION) || (is_user_hltv(id)))
		return PLUGIN_HANDLED
	new maxexit = get_cvar_num(RTIME)
	new maxstata = get_cvar_num(RSTIME)
	new ssave = get_cvar_num(SCORESAVE)

	new Float:theTime = get_gametime()
	t_disconnect[id] = floatround(theTime) + maxexit
	t_scoresave[id] = floatround(theTime) + maxstata
	get_user_ip(id,ips[id],23,0)
	
 	if (ssave==1)
	{
	 sdeaths[id] = get_user_deaths(id)
	 sfrags[id] = get_user_frags(id)
	 money[id] = cs_get_user_money(id)
	 useretry[id]=true
	}
	return PLUGIN_CONTINUE
}