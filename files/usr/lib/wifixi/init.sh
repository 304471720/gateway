#!/bin/bash

. /usr/lib/wifixi/functions.sh

# get routerId
version=$(cat /etc/version)
routerType=$(cat /etc/router_type)

while true;
do
    if [ -f "/etc/routerId" ]
    then
        routerId=`cat /etc/routerId`
        break
    else
        wmac=`ifconfig | grep ^eth0 | sed -r 's#(.+)([0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2})(.+)#\2#'`
        lmac=`ifconfig | grep ^br-lan | sed -r 's#(.+)([0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2})(.+)#\2#'`
        nonce=`date | md5sum | sed -r 's/([0-9a-zA-Z]+) (.+)/\1/'`
        echo $nonce
        signature=`echo -n $(echo -n $nonce; echo -n "61F7B04E443C4F6FA08CD027DF5AC638") | md5sum | sed -r 's/([0-9a-zA-Z]+) (.+)/\1/'`
        echo $signature

        # Get result from the server
        if [ ! -f "/etc/init_config" ]
        then
		    curl "http://router.lbsdata.org/device/init?wmac=$wmac&lmac=$lmac&v=$version&type=$routerType&nonce=$nonce&signature=$signature" >/etc/init_config
        fi

        # Parse result and make corresponding modifications
        #Router configuration
        routerId=`cat /etc/init_config | grep router_id | sed -r 's/router_id=(.+)/\1/'`
        router_password=`cat /etc/init_config | grep router_password | sed -r 's/router_password=(.+)/\1/'`
        echo $routerId
        echo $routerId >/etc/routerId
        sed -r "s/routerId/$routerId/" -i /etc/opkg.conf
        sed -r "s/:webadmin:.+/:webadmin:$router_password/" -i /etc/httpd.conf

	echo "webadmin:$router_password" | chpasswd --md5

        secret=`cat /etc/init_config | grep share_secret | sed -r 's/share_secret=(.+)/\1/'`
        if [ ! -z "$secret" ]; then
            echo $secret >/etc/secret
        fi

        #Network configuration
        lan_ipaddr=`cat /etc/init_config | grep lan_ipaddr | sed -r 's/lan_ipaddr=(.+)/\1/'`
        echo $lan_ipaddr
        uci set network.lan.ipaddr=$lan_ipaddr
	uci set firewall.@redirect[0].dest_ip=$lan_ipaddr

        #Wifi configuration
        ssid=`cat /etc/init_config | grep wifi_ssid | sed -r 's/wifi_ssid=(.+)/\1/'`
        echo $ssid
        last4digits=$(ifconfig | grep wlan0[^-] | awk '{ print $5 }' | sed -r 's/[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:([0-9a-fA-F]{2}):([0-9a-fA-F]{2})/\1\2/')
        uci set wireless.@wifi-iface[0].ssid=$ssid-$last4digits
        uci set wireless.@wifi-iface[1].ssid=$ssid-Office
		
        #Chilli configuration
        chilli_whitelist=`cat /etc/init_config | grep chilli_whitelist | sed -r 's/chilli_whitelist=(.+)/\1/'`
        chilli_uamurl=`cat /etc/init_config | grep chilli_uamurl | sed -r 's/chilli_uamurl=(.+)/\1/' | sed -r "s/\//\\\\\\\\\//g"`
        echo $chilli_uamurl
        sed -r "s/^HS_NASID=.+/HS_NASID=$routerId/" -i /etc/chilli/defaults
        sed -r "s/^HS_UAMDOMAINS=\"(.+)\"/HS_UAMDOMAINS=\"\1,$chilli_whitelist\"/" -i /etc/chilli/defaults
        sed -r "s/^HS_UAMFORMAT=.+/HS_UAMFORMAT=$chilli_uamurl/" -i /etc/chilli/defaults
		
        # Admin webpage configuration
        luCI_port=`cat /etc/init_config | grep luCI_port | sed -r 's/luCI_port=(.+)/\1/'`
        uci set uhttpd.main.listen_http=0.0.0.0:$luCI_port
	uci set firewall.@redirect[0].dest_port=$luCI_port
		
        # Brand configuration
        brand_name=`cat /etc/init_config | grep brand_name | sed -r 's/brand_name=(.+)/\1/'`
        brand_logourl=`cat /etc/init_config | grep brand_logourl | sed -r 's/brand_logourl=(.+)/\1/'`
        echo $brand_name
        echo $brand_logourl
        # uci set system.@system[0].hostname=$brand_name
        curl $brand_logourl >logo.jpg
        cp logo.jpg /www2/img/

        # System configuration
        host_name=`cat /etc/router_type`
        uci set system.@system[0].hostname=$host_name
    fi
	
    uci commit
    mkdir /etc/wifisong
    cp /etc/init_config /etc/wifisong/
    reboot
done
