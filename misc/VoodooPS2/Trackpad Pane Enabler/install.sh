#!/bin/bash

if [ -d /Users/$USER/Desktop/Install\ Trackpad/  ] ; then 
:
else
echo "The folder 'Install Trackpad' must be on the desktop." && exit 2
fi

sudo echo || exit 2

pri ()
{
# Preparando el entorno
sudo rm -rf /System/Library/PreferencePanes/Trackpad.prefPane /usr/bin/VoodooPS2Daemon /Library/LaunchDaemons/org.rehabman.voodoo.driver.Daemon.plist  ~/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.trackpad.plist ~/Library/Preferences/com.apple.AppleMultitouchTrackpad.plist ~/Library/Preferences/.GlobalPreferences.plist
if [ -d /System/Library/Extensions/AppleACPIPS2Nub.kext  ] ; then
sudo mv /System/Library/Extensions/AppleACPIPS2Nub.kext /System/Library/Extensions/AppleACPIPS2Nub.bak
fi
if [ -d /System/Library/Extensions/ApplePS2Controller.kext  ] ; then
sudo mv /System/Library/Extensions/ApplePS2Controller.kext /System/Library/Extensions/ApplePS2Controller.bak
fi
}

seg ()
{
# Instalando el Trackpad
sudo cp -r /Users/$USER/Desktop/Install\ Trackpad/Trackpad.prefPane /System/Library/PreferencePanes/ && sudo xattr -c -r /System/Library/PreferencePanes/Trackpad.prefPane && sudo chown -R root:wheel /System/Library/PreferencePanes/Trackpad.prefPane
}

ter ()
{
# Instalando Demonios
sudo cp /Users/$USER/Desktop/Install\ Trackpad/RehabMan-Voodoo-*/org.rehabman.voodoo.driver.Daemon.plist /Library/LaunchDaemons && sudo cp /Users/$USER/Desktop/Install\ Trackpad/RehabMan-Voodoo-*/Release/VoodooPS2Daemon /usr/bin && sudo xattr -c -r /usr/bin/VoodooPS2Daemon && sudo chmod 755  /usr/bin/VoodooPS2Daemon && sudo chown root:wheel /usr/bin/VoodooPS2Daemon && sudo xattr -c -r /Library/LaunchDaemons/org.rehabman.voodoo.driver.Daemon.plist && sudo chmod 644  /Library/LaunchDaemons/org.rehabman.voodoo.driver.Daemon.plist && sudo chown root:wheel /Library/LaunchDaemons/org.rehabman.voodoo.driver.Daemon.plist
}

cua ()
{
# Habilitar toque y arrastrar
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -int 1
defaults write com.apple.AppleMultitouchTrackpad Dragging -int 1
}

for tarea in pri seg ter cua
do
	
spin[0]=' |'
spin[1]=' \'
spin[2]=' -'
spin[3]=' /'

$tarea &
pid=$!

trap "kill $pid 2> /dev/null" EXIT

while kill -0 $pid 2> /dev/null; do
for i in "${spin[@]}"
do
    echo -ne "$i \r"
    sleep .1
done
done

trap - EXIT
done
echo -e "Task completed successfully, install the Release kext with KextWizard and restart. \n"

#ls -l /System/Library/PreferencePanes/
#ls -l /usr/bin/
#ls -l /Library/LaunchDaemons/
#ls -l /System/Library/Extensions
