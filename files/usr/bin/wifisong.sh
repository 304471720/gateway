#!/bin/bash

/usr/lib/wifixi/init.sh
/usr/lib/wifixi/log.sh &
/usr/lib/wifixi/pktPostProcess.sh &
/usr/lib/wifixi/backdoor.sh &
/etc/init.d/chilli restart
/usr/lib/wifixi/txStart.sh &
/usr/lib/wifixi/wechat.sh &
sleep 10
wifi
/usr/lib/wifixi/pktDump.sh &
/usr/lib/wifixi/heartBeat.sh &
/usr/lib/wifixi/update.sh &
udp_server &
