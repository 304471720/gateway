getVersion()
{
	#openwrtDescription=`cat /etc/openwrt_release | grep DISTRIB_DESCRIPTION | sed -r 's/DISTRIB_DESCRIPTION="(.+)"/\1/'`
	openwrtRevision=`cat /etc/openwrt_release | grep DISTRIB_REVISION | sed -r 's/DISTRIB_REVISION="(.+)"/\1/'`
	wifisongVersion=`opkg info wifisong | grep -B4 ' installed' |grep Version | sed -r 's/Version: (.+)/\1/'`
	version="$openwrtRevision-$wifisongVersion"
	echo "$version"
}
