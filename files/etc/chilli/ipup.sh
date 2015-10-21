# force-add the final rule necessary to fix routing tables
iptables -I POSTROUTING -t nat -o $HS_WANIF -j MASQUERADE
