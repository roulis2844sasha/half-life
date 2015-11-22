#include <amxmodx>
#include <amxmisc>

#define PLUGIN "NickBlocker"
#define VERSION "0.2"
#define AUTHOR "s0u1"

new config[81],line,text[32],num,BlockedNicks[410][32],i

public plugin_init() {
	register_plugin("NickBlocker","0.1","s0u1")
}

public plugin_cfg() {
	get_configsdir(config,81)
	format(config,80,"%s/BlockedNicks.ini",config)
	
	if(file_exists(config)) {
	for(line=0;read_file(config,line,text,sizeof(text)-1,num);line++) {
		if(num>0) BlockedNicks[line]=text
		}
	}
	write_file(config,"",-1)
}

new nickname[32]
public client_putinserver(id) {
	get_user_name(id, nickname, sizeof(nickname)-1)
	for(i=0;i<line+1;i++) {
		if(containi(nickname,BlockedNicks[i])!=-1)
		server_cmd("kick #%d this nick name is blocked, please rename", get_user_userid(id))
	}
		
}

public client_infochanged(id) { 
	new oldname[32] 
	get_user_info(id, "name", nickname,31) 
	get_user_name(id,oldname,31)
	for(i=0;i<line;i++) {
		if(containi(nickname,BlockedNicks[i])!=-1)
		server_cmd("kick #%d this nick name is blocked, please rename", get_user_userid(id))
	}
}