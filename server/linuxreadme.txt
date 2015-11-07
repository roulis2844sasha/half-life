Linux README      5/01/03

Start the server by running ./hlds_run. After it has loaded, you are able to 
type commands into the server. During load time, you should see a message that 
says "WON Auth". This means that you are automatically registered on the 
Internet and people can start joining your game. 

If you don't see "WON Auth" but instead see "Auth Server", this means that 
you did not authenticate with the WON server either because you have an older
version of the server or you may not be able to reach the WON servers due to
a firewall or proxy.

After the server is loaded, you can set the number of allowed players with the 
maxplayers ("maxplayers 16") command. I would not recommend any more than
8 players on a 200mhz machine.

To start the maps, use the map command ("map cz2"). 

v3.1.1.1
--------
[5.01.03]

Changes/Additions:
------------------
- Added support for new Valve CD key system (uses outgoing UDP on port 27040).
- Added new GUI for Win32 dedicated server.  The new GUI is used as the default interface.  To start a dedicated server using the old console window, add "-console" to your command line.
- Changed so server.cfg is only executed once during server startup (not during every level change).
- Changed default network rate to match max rate allowed (went from 9999 to 20000), for LAN servers.
- Changed to use "\valve\valvecomm.lst".
- HLTV: New load balancing system.
- HLTV: Added client banning.
- HLTV: New administration commands: players, maxqueries, maxrate, bann, dispatchmode, publicgame, forcemaster, echo (see HLTV-Readme.txt)
- HLTV: Removed -bufferlength parameter.
- HLTV: Updated HLTV-Readme.txt file.
- HLTV: Updated hltv.cfg file.

New CVARS:
----------
- Added two new logaddress commands to the engine
     * "logaddress_add <IP> <port>" adds a new log address to the send list
     * "logaddress_del <IP> <port>" removes an existing entry from the send list
- Added "sv_log_onefile <0:1>" (default: 0) to determine whether one log file is created (total) or one log file for each map change, which is how it currently is.  The default is the current behavior (one for each map change).
- Added "sv_log_singleplayer <0:1>" (default: 0) to create a log file for single player games.  The default is off, which is the current behavior.
- Added "stats" command to view the data collected by "sv_stats".
- Added "sv_stats <0:1>" (default: 1) which determines whether or not to collect server stats (%CPU used, FPS, bandwidth's, etc.) from the server. (0 = off, 1 = on). Determining CPU usage takes a nontrivial amount of time, and needs to be done once per second (or so).
- Added "motd" command to view the MOTD in the server console.
- Added "motd_write <text>" command to write the given text to the motd.txt file. The character string "\n" is translated into newlines.
- Added rate limiting code to Out-Of-Band queries (i.e. players, info).
     * "max_queries_sec <queries>" (default: 0.5) defines max queries per second per user (averaged over max_queries_window)
     * "max_queries_sec_global <queries>" (default: 10) defines max queries per second for all queries
     * "max_queries_window <seconds>" (default: 30) defines time window to average query rates over
     * "sv_logblocks" (default: 0, 0=off, 1=on) logs which IP addresses have been blocked by this code
- Linux: Added "-tos" command line parameter to linux hlds binary.  This enables the LOWDELAY TOS header in the udp/ip packets the server generates.

Bug Fixes:
----------
- Fixed "sv_visiblemaxplayers" setting not working for info/details query response.
- Fixed the problem with running multiple servers on the same machine and having them communicate properly with the Ban Master server.  Servers now communicate with the Ban Master server on the server's game port (default is 27015).
- Fixed the Counter-Strike flashbang bug where the grenade would not always flash all of the players.
- Fixed the Counter-Strike server crash bug where players could buy items/weapons while using the "kill" command to drop them on the ground for other players to pickup.
- Fixed remote exploit bugs (Security Advisory VSA0304)
- HLTV: Fixed RCON.
- HLTV: Fixed status query handling.
- HLTV: Fixed missing player voices.



v3.1.1.0
--------
[6.12.02]

Changes/Additions:
------------------
- Ricochet included in this release.
- Added logging of the anti-cheat system catching and kicking detected cheats.
- Added logging of "kick" commands.
- Added logging of "banid" commands.
- Changed error message if clients try to download missing resources to be more helpful.
- Added new debug message for mod makers if a packet couldn't be parsed correctly.
- Changed 'exec' command now only works on .cfg and .rc files.
- Changed 'exec' command no longer allows ".." or "\\" or ":" in the filename.
- Linux: hlds_run now does auto-restart by default (to disable: define "-norestart" on the command line)
- Linux: hlds_run uses "exec" when you define the "-norestart" option.
- Linux: Added -pingboost command line parameter.  Currently supports three different methods ('-pingboost 
1', '-pingboost 2', and 'pingboost 3').  These may not work well (or at all) on some OS environments.
- Linux: Added "-debug" flag to hlds_run to automatically run gdb and pull out useful info.

New CVARS:
----------
- Added "serverversion", can be set to '1108' to view/re-record old demos.
- Added "sv_logbans" to turn the logging of player bans on and off.  Default is 0 (off).

Bug Fixes:
----------
- Fixed incorrect WonID logging.
- Fixed sv_allowdownload being required to be set to 1 for clients to connect to secure servers.
- Fixed 'bad address type' fatal error on servers that attempt to run in secure mode but have no DNS resolu
tion.
- Fixed DropClient messages for Steam clients who were banned or have a duplicate Steam ID to properly show
 the SteamID of the client.
- Fixed HLTV reporting wrong spectator numbers if connection to server was pending.
- Fixed "multicast 1" not working if it was issued before HLTV connected to game server.
- Fixed relay proxies reporting wrong spectator/slots numbers in multiplayer/LAN menu.
- Fixed DMC powerup bug where the invisibility ring would make people glow red.
- Fixed rcon bug in HLTV.
- Fixed delay being reset to default value during changelevel.
- Fixed a problem with propagating HLTV banners.
- Fixed bug using "exec <filename>" on large files (e.g. banned.cfg).
- Linux: Fixed server using 64 MB more memory than it needed to.
- Linux: Fixed 'undefined symbol: __strtouq_internal' on some Linux systems.
- Linux: Fixed segmentation fault on some Linux systems when attempting to run in secure mode.


v3.1.0.9
--------
[4.24.02]

- Added Anti-Cheat protection.
- User Interface redone for HLTV.
- Added cheering to HLTV.
- Muting a player in the scoreboard will also mute their text messages.
- Steam beta clients and non-Steam clients can play together on the same
server now.
- Voice communication uses DirectSound by default now.
- Added player ID to Half-Life DM.
- Added chat flood protection to HLDM.
- Added logging of fatal Sys_Error server shutdowns.
- Dedicated servers (Win32 + Linux) now default to 32MB heapsize.
- Improved dedicated server FPS (sys_ticrate) accuracy in Windows NT/2K/XP
and Linux.

New CVARS:
----------
"sv_send_logos"
when "sv_allowdownloads" is set to 1, this cvar will control whether
custom logos are propagated to clients
default: 1

"sv_send_resources"
when "sv_allowdownloads" is set to 1, this cvar will control whether
resources are propagated to clients
default: 1

Bug Fixes:
----------
- Fixed bogus \Save directory being created when you ran Half-Life.
- Fixed filter logic in the launcher.
- Fixed bug where clients couldn't connect to server side only MODs.
- Fixed bug where you could "kill" the HLTV entity in Half-Life DM.
- Fixed AddIP command.
- Fixed crash when a func_breakable triggers a trigger_counter.
- Fixed Egon gun beam problem in Half-Life DM.
- Fixed Tau cannon prediction problem.
- Fixed fog messing Additive sprites.
- Fixed Alien Grunts not making any attack sounds.
- Fixed Egon's beam looking yellow in sofware mode.
- Removed "friends" connectionless packet query.
- Fixed "bad address type" fatal server error (caused by clients with long
names).
- Fixed "condump" so the output won't overwrite previous files.
- Fixed "cvarlist" so the output won't overwrite previous files.
- Fixed rcon_port and rcon_address so they can be set manually by the
player to rcon a server.
- Fixed server shutdowns related to using bots.


v3.1.0.8
--------
[9.18.01]

Changes/Additions:
------------------
- Multicast spectator added.
- Voice communication added.
- Hardware survey in installer.
- Added server chat to logging.
- Redesigned multiplayer scoreboard.
- CapsLock key is now bindable.
- HLDM weapons now use client side prediction.

Bug Fixes:
----------
- Bunny hopping removed from HLDM, Counter-Strike, TFC, and DMC.
- Fixed banned.cfg problem with more than 1024 entries.
- Fixed screenshots overwriting each other.
- Buffer overflow exploit fixed.
- "condump", "cmdlist", and "cvarlist" only write out to the game directory.
- Fixed spy crouching bug in TFC.
- Fixed team switching grenade bug.
- Feigned spies do not show a weapon model.
- Sentry guns, Dispensers, and Detpacks cannot block doorways.
- Fixed "detstart"command
- Caltrops are being logged in TFC.
- Sentry gun and Dispensers are logged in TFC correctly.
- Switching to Spectator is now logged in TFC.
- "Tell" command is logged in TFC.
- Fixed Heavy Weapons Guy firing bug.
- Fixed medkit kill bug.
- Fixed Spy showing as a Scout in TFC.
- Fixed sounds looping in TFC when a player died.
- Fixed Quickstart crashing in the launcher.

Changes for the Linux Server in version 3.1.0.7:
- DMC included in this release.
- Remote file exploit fixed.

Changes for the Linux Server in version 3.1.0.6:
- rcon protocol overhauled to prevent attacks.
- Logging standard added for TFC, HLDM, and Counter-Strike.
- New 'stat' command that shows the same information as the 'status' command, but is formatted for the screen and log file.
- rcon "say" quotes problem fixed.
- Disguise5 will no longer crash a Team Fortress server.
- Class limits at -1 crash fix.
- Added code to support the server variable 'sv_allowupload'
- Increased number of entries for banned IPs and banned WON IDs to 32768 (each).
- Changed what types of map resource files can be downloaded using .res files (to help mod authors).  We've changed from what types of files ARE allowed to what types of files AREN'T allowed.
- Added motdfile command.  Use hlds +motdfile <motd file name> in the command line or in your server.cfg to change the motd.txt file displayed on your server.
- Added logsdir command. Use hlds +logsdir <log file directory> in the command line or in your server.cfg to change the directory relative to the game directory where log files will be stored.
- Changed servercfgfile command.  Use hlds +servercfgfile <name of server.cfg> in the command line to change the server.cfg file used by your server.
- Changed mapcyclefile command.  This can now be run from the command line.
- Added mp_chattime cvar to specify how long players can chat at the end of a map before it cycles.  Default set to 10 (in seconds).
- Added tfc_playerid command.  This will toggle what information players on your server will see in their status bar.
	0 - players see all names listed in the status bar (with appropriate
team colors)
	1- players only see names for their teammates and hostages in the
status bar
	2- players do not see any names in the status bar (hostages included)
0 is the default
- Added tfc_spectchat.  This toggles if spectators can talk to normal clients, or just other spectators.

Changes for the Linux Server in version 3.1.0.5:

- Added a new TFC server cvar, tfc_spectchat, that will allow the server to regulate whether or not spectators can chat with players in the game.  When set to 0, spectators can only chat with other spectators.  When set to anything but 0, spectators can chat with everyone in the game.
- Merged a bit of missing code between versions 1.1.0.1 and 1.1.0.4
- Fixed "ERROR: SZ_GetSpace: overflow without FSB_ALLOWOVERFLOW set" crashing servers
- Fixed "ERROR: Dormant entity player is thinking!!" crashing servers
- Problem with fragmentation & reassembly of packets.
- Fixed the rcon 'say' command putting " " around every token
- Fixed small memory leak problem when using bots
- Put client's IP address back into the 'status' command
- If a player suicides (types "kill" in the console) while infected, the medic who infected him will get a kill.
- If a player changes teams while infected, the medic who infected him will get a kill.
- Fixed a bug where players could teamkill by shooting a rocket/grenade at a teammate and switching to specator mode.
- Fixed the "adm_deal", "adm_next", and "next" commands to properly cycle through the players in the server.
- Fixed the problem with some clients lagging for a round or two at the beginning of a map.
- Fixed the "listmaps" command so it displays all the maps (it was skipping the last one in the list).
- Fixed the problem with some entities not being reset correctly (i.e. on the map de_foption: could kill the terrorist team at the beginning of a round with a lightning strike).

Changes for the Linux Server in version 3.1.0.4:

- This update contains three new TF maps: Avanti, Flagrun, and Casbah.
- Pyro's burn damage increased in Team Fortress.
- Heavy Weapons Guy's chaingun damage reduced.
- All map resources can be downloaded from the game server now.  Refer to readme.txt for details.
- Anti-grenade triggers added to 2Fort spawn rooms.
- Team selection also available from class selection screen in Team Fortress.
- In-Game text upgraded.
- Last weapon used key persists over a player death now.
- Counter-Strike proxy cheat fixed.
- High framerate connection problem fixed.
- Cockroaches can now be killed in single player.
- 'Tell' command crash fixed in Team Fortress.
- Rcon buffer overflow fixed.

Changes for the Linux Server in version 3.1.0.3:

- Fixed spy burrowing into the ground.
- Fixed svc_bad connection problem.
- Fixed spy disguise as team 3/4 on two team maps.
- Fixed spy disguise crash.

Changes for the Linux Server in version 3.1.0.2:

- Fixed crash when clients have specific characters in their names.
- Fixed stout buffering problem.

Changes for the Linux Server in version 3.1.0.1:

- Fixed performance problem on ATI Rage video cards.
- Fixed 'Unassigned' in scoreboard bug.
- Fixed death messages being delayed when downloading a custom decal.
- Fixed 'Out of Handles' crash on dedicated server.
- Fixed bug where player models would be drawn incorrectly in Team Fortress 1.5
- Fixed fakelag exploit.
- Fixed mmx optimization.
- Restart command fixed on dedicated server.
- Fixed two flags in Dustbowl bug.
- Fixed longjump in Half-Life DM.
- Fixed spectator grenade exploit.
- Fixed changeteam grenade exploit.
- Fixed LoGADDRESS command.
 
Changes for the Linux Server in past versions:

- This update includes a complete rewrite of Half-Life's networking system.
- Three new maps included (Dustbowl, Epicenter, and Warpath).
- Engineer upgrades sentry gun immediately.
- Dispensers can be used by touching them.
- Spectator mode added.
- Number pad keys are now bindable independent.
- Support for mouse buttons 4 and 5.
- You will get a point in TFC for destroying an enemy sentry gun.
- Engineer can view other Engineer's sentry gun stats via HUD.
- Tell command added to TFC.
- The class of everyone on your team is available via the scoreboard.
- Grenade timer added to TFC.
- Updated netgraph, use net_graph 3
- TFC Manual updated with all information pertaining to this update.
- Console and in-game chat uses a True Type font.
- Player names are colored according to team in TFC when talking.
- MOTD length increased for server operators.
- "Say" no longer includes the server name in the 64 character limit.
- Various crash fixes.
- readline.so no longer required.
- Team 4 can now score on 4 player TFC maps.
- Fixed soldier's nail grenades in TFC.
- We are changing the version number of the server from 1.x.x.x to 3.x.x.x for 
  the Linux server to differentiate between the server and client releases.
- Typing 'version' at the server console will give you the version you are running.
- Server now allows banning by userid and WON id.  Refer to TFCServer.htm 
  located in your \halflife\tfc\manual directory.
- HTML TFC manual included with 3.0.1.3 Linux server with information on running a server.
- TFStats for Linux will be released in the very near future.
- TF Stats version 1.5 for Linux included.
- Half-Life setinfo bug fixed.
- Added better debugging code for TFC map makers.
- Fixed bug in trigger_changelevel.


Common Questions:

1) I start the server and nothing happens. 

After running ./hlds_l, you need to set the number of allowed players (see above) 
and start a map. You can do all of this from the command line as well:

./hlds_l -game tfc +maxplayers 16 +map cz2 


2) How do I start a TFC server?

Use the -game tfc option.

3) My server won't run, it's looking for:

a) libhlwon.so - see above.
b) readline.so - this is no longer needed. You have an old version of the server.

4) How do I start a lan server?

./hlds -nomaster +sv_lan 1

5) Where can I get help?

Subscribe to the one of our dedicated server mailing lists.  For more info,
visit our mailing list web site:

http://list.valvesoftware.com/mailman/listinfo

Also, there are several user-run support sites on the net:

http://server.counter-strike.net/
http://commands.halflife.org
http://www.pcgame.com/randy/tfc/console/all.htm
http://www.planethalflife.com/commands/

6) What are the server commands/cvars:

changelevel mapname - change map, maintain client connections
map mapname - change map, disconnect currently connected players
status - return the status of the server
restart - restart the server
exec file.cfg - execute a script file
quit - stop the server


Client Variables

cl_bob		Default:  0
cl_bobcycle	Default:  0
cl_bobup	Default:  0
cl_rollangle	Default:  2
cl_waterdist	Default:  4
cl_rollspeed	Default:  200


Multiplayer Variables

1 means on/allowed, 0 means off/disallowed.  
* means any integer is acceptable, 0 means no limit

mp_autocrosshair		Default:  1
mp_falldamage		Default:  1
mp_flashlight		Default:  0
mp_footsteps		Default:  1
mp_forcerespawn		Default:  1
mp_friendlyfire		Default:  0
mp_teamplay			Default:  0
mp_weaponstay		Default:  0
mp_allowmonsters		Default:  0
mp_fraglimit*		Default:  0
mp_timelimit*		Default:  0


Server Variables

sv_accelerate		Default:  10
sv_aim			Default:  1
sv_airaccelerate		Default:  10
sv_airmove			Default:  1
sv_allowdownload		Default:  1
sv_allowupload		Default:  1
sv_bounce			Default:  1
sv_challengetime		Default:  15
sv_cheats			Default:  0
sv_clienttrace		Default:  1
sv_clipmode			Default:  0
sv_friction			Default:  4
sv_gravity			Default:  800
sv_idealpitchscale	Default:  0
sv_language			Default:  0
sv_masterprint		Default:  1
sv_masterprinttime	Default:  5
sv_maxspectators		Default:  8
sv_maxspeed			Default:  320
sv_maxvelocity		Default:  2000
sv_netsize			Default:  0
sv_newunit			Default:  0
sv_password			Default:  0
sv_showcmd			Default:  0
sv_skyname			Default:  0
sv_spectalk			Default:  1
sv_spectator_password	Default:  0
sv_spectatormaxspeed	Default:  500
sv_stepsize			Default:  18
sv_stopspeed		Default:  100
sv_timeout			Default:  65
sv_upload_maxsize		Default:  0
sv_wateraccelerate	Default:  10
sv_wateramp			Default:  0
sv_waterfriction		Default:  1
sv_zmax			Default:  4096


Team Play Variables

team1_color		Default:  0  
team1_model		Default:  0  
team1_name		Default:  0  
team1_skin		Default:  0  
team2_color		Default:  0  
team2_model		Default:  0  
team2_name		Default:  0  
team2_skin		Default:  0  


brightness		Default:  0
chase_active	Default:  0
chase_back		Default:  100
chase_right		Default:  0
chase_up		Default:  16
clientport		Default:  27005
cmdline		Default:  0
con_notifytime	Default:  1
coop			Default:  0
crosshair		Default:  0
deathmatch		Default:  1
decalfrequency	Default:  30
developer		Default:  0
direct		Default:  0
displaysoundlist	Default:  0
edgefriction	Default:  2
fakelag		Default:  0
fakeloss		Default:  0
filterban		Default:  1
fps_lan		Default:  72
fps_modem		Default:  30
fps_single		Default:  72
gamma			Default:  2
host_framerate	Default:  0
host_killtime	Default:  0
host_speeds		Default:  0
HostMap		Default:  0
hostname		Default:  0
hostport		Default:  0
ip			Default:  0
ip_clientport	Default:  0
ip_hostport		Default:  0
ipx_clientport	Default:  0
ipx_hostport	Default:  0
lambert		Default:  1
lcd_x			Default:  0
lcd_yaw		Default:  0
lightgamma		Default:  2
mapcyclefile	Default:  0
netchokeloop	Default:  0
noip			Default:  0
noipx			Default:  1
pausable		Default:  1
pm_pushfix		Default:  0
port			Default:  27015
r_netgraph		Default:  0
rcon_password	Default:  0
registered		Default:  0
scr_ofsx		Default:  0
scr_ofsy		Default:  0
scr_ofsz		Default:  0
serverprofile	Default:  0
showdrop		Default:  0
showpackets		Default:  0
showtriggers	Default:  0
skill			Default:  1
sys_ticrate		Default:  0
texgamma		Default:  2
violence_ablood	Default:  1
violence_agibs	Default:  1
violence_hblood	Default:  1
violence_hgibs	Default:  1


View Variables

v_centermove	Default:  0
v_centerspeed	Default:  500
v_dark		Default:  0
v_idlescale		Default:  0
v_ipitch_cycle	Default:  1
v_ipitch_level	Default:  0
v_iroll_cycle	Default:  0
v_iroll_level	Default:  0
v_iyaw_cycle	Default:  2
v_iyaw_level	Default:  0
v_kickpitch		Default:  0
v_kickroll		Default:  0
v_kicktime		Default:  0



7) I am behind a firewall.  What ports need to be opened for hlds?
 
Incoming UDP to local destination 27015.
Outgoing UDP to remote destination 27010, 27012, 27040.
Outgoing TCP to remote destination 7002.


8) What environment are the hlds_l binaries built in?

The hlds_l binaries are built on a SuSE 6.1 installation and linked
against glibc 2.0.7.  rpm -qf /lib/libc.so.6 shows that the library
comes from the package shlibs-99.4.14-1, which has the following
details:

Name        : shlibs
Distribution: SuSE Linux 6.1 (i386)
Version     : 99.4.14
Vendor      : SuSE GmbH, Nuernberg, Germany
Release     : 1
Build Date  : Fri Apr 30 12:37:45 1999
Install date: Tue Jan 23 18:40:38 2001
Build Host  : fatou.suse.de
Group       : unsorted
Source RPM  : libc-99.4.14-1.src.rpm
Size        : 8185636
License     : Copyright (C) 1992, 93, 94, 95, 96, 97, 98, 99 Free Software
Foundation, Inc.
Packager    : feedback@suse.de


====


Please report any problems to linux@valvesoftware.com

Enjoy!


