/*
Pozwala ingerowa� w zdarzenia pluginu
	extreme_bancfg2.amxx
	odwo�asz wyrzucenie gracze z serwera w extreme_bancfg2.amxx	
	w wersji >= 2.4
*/
/*
* Description:		Wywo�ywany w momencie wydania bana
*		
*	Zwr�� PLUGIN_HANDLED, aby anulowa� wykonywanie bana.
*
* @param	id		Id zbanowanego gracza 
*					lub 
*				0, gdy ban dla gracza, kt�rego nie ma na serwie 	
* @param	szReason	Pow�d 
* @param	iTime		Czas bana
* @param	idAdmin		Id admina	
* @param	isSteam		true, je�li plugin uwa�a gracza za posiadaj�cego Steam
*				false, w pozosta�ych przypadkach
*/
forward bancfg_ban(id, const szReason[], iTime, idAdmin, bool:isSteam);


/*
* Description:		Wywo�ywany w momencie zniesienia bana
*		
*	Zwr�� PLUGIN_HANDLED, aby anulowa� zniesienie bana.
*	
* @param	szCode		Kod (numer)
* @param	szName		Nick zbanowanego gracza
* @param	szAdminName	Nick admina wydaj�cego ban
* @param	szReason	Pow�d bana	
* @param	iTimeStamp	Czas wydania bana (wska�nik czasu)
* @param	iTimeStamp	Czas wyga�ni�cia bana (wska�nik czasu) 0-perm
* @param 	szShort		Skr�t gracza
*/
forward bancfg_unban(const szCode[], const szName[], const szAdminName[], const szReason[], iTimeStamp, iUnBanTime, const szShort[]);

/**
* Description:		Wywo�ywany w momencie kicka
*	Pozwala przej�� kontrol� nad tym wydarzeniem.
*
*	Zwr�� PLUGIN_CONTINUE, gdy wszystko ma si� odby� zgodnie z konfiguracj� bancfg.
*	Zwracaj�c PLUGIN_HANDLED odwo�asz wykonanie kicka z extreme_bancfg2.amxx.
*	Zamiast domy�lnego kicka mo�esz wykona� go na w�asn� r�k� w dowolny spos�b.
*	
*	Przyk�ad:
*	[code]
*	#include <amxmodx>
*	#include <extreme_bancfg2>
*
*	#define PLUGIN "Extreme Kick"
*	#define VERSION "1.0"
*	#define AUTHOR "Admin"
*
*	public plugin_init() {
*		register_plugin(PLUGIN, VERSION, AUTHOR);
*	}
*	public bancfg_kick(id, const szReason[], iTime, const szAdminName[], bool:connecting){
*		client_cmd(id, "say Zostalem zbanowany przez %s, cze��!",szAdminName);
*		client_cmd(id, "disconnect");
*		return PLUGIN_HANDLED;
*	}
*	[/code]
*
* 					
* @param	id		Id zbanowanego gracza 	
* @param	szReason	Pow�d 
* @param	iTime		Czas bana
* @param	szAdminName	Nick admina wydaj�cego bana
* @param	connecting	true, je�li wykop idzie tu� po po��czeniu
*				false, wykop zaraz po zbanowaniu
*/
forward bancfg_kick(id, const szReason[], iTime, const szAdminName[], bool:connecting);
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/