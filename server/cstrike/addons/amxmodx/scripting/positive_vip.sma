    #include <amxmodx>
    #include <amxmisc>
    #include <cstrike>
    #include <fun>
    #include <hamsandwich>

static const COLOR[] = "^x04" //green
static const CONTACT[] = ""
new maxplayers
new gmsgSayText

    public plugin_init()
    {
        register_plugin("Admins VIP", "1.0", "UNREAL")
        register_event("ResetHUD", "ResetHUD", "be")
	
	//
	maxplayers = get_maxplayers()
	gmsgSayText = get_user_msgid("SayText")
	register_clcmd("say", "handle_say")
	register_cvar("amx_contactinfo", CONTACT, FCVAR_SERVER)
	
	//
    }

    public ResetHUD(id)
    {
        set_task(0.5, "VIP", id + 6910)
        return PLUGIN_CONTINUE
    }

    //
    public handle_say(id) {
	new said[192]
	read_args(said,192)
	if( ( containi(said, "who") != -1 && containi(said, "admin") != -1 ) || contain(said, "/vip") != -1 )
		set_task(0.1,"print_adminlist",id)
	return PLUGIN_CONTINUE
}

public print_adminlist(user) 
{
	new adminnames[33][32]
	new message[256]
	new contactinfo[256], contact[112]
	new id, count, x, len
	
	for(id = 1 ; id <= maxplayers ; id++)
		if(is_user_connected(id))
			if(get_user_flags(id) & ADMIN_LEVEL_H)
				get_user_name(id, adminnames[count++], 31)

	len = format(message, 255, "%s V.I.P: ОНЛАЙН: ",COLOR)
	if(count > 0) {
		for(x = 0 ; x < count ; x++) {
			len += format(message[len], 255-len, "%s%s ", adminnames[x], x < (count-1) ? ", ":"")
			if(len > 96 ) {
				print_message(user, message)
				len = format(message, 255, "%s ",COLOR)
			}
		}
		print_message(user, message)
	}
	else {
		len += format(message[len], 255-len, "НЕТ V.I.P ОНЛАЙН")
		print_message(user, message)
	}
	
	get_cvar_string("amx_contactinfo", contact, 63)
	if(contact[0])  {
		format(contactinfo, 111, "%s Контакт администратора -- %s", COLOR, contact)
		print_message(user, contactinfo)
	}
}

print_message(id, msg[]) {
	message_begin(MSG_ONE, gmsgSayText, {0,0,0}, id)
	write_byte(id)
	write_string(msg)
	message_end()
}

    //
    
    public VIP(id)
    {
        id -= 6910
        

    if (get_user_flags(id) & ADMIN_LEVEL_H)
        {
            message_begin(MSG_ALL, get_user_msgid("ScoreAttrib"))
            write_byte(id)
            write_byte(4)
            message_end()
            give_item(id,"weapon_hegrenade")
            give_item(id,"weapon_flashbang")
            give_item(id,"weapon_flashbang")
            give_item(id,"weapon_smokegrenade")
            give_item(id,"item_assaultsuit")
            give_item(id, "weapon_deagle")
            give_item(id, "ammo_50ae")
            give_item(id, "ammo_50ae")
            give_item(id, "ammo_50ae")
            give_item(id, "ammo_50ae")
            give_item(id, "ammo_50ae")
            cs_set_user_money(id, min(cs_get_user_money(id) + 500, 16000))
        }
        return PLUGIN_HANDLED
    } 
