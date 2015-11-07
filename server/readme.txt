Half-Life Dedicated Server (Steam) Update Tool
[4.07.05]

HldsUpdateTool is an application that will update an existing Half-Life 
Dedicated Server installation to the latest version or will download the 
latest version (from scratch) if an existing version is not found. 
To save time/bandwidth downloading files, it's better to install 
HldsUpdateTool into the root folder of an existing Half-Life Dedicated 
Server installation.


Installation
------------

1) Creating an account

It is no longer necessary to have a Steam account to use this tool. 

2) Getting the latest version of the Dedicated Server

To download the latest version of the dedicated server to your machine:

	a) Open a command prompt.

	b) Change to the directory where the HLDS Update Tool is installed.

	c) Run the HLDS Update Tool with the "update" command:

		>HldsUpdateTool.exe -command update -game <game> -dir <installdir>

		<game>		"cstrike", "dmc", "dod", "ricochet", "tfc", "valve", "Counter-Strike Source", or "hl2mp"

		<installdir> 	is the path where you want the files installed
					e.g. . (for the current directory) or c:\hlserver

		e.g.
		>HldsUpdateTool.exe -command update -game cstrike -dir .

		or 

		>HldsUpdateTool.exe -command update -game cstrike -dir c:\hlserver

		(NOTE: that will be ./steam instead of HldsUpdateTool.exe for 
		Linux users)

	d) Steam remembers the options you use, so when you need to update 
	   next time you only need to run:

		>HldsUpdateTool.exe -command update <game>

	e) You can also install multiple copies of the server by specifying a 
	   different <installdir>.

	f) Half-Life mods (eg cstrike, dod) and Source mods (eg hl2mp) must 
           be installed to separate directories


3) Updating your Dedicated Server

If your dedicated server becomes out-of-date you will see the following 
message in your server console and in the server log:

	"Your server needs to be restarted in order to receive the latest update."

To update, stop your dedicated server and run the update commands described 
in Section 2 (above).

4) Help

To see this info and info about other options of the tool, run it with "-?" 
and it will print them on the screen.

About Steam
-----------
Steam is a broadband business platform for direct software delivery and 
content management. At its core, Steam is a distributed file system and 
shared set of technology components that can be implemented into any 
software application.


Privacy
-------
Valve respects the privacy of its users. The details of our privacy policy 
can be viewed at:

	http://www.valvesoftware.com/privacy.htm


FAQ
---
1) Q: No one is connecting to my server/I get errors when I try to connect to 
      my server.

   A: Run the HLDS Update Tool with the "update" command to make sure you 
      have the most recent version.


2) Q: When I first run the HldsUpdateTool I see a message about "Could not 
      create file: Permission denied".  What's wrong?

   A: The HldsUpdateTool has the ability to auto-update itself, but to do 
      this it must be able to overwrite itself. Make sure the Windows user 
      you're logged-in as has permission to overwrite the "HldsUpdateTool" 
      executable.


3) Q: Where can I get help?

   A: Join the Steampowered forums or one of the Valve Server Admin Mailing 
      lists:

	http://www.steampowered.com/forums

	http://list.valvesoftware.com/mailman/listinfo



