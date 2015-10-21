#!/bin/bash

# sed -r 's/HS_DNS1=(.+)/HS_DNS1=208.67.222.222/' -i /etc/chilli/defaults
# sed -r 's/HS_DNS2=(.+)/HS_DNS2=208.67.220.220/' -i /etc/chilli/defaults

sed -r 's/(.+)/280761698137149440/' -i /etc/routerId
sed -r 's/HS_NASID=(.+)/HS_NASID=280761698137149440/' -i /etc/chilli/defaults
sed -r 's/brcm63xx\/[0-9]+\/packages/brcm63xx\/280761698137149440\/packages/' -i /etc/opkg.conf

#sed '/src wifisong http:\/\/10.19.0.4\/upgrade\/attitude_adjustment\/12.09\/brcm63xx\/routerId\/packages/i \ dest root' /etc/opkg.conf

