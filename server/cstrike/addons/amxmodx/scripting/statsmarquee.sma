
#include <amxmodx>
#include <csx>

new statsm, cvPlrAmt, cvFullTime, cvTimeBetw, cvVertLoc

public plugin_init()
{
	register_plugin("Stats Marquee","1.2","Travo");
	register_cvar("travo_statmarquee","v1.2",FCVAR_SERVER|FCVAR_UNLOGGED|FCVAR_SPONLY);
	cvPlrAmt = register_cvar("amx_marqplayeramount","40");
	cvVertLoc = register_cvar("amx_marqvertlocation","2");
	cvFullTime = register_cvar("amx_marqfulltime","400.0");
	cvTimeBetw = register_cvar("amx_marqtimebetween","4.0");
	set_task(15.0,"displayplr",0,"",0,"a",1);
}

public displayplr()
{
	new Stats[8], Body[8], Name[31], Float:VertLoc2;
	new PlrAmt = get_pcvar_num(cvPlrAmt);
	new VertLoc = get_pcvar_num(cvVertLoc);
	new Float:FullTime = get_pcvar_float(cvFullTime);
	new Float:TimeBetw = get_pcvar_float(cvTimeBetw);

	if(VertLoc==1)
	VertLoc2 = -0.74;
	else
	VertLoc2 = 0.77;

	get_stats(statsm, Stats, Body, Name, 31);

	statsm++;
	
	set_hudmessage(0, 240, 10, 0.70, VertLoc2, 0, TimeBetw, TimeBetw, 0.5, 0.15, -1);
	show_hudmessage(0,"ТОП %d^n%s^n%d место %d убийств %d смертей", PlrAmt, Name, statsm, Stats[0], Stats[1]);	

	if(statsm >= PlrAmt)
	{
		statsm = 0
		set_task(FullTime,"displayplr",0,"",0,"a",1);
	}
	else
	{
		set_task(TimeBetw,"displayplr",0,"",0,"a",1);
	}

	return PLUGIN_CONTINUE
}
