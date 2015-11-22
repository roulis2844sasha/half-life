#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>
#include <xs>

#define PLUGIN	"Block WallHack"
#define AUTHOR	"OT"
#define VERSION	"1.0"

#define GENERAL_X_Y_SORROUNDING 16.5 		// 18.0
#define CONSTANT_Z_CROUCH_UP 31.0 			// 32.0
#define CONSTANT_Z_CROUCH_DOWN 18.0 		// 18.0
#define CONSTANT_Z_STANDUP_UP 35.0 			// 36.0
#define CONSTANT_Z_STANDUP_DOWN 36.0 		// 36.0

new const Float:possibilities[8][3] = 
{
	{-GENERAL_X_Y_SORROUNDING, -GENERAL_X_Y_SORROUNDING, -CONSTANT_Z_STANDUP_DOWN},
	{ GENERAL_X_Y_SORROUNDING, -GENERAL_X_Y_SORROUNDING, -CONSTANT_Z_STANDUP_DOWN},
	{-GENERAL_X_Y_SORROUNDING,  GENERAL_X_Y_SORROUNDING, -CONSTANT_Z_STANDUP_DOWN},
	{-GENERAL_X_Y_SORROUNDING, -GENERAL_X_Y_SORROUNDING,  CONSTANT_Z_STANDUP_UP},
	{-GENERAL_X_Y_SORROUNDING,  GENERAL_X_Y_SORROUNDING,  CONSTANT_Z_STANDUP_UP},
	{ GENERAL_X_Y_SORROUNDING, -GENERAL_X_Y_SORROUNDING,  CONSTANT_Z_STANDUP_UP},
	{ GENERAL_X_Y_SORROUNDING,  GENERAL_X_Y_SORROUNDING, -CONSTANT_Z_STANDUP_DOWN},
	{ GENERAL_X_Y_SORROUNDING,  GENERAL_X_Y_SORROUNDING,  CONSTANT_Z_STANDUP_UP}
}
new const Float:c_possibilities[8][3] = 
{
	{-GENERAL_X_Y_SORROUNDING, -GENERAL_X_Y_SORROUNDING, -CONSTANT_Z_CROUCH_DOWN},
	{ GENERAL_X_Y_SORROUNDING, -GENERAL_X_Y_SORROUNDING, -CONSTANT_Z_CROUCH_DOWN},
	{-GENERAL_X_Y_SORROUNDING,  GENERAL_X_Y_SORROUNDING, -CONSTANT_Z_CROUCH_DOWN},
	{-GENERAL_X_Y_SORROUNDING, -GENERAL_X_Y_SORROUNDING,  CONSTANT_Z_CROUCH_UP},
	{-GENERAL_X_Y_SORROUNDING,  GENERAL_X_Y_SORROUNDING,  CONSTANT_Z_CROUCH_UP},
	{ GENERAL_X_Y_SORROUNDING, -GENERAL_X_Y_SORROUNDING,  CONSTANT_Z_CROUCH_UP},
	{ GENERAL_X_Y_SORROUNDING,  GENERAL_X_Y_SORROUNDING, -CONSTANT_Z_CROUCH_DOWN},
	{ GENERAL_X_Y_SORROUNDING,  GENERAL_X_Y_SORROUNDING,  CONSTANT_Z_CROUCH_UP}
}

new ducking[33]

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_cvar("wallblocker_version", VERSION, FCVAR_SPONLY | FCVAR_SERVER)
	
	register_forward(FM_AddToFullPack, "fw_addtofullpack")
	register_forward(FM_PlayerPreThink, "fw_prethink")
}

public fw_prethink(id)
{
	if (!is_user_alive(id))
		ducking[id] = false
	
	if (pev(id, pev_flags) & FL_DUCKING)
		ducking[id] = true
	else
		ducking[id] = false
	
	return FMRES_IGNORED
}

public fw_addtofullpack(es, e, ent, host, flags, player, set)
{
	if (player && host != ent )
	{
		// If engine says it cannot be seen do not send to client
		if	(!engfunc(EngFunc_CheckVisibility,ent, set))
		{
			forward_return(FMV_CELL, 0)
			return FMRES_SUPERCEDE
		}
		
#if !defined _hamsandwich_included
		static Float:origin[3], Float:start[3], Float:end[3], Float:addict[3]
		
		pev(host, pev_origin, origin)
		pev(host, pev_view_ofs, start)
		
		xs_vec_add(start, origin, start)
		
		pev(ent, pev_origin, origin)
		
		// If origin is visible don't do anything
		if (is_point_visible(start, origin, host))
			return FMRES_IGNORED
		
		// We check if player is ducked, and if he is we use the crouch possibilities
		if (ducking[ent])
			for (new i=0;i<16;i++)
			{
				if (i >= 8)
				{
					xs_vec_mul_scalar(c_possibilities[i-8], 0.5, addict)
					xs_vec_add(addict, origin, end)
				}
				else
				{
					xs_vec_add(c_possibilities[i], origin, end)
				}
				
				// If seen we ignore everything
				if (is_point_visible(start, end, host))
					return FMRES_IGNORED
			}
		else
			for (new i=0;i<16;i++)
			{
				if (i >= 8)
				{
					xs_vec_mul_scalar(possibilities[i-8], 0.5, addict)
					xs_vec_add(addict, origin, end)
				}
				else
				{
					xs_vec_add(possibilities[i], origin, end)
				}
				
				// If seen we ignore everything
				if (is_point_visible(start, end, host))
					return FMRES_IGNORED
			}
#else
		static Float:origin[3], Float:end[3]
	
		pev(ent, pev_origin, origin)
		
		// If origin is visible don't do anything
		if (is_point_visible(host, origin))
			return FMRES_IGNORED
		
		// We check if player is ducked, and if he is we use the crouch possibilities
		if (ducking[ent])
			for (new i=0;i<16;i++)
			{
				if (i >= 8)
				{
					xs_vec_mul_scalar(c_possibilities[i-8], 0.5, end)
					xs_vec_add(end, origin, end)
				}
				else
				{
					xs_vec_add(c_possibilities[i], origin, end)
				}
				
				// If seen we ignore everything
				if (is_point_visible(host, end))
					return FMRES_IGNORED
			}
		else
			for (new i=0;i<16;i++)
			{
				if (i >= 8)
				{
					xs_vec_mul_scalar(possibilities[i-8], 0.5, end)
					xs_vec_add(end, origin, end)
				}
				else
				{
					xs_vec_add(possibilities[i], origin, end)
				}
				
				// If seen we ignore everything
				if (is_point_visible(host, end))
					return FMRES_IGNORED
			}
#endif
		
		// the player cannot be seen so we block the send channel
		forward_return(FMV_CELL, 0)
		return FMRES_SUPERCEDE
	}
	
	return FMRES_IGNORED
}

#if !defined _hamsandwich_included
bool:is_point_visible(const Float:start[3], const Float:point[3], ignore_ent)
{
	engfunc(EngFunc_TraceLine, start, point, IGNORE_GLASS, ignore_ent, 0);

	static Float:fraction;
	get_tr2(0, TR_flFraction, fraction);
	if (fraction == 1.0)
		return true;

	return false;
}
#else
bool:is_point_visible(start_ent, const Float:point[3])
{
	return bool:ExecuteHam(Ham_FVecVisible, start_ent, point)
}

#endif