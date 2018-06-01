#!/bin/sh
. /etc/rc.common

kill_item()
{
	process_name="$1"
	#echo "\n[kill_item]:: $process_name"
	pid=$(ps -A | grep "$process_name" |grep -v grep| awk '{print $1}')
	if [ "$pid" ]; then
		#echo "\tkillall::$process_name"
		sudo killall -c "$process_name"
	fi
}

remove_file()
{
	file_name="$1"
	#echo "\n[remove_file]:: $file_name"
	if [ -e "$file_name" ]; then
		#echo "\trm::$file_name"
		sudo rm -rf "$file_name"
	fi
}

remove_directory()
{
	dir_name="$1"
	#echo "\n[remove_directory]:: $dir_name"
	if [ -d "$dir_name" ]; then
		#echo "\trm_dir::$dir_name"
		sudo rm -rf "$dir_name"
	fi
}

unload_driver()
{
	kext_name="$1"
	bundle_id=com.realtek.driver.$1
	#echo "\n[unload_driver]:: $bundle_id"

	index=$(kextstat -b $bundle_id |grep $bundle_id | awk '{print $1}')
	if [ "$index" ]; then
		#echo "\tkextunload::$kext_name"
		#sudo kextunload -c "$kext_name"

		if [ -e "/System/Library/Extensions/$kext_name.kext" ]; then
			sudo kextunload "/System/Library/Extensions/$kext_name.kext"
			sleep 2
		fi

		if [ -e "/Library/Extensions/$kext_name.kext" ]; then
			sudo kextunload "/Library/Extensions/$kext_name.kext"
			sleep 2
		fi

	fi
}

remove_wildcard_file()
{
	wildcard_file=$1
	#echo "\n[remove_wildcard_file]:: $wildcard_file"
	for efile in $wildcard_file ; do
		#echo "\tefile: $efile"
		sudo rm -rf "$efile"
	done
}

mydir="$(dirname "$BASH_SOURCE")"
if [ "$mydir" == "/tmp" ]; then
	echo  "\n\n\033[41;37m Uninstall Wireless Network Utility ? ... [Y/y]:Yes\033[0m"
	read result
	if [ "$result" == "" ]; then
		exit
	fi

	if [ "$result" != "Y" ] && [ "$result" != "y" ]; then
		exit
	fi

else
	echo "\nPlease type the password of \"root\" to Uninstall"
fi

FROM=`dirname "$0"`

echo "\nPhase1: Terminate Utility"
kill_item "Wireless-AC Network Utility"
kill_item "Wireless Network Utility"
kill_item "TP-LINK Wireless Configuration Utility"
kill_item "BearExtender"
kill_item "wpa_supplicant"
kill_item "StatusBarApp"
sleep 2

echo "Phase2: System Information"

UnPreference="/Library/Application Support/WLAN/StatusBarApp.app/Contents/MacOS/UnPref"
if [ -e "$UnPreference" ]; then
	#sudo "$UnPreference" >> /tmp/2.txt
	sudo "$UnPreference"
fi

echo "Phase3: Remove Utility Related"

# Wlan.Software / WlanAC104.Software / WlanAC.Software / Wlan104.Software
remove_wildcard_file "/Library/LaunchAgents/Wlan*.Software"

remove_file "/Library/LaunchAgents/WlanAC.plist"
remove_file "/Library/LaunchAgents/Wlan.Software.plist"

remove_wildcard_file "/Users/*/Library/Preferences/com.realtek.*"
remove_wildcard_file "/Users/*/Library/Preferences/StatusBarApp.plist"
remove_directory "/Library/Application Support/WLAN"
	
# Legacy Utility
remove_directory "/System/Library/CoreServices/StatusBarApp.app"
remove_directory "/Applications/Wireless-AC Network Utility.app"
remove_directory "/Applications/Wireless Network Utility.app"
remove_directory "/Applications/TP-LINK Wireless Configuration Utility.app"
remove_directory "/Applications/BearExtender.app"

echo "Phase4: Remove Install Log"
remove_wildcard_file "/private/var/db/receipts/com.realtek.*"
remove_wildcard_file "/private/var/db/receipts/com.Wlan.*"
remove_wildcard_file "/private/var/db/receipts/com.wlan.*"
remove_wildcard_file "/private/var/db/receipts/com.Wireless*.*"
remove_wildcard_file "/private/var/db/receipts/com.*Utility*.pkg.*"
remove_wildcard_file "/private/var/db/receipts/com.*StatusBarApp.*"
remove_wildcard_file "/private/var/db/receipts/com.*StartUp.pkg.*"
remove_wildcard_file "/private/var/db/receipts/com.*Driver*.pkg.*"
remove_wildcard_file "/private/var/db/receipts/com.UnPref.*"
remove_wildcard_file "/private/var/db/receipts/com.BearExtender.*"
remove_wildcard_file "/private/var/db/receipts/com.bearextenderturbo.*"


echo "Phase5: Removing Driver"

unload_driver "RtWlanU1827"
unload_driver "RtWlanU"
unload_driver "RTL8812AU"
unload_driver "RTL8192SU"
unload_driver "RTL8192CU"
unload_driver "RTL8188EU"
unload_driver "RTL8192EU"
unload_driver "RTL8192DU"
unload_driver "RTL8723BU"

#RtWlanU.kext / RtWlanU1827.kext / RtWlanU_192.kext
remove_wildcard_file "/System/Library/Extensions/RtWlanU*.kext"

#RTL8192SU* / RTL8192CU* / RTL8192DU* / RTL8188EU* / 
#RTL8192EU* / RTL8723BU* / RTL8812AU*
remove_wildcard_file "/System/Library/Extensions/RTL8*.kext"

#For BearExtender
remove_wildcard_file "/Library/Extensions/RTL8812AU*.kext"


version=$( /usr/bin/sw_vers -productVersion )
major=$( awk -F'.' '{print $1}' <<< "${version}" )
minor=$( awk -F'.' '{print $2}' <<< "${version}" )
patch=$( awk -F'.' '{print $3}' <<< "${version}" )

#echo major =$major
#echo minor =$minor
#echo patch =$patch

if [ "$major" -eq 10 ]; then
	#echo major =$major
	
	#if [ "$minor" -eq 6 ]; then
	#	echo 10.6 =$minor
	#	#sudo kextcache -v 1 -a i386 -a x86_64 -m /System/Library/Caches/com.apple.kext.caches/Startup/Extensions.mkext /System/Library/Extensions
	#	sudo touch /System/Library/Extensions
	#	sudo kextcache -i /
	#elif [ "$minor" -ge 7 ] && [ "$minor" -le 10 ]; then
	#	echo 10.7~10.10 =$minor
	#	#sudo kextcache -system-prelinked-kernel
	#	#sudo kextcache -system-caches
	#	sudo touch /System/Library/Extensions
	#
	#elif [ "$minor" -ge 11 ]; then
	#	echo 10.12~ =$minor
	if [ "$minor" -ge 12 ]; then
	#	echo 10.12~ =$minor
		sudo touch /System/Library/Extensions
	#	sudo kextcache -u
	fi
fi


echo "\nUninstall Complete."
