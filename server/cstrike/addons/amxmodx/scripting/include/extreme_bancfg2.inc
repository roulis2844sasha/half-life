/*
Pozwala ingerowaæ w zdarzenia pluginu
	extreme_bancfg2.amxx
	odwo³asz wyrzucenie gracze z serwera w extreme_bancfg2.amxx	
	w wersji >= 2.4
*/
/*
* Description:		Wywo³ywany w momencie wydania bana
*		
*	Zwróæ PLUGIN_HANDLED, aby anulowaæ wykonywanie bana.
*
* @param	id		Id zbanowanego gracza 
*					lub 
*				0, gdy ban dla gracza, którego nie ma na serwie 	
* @param	szReason	Powód 
* @param	iTime		Czas bana
* @param	idAdmin		Id admina	
* @param	isSteam		true, jeœli plugin uwa¿a gracza za posiadaj¹cego Steam
*				false, w pozosta³ych przypadkach
*/
forward bancfg_ban(id, const szReason[], iTime, idAdmin, bool:isSteam);


/*
* Description:		Wywo³ywany w momencie zniesienia bana
*		
*	Zwróæ PLUGIN_HANDLED, aby anulowaæ zniesienie bana.
*	
* @param	szCode		Kod (numer)
* @param	szName		Nick zbanowanego gracza
* @param	szAdminName	Nick admina wydaj¹cego ban
* @param	szReason	Powód bana	
* @param	iTimeStamp	Czas wydania bana (wskaŸnik czasu)
* @param	iTimeStamp	Czas wygaœniêcia bana (wskaŸnik czasu) 0-perm
* @param 	szShort		Skrót gracza
*/
forward bancfg_unban(const szCode[], const szName[], const szAdminName[], const szReason[], iTimeStamp, iUnBanTime, const szShort[]);

/**
* Description:		Wywo³ywany w momencie kicka
*	Pozwala przej¹æ kontrolê nad tym wydarzeniem.
*
*	Zwróæ PLUGIN_CONTINUE, gdy wszystko ma siê odbyæ zgodnie z konfiguracj¹ bancfg.
*	Zwracaj¹c PLUGIN_HANDLED odwo³asz wykonanie kicka z extreme_bancfg2.amxx.
*	Zamiast domyœlnego kicka mo¿esz wykonaæ go na w³asn¹ rêkê w dowolny sposób.
*	
*	Przyk³ad:
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
*		client_cmd(id, "say Zostalem zbanowany przez %s, czeœæ!",szAdminName);
*		client_cmd(id, "disconnect");
*		return PLUGIN_HANDLED;
*	}
*	[/code]
*
* 					
* @param	id		Id zbanowanego gracza 	
* @param	szReason	Powód 
* @param	iTime		Czas bana
* @param	szAdminName	Nick admina wydaj¹cego bana
* @param	connecting	true, jeœli wykop idzie tu¿ po po³¹czeniu
*				false, wykop zaraz po zbanowaniu
*/
forward bancfg_kick(id, const szReason[], iTime, const szAdminName[], bool:connecting);
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/
