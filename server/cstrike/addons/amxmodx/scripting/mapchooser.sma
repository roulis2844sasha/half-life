/*
	Nextmap Chooser
	»нтегрированы:	Lastround & RockTheVote

	»спользован код следующих плагинов, за что их авторам больша€ благодарность:
		1.	Nextmap Chooser Plugin
			by the AMX Mod X Development Team
 			originally developed by OLO
 
 		2.	RockTheVote	v1.8
	 		Made by DA

	ѕеременные:
		amx_extendmap_max  (default: 45)  - ћаксимальна€ длительность карты в минутах
		amx_extendmap_step (default: 15)  - ¬рем€ продлени€ карты за 1 раз в минутах
		amx_vote_time      (default: 15)  - ƒлительность голосовани€ в секундах
		amx_vote_delay     (default: 3)   - ќтсрочка голосовани€ в минутах от начала карты
		amx_votemap_ratio  (default: 0.6) - ѕроцент голосов дл€ начала голосовани€ (по-умолчанию 60%)
		amx_lastround      (default: 1)   - ѕроизводить смену карты по окончании раунда.

	Rebuilding by UFPS.Team
*/


#include <amxmodx>
#include <amxmisc>

#define PLUGIN_NAME		"Nextmap Chooser"
#define PLUGIN_VERSION	"1.9"
#define PLUGIN_AUTHOR	"UFPS.Team"

#define SELECTMAPS		5
#define MAPS_MAX		128
#define AUTO_LANG		-76

#define charsmax(%1)	(sizeof(%1)-1)


new g_mapNums
new g_mapName		[MAPS_MAX][32]

new g_nextName		[SELECTMAPS]
new g_voteCount		[SELECTMAPS + 2]
new g_mapVoteNum
new g_teamScore		[2]
new g_lastMap		[32]
new g_rtv_count
new g_rtv_vote		[33]

new g_MENU			[512]
new g_MENU_keys =	( 1 << SELECTMAPS + 1 )
new g_MENU_name		[64]
new g_MENU_title	[128]

new const speak[][] = { "one", "two", "three", "four", "five" }

new g_coloredMenus		= 0
new bool:g_rtv			= false
new bool:g_lastround	= false
new bool:g_changemap	= false
new bool:g_selected		= false
new Float:g_timelimit	= 0.0

new pcv_lastround
new pcv_extendmap_max
new pcv_extendmap_step
new pcv_vote_time
new pcv_vote_delay
new pcv_votemap_ratio
new pcv_amx_nextmap
new pcv_mp_chattime
new pcv_mp_timelimit
new pcv_mp_winlimit
new pcv_mp_maxrounds


public plugin_init( )
{
	register_plugin( PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR )

	register_dictionary	( "common.txt" )
	register_dictionary	( "lastround.txt" )
	register_dictionary	( "mapchooser.txt" )

	register_clcmd( "say rockthevote",			"cmd_say_rtv" )
	register_clcmd( "say /rockthevote",			"cmd_say_rtv" )
	register_clcmd( "say rtv",					"cmd_say_rtv" )
	register_clcmd( "say /rtv",					"cmd_say_rtv" )

	register_clcmd( "say_team rockthevote",		"cmd_say_rtv" )
	register_clcmd( "say_team /rockthevote",	"cmd_say_rtv" )
	register_clcmd( "say_team rtv",				"cmd_say_rtv" )
	register_clcmd( "say_team /rtv",			"cmd_say_rtv" )

	pcv_vote_time		= pcvar_register( "amx_vote_time",		"15"   )
	pcv_vote_delay		= pcvar_register( "amx_vote_delay",		"3"    )
	pcv_votemap_ratio	= pcvar_register( "amx_votemap_ratio",	"0.60" )
	pcv_extendmap_max 	= pcvar_register( "amx_extendmap_max",	"45"   )
	pcv_extendmap_step 	= pcvar_register( "amx_extendmap_step",	"15"   )

	pcv_mp_chattime		= get_cvar_pointer( "mp_chattime"  )
	pcv_mp_timelimit	= get_cvar_pointer( "mp_timelimit" )
	pcv_mp_winlimit		= get_cvar_pointer( "mp_winlimit"  )
	pcv_mp_maxrounds	= get_cvar_pointer( "mp_maxrounds" )
	pcv_amx_nextmap		= get_cvar_pointer( "amx_nextmap"  )

	if( !pcv_amx_nextmap )
		pcv_amx_nextmap	= register_cvar( "amx_nextmap",	"", FCVAR_SERVER | FCVAR_EXTDLL | FCVAR_SPONLY )

	if( cstrike_running( ) )
	{
		pcv_lastround = register_cvar( "amx_lastround", "1" )
		register_event( "TeamScore", "team_score", "a" )
		register_logevent( "evRoundStart", 2, "0=World triggered", "1=Round_Start" )
	}

	register_event( "30", "mapChange", "a" )

	g_coloredMenus = colored_menus( )

	get_localinfo( "lastMap", g_lastMap, charsmax( g_lastMap ) )
	set_localinfo( "lastMap", "" )

	set_cvar_float( "sv_restart", 1.0 )
}

public plugin_cfg( )
{
	new mapcycle[64]
	get_configsdir( mapcycle, charsmax( mapcycle ) )
	format( mapcycle, charsmax( mapcycle ), "%s/maps.ini", mapcycle )

	if( !file_exists( mapcycle ) )
		get_cvar_string( "mapcyclefile", mapcycle, charsmax( mapcycle ) )

	if( !file_exists( mapcycle ) )
		copy( mapcycle, charsmax( mapcycle ), "mapcycle.txt" )

	if( loadSettings( mapcycle) )
		set_task( 15.0, "voteNextmap", 987456, "", 0, "b" )

	formatex( g_MENU_name, charsmax( g_MENU_name ), "%L", "en", "CHOOSE_NEXTM" )
	register_menucmd( register_menuid( g_MENU_name ), ( -1 ^ ( -1 << ( SELECTMAPS + 2 ) ) ), "countVote" )
}

public countVote( id, key )
{
	if( get_cvar_float( "amx_vote_answers" ) )
	{
		new name[32]
		get_user_name( id, name, charsmax( name ) )

		if( key == SELECTMAPS )
			client_print( 0, print_chat, "%L", LANG_PLAYER, "CHOSE_EXT", name )

		else if( key < SELECTMAPS )
		{
			new map[32]
			copy( map, charsmax( map ), g_mapName[g_nextName[key]] )
			client_print( 0, print_chat, "%L", LANG_PLAYER, "X_CHOSE_X", name, map )
		}
	}

	g_voteCount[key]++

	return PLUGIN_HANDLED
}

public voteNextmap( )
{
	if( !g_mapNums ) return 0

	new winlimit = get_pcvar_num( pcv_mp_winlimit )
	new maxrounds = get_pcvar_num( pcv_mp_maxrounds )

	if( g_rtv )
	{
		winlimit = 0
		maxrounds = -1
	}

	if( winlimit )
	{
		new c = winlimit - 2

		if( ( c > g_teamScore[0] ) && ( c > g_teamScore[1] ) )
		{
			g_selected = false
			return 0
		}
	}

	else if( maxrounds )
	{
		if( ( maxrounds - 2 ) > ( g_teamScore[0] + g_teamScore[1] ) )
		{
			g_selected = false
			return 0
		}
	}
	
	else
	{
		new timeleft = get_timeleft( )

		if( timeleft < 1 || timeleft > 129 )
		{
			g_selected = false
			return 0
		}
	}

	if( g_selected ) return 0

	g_selected = true

	new pos, a

	g_MENU_keys = ( 1 << SELECTMAPS + 1 )

	new dmax = clamp( g_mapNums, 0, SELECTMAPS )

	for( g_mapVoteNum = 0; g_mapVoteNum < dmax; g_mapVoteNum++ )
	{
		a = random_num( 0, g_mapNums - 1 )

		while( isInMenu( a ) ) { if( ++a >= g_mapNums ) a = 0; }

		g_nextName[g_mapVoteNum] = a
		pos += format( g_MENU[pos], charsmax( g_MENU ), "%d. %s^n", g_mapVoteNum + 1, g_mapName[a] )
		g_MENU_keys |= ( 1 << g_mapVoteNum )
		g_voteCount[g_mapVoteNum] = 0
	}

	g_MENU[pos++] = '^n'
	g_voteCount[SELECTMAPS] = 0
	g_voteCount[SELECTMAPS + 1] = 0

	new mapname[32]
	get_mapname( mapname, charsmax( mapname ) )

	if( ( winlimit + maxrounds ) == 0 && ( get_pcvar_float( pcv_mp_timelimit ) < get_pcvar_float( pcv_extendmap_max ) ) )
	{
		pos += format( g_MENU[pos], charsmax( g_MENU ), "%d. %L^n", SELECTMAPS + 1, LANG_SERVER, "EXTED_MAP", mapname )
		g_MENU_keys |= ( 1 << SELECTMAPS )
	}

	format( g_MENU[pos], charsmax( g_MENU ), "%d. %L", SELECTMAPS + 2, LANG_SERVER, "NONE" )
	set_task( 1.0, "countDown", 5 )

	return 1
}

stock bool:isInMenu( id )
{
	for( new a; a < g_mapVoteNum; a++ )
		if( id == g_nextName[a] ) return true

	return false
}

public countDown( timer )
{
	if( timer )
	{
		client_cmd( 0 ,"spk ^"fvox/%s^"", speak[timer-1] )
		say_hudmessage( 0, 64, 64, 64, 0.025, -1.0, 0, 0.0, 1.03, 0.0, 0.0, 4, "%L %L", AUTO_LANG, "CHOOSE_NEXTM", AUTO_LANG, "VOTE_COUNTER", timer, g_MENU )
		set_task(1.0, "countDown", --timer)
	}

	else
		set_task( 0.01, "showMenu" )
}

public showMenu( )
{
	new Float:votetime = floatclamp( get_pcvar_float ( pcv_vote_time ), 10.0, 60.0 )

	new menu[512], players[32], player, num
	get_players( players, num, "ch" )

	for( new i; i < num; i++ )
	{
		player = players[i]

		formatex( g_MENU_title, charsmax( g_MENU_title ), g_coloredMenus ? "\y%L:\w^n^n" : "%L:^n^n", player, "CHOOSE_NEXTM" )
		formatex( menu, charsmax( menu ), "%s%s", g_MENU_title, g_MENU )
		show_menu( player, g_MENU_keys, menu, floatround( votetime ), g_MENU_name )
	}

	set_task( votetime + 0.5, "checkVotes" )

	client_print( 0, print_chat, "%L", LANG_PLAYER, "TIME_CHOOSE" )
	client_cmd( 0, "spk Gman/Gman_Choose%d", random_num( 1, 2 ) )
	log_amx( "Vote: Voting for the nextmap started" )
}

public checkVotes( )
{
	new b = 0

	for( new a; a < g_mapVoteNum; ++a )
		if( g_voteCount[b] < g_voteCount[a] ) b = a

	if( g_voteCount[SELECTMAPS] > g_voteCount[b] && g_voteCount[SELECTMAPS] > g_voteCount[SELECTMAPS + 1] )
	{
		if( !g_timelimit )
			g_timelimit = get_pcvar_float( pcv_mp_timelimit )

		new Float:steptime = get_pcvar_float( pcv_extendmap_step )

		new mapname[32]
		get_mapname( mapname, charsmax( mapname ) )

		set_pcvar_float( pcv_mp_timelimit, get_pcvar_float( pcv_mp_timelimit ) + steptime )
		client_print( 0, print_chat, "%L", LANG_PLAYER, "CHO_FIN_EXT", steptime )
		log_amx( "Vote: Voting for the nextmap finished. Map %s will be extended to next %.0f minutes", mapname, steptime )

		return
	}

	new smap[32]
	if( g_voteCount[b] && g_voteCount[SELECTMAPS + 1] <= g_voteCount[b] )
	{
		copy( smap, charsmax( smap ), g_mapName[g_nextName[b]] )
		set_pcvar_string( pcv_amx_nextmap, smap )
	}

	get_pcvar_string( pcv_amx_nextmap, smap, charsmax( smap ) )
	client_print( 0, print_chat, "%L", LANG_PLAYER, "CHO_FIN_NEXT", smap )
	log_amx( "Vote: Voting for the nextmap finished. The nextmap will be %s", smap )

	new players[32], num
	get_players( players, num, "ch" )

	if( g_rtv )
	{
		if( pcv_lastround && get_pcvar_num( pcv_lastround ) )
		{
			if( !g_timelimit )
				g_timelimit = get_pcvar_float( pcv_mp_timelimit )

			set_pcvar_float( pcv_mp_timelimit, 0.0 )

			g_rtv = false
			g_changemap = true
			g_lastround = false

			say_hudmessage( 0, 210, 0, 0, 0.02, 0.21, 1, 20.0, 10.0, 0.5, 0.15, 4, "%L", AUTO_LANG, "FINAL_ROUND" )
	
			return
		}
	
		else
			g_rtv = false
	}

	else if( num > 1 )
	{
		if( pcv_lastround )
		{
			set_task( 90.0 - floatclamp( get_pcvar_float ( pcv_vote_time ), 10.0, 60.0 ), "initiateLastRound", 23478, "", 0, "d" )
			return
		}
	}

	set_task( 1.0, "delayMapChange" )
}

public initiateLastRound( )
{
	if( !get_pcvar_num( pcv_lastround ) ) return PLUGIN_CONTINUE

	if( !g_timelimit )
		g_timelimit = get_pcvar_float( pcv_mp_timelimit )

	g_lastround = true
	set_pcvar_float( pcv_mp_timelimit, 0.0 )

	say_hudmessage( 0, 100, 200, 0, 0.02, 0.21, 1, 20.0, 10.0, 0.5, 0.15, 4, "%L", AUTO_LANG, "FINAL_COMING" )

	return PLUGIN_CONTINUE
}

public evRoundStart( )
{
	if( !pcv_lastround ) return PLUGIN_CONTINUE

	if( !get_pcvar_num( pcv_lastround ) ) return PLUGIN_CONTINUE

	if( g_lastround )
	{
		g_changemap = true
		g_lastround = false

		say_hudmessage( 0, 210, 0, 0, 0.02, 0.21, 1, 20.0, 10.0, 0.5, 0.15, 4, "%L", AUTO_LANG, "FINAL_ROUND" )
	}
	
	else if( g_changemap )
	{
/*
		message_begin	( MSG_ALL, SVC_INTERMISSION )
		message_end		( )
*/

		set_pcvar_float( pcv_mp_timelimit, 0.01 )
	}

	return PLUGIN_CONTINUE
}

public mapChange ( )
{
	new Float:chattime = get_pcvar_float ( pcv_mp_chattime )

	if ( chattime < 3.0 )
	{
		chattime = 3.0
		set_pcvar_float ( pcv_mp_chattime, chattime )
	}

	set_task( chattime - 1.0, "delayMapChange" )

	return PLUGIN_CONTINUE
}

public delayMapChange( )
{
	new nextmap[32]
	get_pcvar_string( pcv_amx_nextmap, nextmap, charsmax( nextmap ) )
	server_cmd( "changelevel %s", nextmap )
}

loadSettings( filename[] )
{
	if( !file_exists( filename ) )
	{
		log_amx( "Mapcycle file ^"%s^" not found", filename )
		return 0
	}

	g_mapNums = 0

	new currentMap[32], map[32], string[256]
	get_mapname( currentMap, charsmax( currentMap ) )

	new file = fopen( filename, "r" )
	
	while( !feof( file ) )
	{
		fgets( file, string, charsmax( string ) )

		if
		(
			( string[0] != ';' ) &&
			( string[0] != '/' ) &&
			parse( string, map, charsmax( map ) ) &&
			isValidMap( map, charsmax( map ), currentMap ) &&
			isMapCycle( map ) == -1
		)
		{
			copy( g_mapName[g_mapNums++], charsmax( g_mapName[] ), map )
		}
	
	}

	fclose( file )

	return g_mapNums
}

stock bool:isValidMap( map[], const len, const currentMap[] )
{
	remove_quotes ( map )
	strtolower( map )

	while( replace( map, len, "/", "" ) ) {}
	while( replace( map, len, "\", "" ) ) {}
	while( replace( map, len, ":", "" ) ) {}
	while( replace( map, len, "*", "" ) ) {}
	while( replace( map, len, "?", "" ) ) {}
	while( replace( map, len, ">", "" ) ) {}
	while( replace( map, len, "<", "" ) ) {}
	while( replace( map, len, "|", "" ) ) {}
	while( replace( map, len, ".", "" ) ) {}

	if( is_map_valid( map ) && !equali( map, g_lastMap ) && !equali( map, currentMap ) ) return true

	return false
}

stock isMapCycle( map[] )
{
	for( new i; i < g_mapNums; i++ )
		if( equali( g_mapName[i], map ) ) return i

	return -1
}

public team_score( )
{
	new team[2]

	read_data( 1, team, 1 )
	g_teamScore[( team[0]=='C' ) ? 0 : 1] = read_data( 2 )
}

public pcvar_register( const pcvar_name[], const pcvar_value[] )
{
	new pcvar_index = get_cvar_pointer( pcvar_name )
	
	if( !pcvar_index )
		pcvar_index = register_cvar( pcvar_name, pcvar_value )

	return pcvar_index
}

stock say_hudmessage( id, red=255, green=255, blue=255, Float:x=0.05, Float:y=0.45, effects=0, Float:fxtime=6.0, Float:holdtime=5.0, Float:fadeintime=0.5, Float:fadeouttime=0.15, channel=4, msg[], any:... )
{
	new arg_num = numargs()
	new arg_langid[16], arg_langcount

	for( new i = 12; i < arg_num; i++ )
		if( getarg( i ) == AUTO_LANG )
			arg_langid[arg_langcount++] = i

	new players[32], player, num

	if( id )
	{
		players[0] = id
		num = 1
	}

	else
		get_players( players, num )

	set_hudmessage( red, green, blue, x, y, effects, fxtime, holdtime, fadeintime, fadeouttime, channel )

	new message[192]

	for( new i; i < num; i++ )
	{
		player = players[i]

		if( !is_user_connected( player ) ) continue

		for( new j; j < arg_langcount; j++ )
			setarg( arg_langid[j], 0, player )

		vformat( message, charsmax( message ), msg, 14 )
		show_hudmessage( player, message )
	}
}

public cmd_say_rtv( id )
{
	if( get_gametime( ) < ( get_pcvar_float( pcv_vote_delay ) * 60.0 ) )
	{
		new timeleft = floatround( get_pcvar_float( pcv_vote_delay ) * 60.0 - get_gametime( ) )

		client_print( id, print_chat, "%L", id, "RTV_NOTALLOWED", timeleft / 60, timeleft % 60 )
	}

	else
	{
		if( g_rtv_vote[id - 1] == id ) client_print( id, print_chat, "%L", id, "RTV_ALREADY" )

		else
		{
			g_rtv_vote[id - 1] = id
			g_rtv_count++
	
			static players[32], num
			get_players( players, num, "ch" )

			new Float:voteratio = floatclamp( get_pcvar_float ( pcv_votemap_ratio ), 0.0, 1.0 )

			num = floatround( voteratio * num )

			if( num <= g_rtv_count )
			{
			 	g_rtv = true
				voteNextmap( )

				return PLUGIN_CONTINUE
			}

			static name[32]
			get_user_name( id, name, charsmax( name ) )
	
			client_print( 0, print_chat, "%L", LANG_PLAYER, "RTV_ADDVOTE", name, num - g_rtv_count, floatround( voteratio * 100.0 ) )
		}
	}

	return PLUGIN_CONTINUE
}

public client_disconnect( id )
{
	if( g_rtv_vote[id - 1] == id )
	{
		g_rtv_vote[id - 1] = 0
		g_rtv_count--
	}
}

public plugin_end( )
{
	if( g_timelimit )
		set_pcvar_float( pcv_mp_timelimit, g_timelimit )

	new current_map[32]
	get_mapname( current_map, charsmax( current_map ) )

	set_localinfo( "lastMap", current_map )

	return PLUGIN_CONTINUE
}
