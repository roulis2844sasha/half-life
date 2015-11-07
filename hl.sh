#!/bin/bash
sudo mkdir -p /opt/hl/
sudo chmod 777 /opt/hl/
cd /opt/hl/
echo -n 'Install Half-Life? [y/N] '
read res
if [ "$res" == "y" ]; then
	res="n"
	ARCH=`uname -m`
	if [ "$ARCH" == "x86_64" ]; then
		wget https://launchpadlibrarian.net/201289903/libgcrypt11_1.5.3-2ubuntu4.2_i386.deb
		sudo dpkg -i libgcrypt11_1.5.3-2ubuntu4.2_i386.deb
		sudo apt-get install libopenal1:i386 libnss3:i386 subversion -y
	fi
	svn checkout https://github.com/roulis2844sasha/half-life/trunk/core
	mv /opt/hl/core /opt/hl/game
	chmod +x /opt/hl/game/hl_linux
	chmod +x /opt/hl/game/hl.sh
	echo "[Desktop Entry]
	Name=Half-Life
	Path=/opt/hl/game/
	Exec=/opt/hl/game/hl.sh
	Icon=/opt/hl/game/valve/game.icns
	Terminal=false
	Type=Application
	Categories=Game;" >  ~/.local/share/applications/half-life.desktop
	chmod +x ~/.local/share/applications/half-life.desktop
	echo -n 'Install Half-Life? [y/N] '
	read res
	if [ "$res" == "y" ]; then
		res="n"
		svn checkout https://github.com/roulis2844sasha/half-life/trunk/cs
		mv /opt/hl/cs /opt/hl/game
		chmod +x /opt/hl/game/cs.sh
		chmod +x /opt/hl/game/czero.sh
		echo "[Desktop Entry]
		Name=Counter-Strike
		Path=/opt/hl/game/
		Exec=/opt/hl/game/cs.sh
		Icon=/opt/hl/game/cstrike/game.icns
		Terminal=false
		Type=Application
		Categories=Game;" >  ~/.local/share/applications/counter-strike.desktop
		chmod +x ~/.local/share/applications/counter-strike.desktop
	fi
fi
echo -n 'Install server Counter-Strike? [y/N] '
read res
if [ "$res" == "y" ]; then
	res="n"
	svn checkout https://github.com/roulis2844sasha/half-life/trunk/server
	chmod +x /opt/hl/server/hlds_amd
	chmod +x /opt/hl/server/hlds_i486
	chmod +x /opt/hl/server/hlds_i686
	chmod +x /opt/hl/server/hlds_run
	chmod +x /opt/hl/server/hldsupdatetool.bin
	chmod +x /opt/hl/server/hltv
	chmod +x /opt/hl/server/start.sh
	chmod +x /opt/hl/server/steam
	chmod +x /opt/hl/server/stop.sh
fi
