#
# Copyright (C) 2012-2013 WiFiSong
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/WIFISONG_WS150B
	NAME:=WiFiSong WS150B
 	PACKAGES:= kmod-usb-core kmod-usb2 kmod-usb-ohci kmod-usb-ohci-pci kmod-usb-serial \
		kmod-usb-serial-option kmod-usb-serial-qualcomm kmod-usb-serial-wwan \
		kmod-usb2 kmod-usb2-pci kmod-usb3 bluez-utils kmod-bluetooth comgt luci-proto-3g \
		minicom mwan3 luci-app-mwan3
endef

define Profile/WIFISONG_WS150B/description
	Package set optimized for the WiFiSong WS150B.
endef
$(eval $(call Profile,WIFISONG_WS150B))

define Profile/WIFISONG_WS555
	NAME:=WiFiSong WS555
 	PACKAGES:= kmod-usb-core kmod-usb2 kmod-usb-ohci kmod-usb-ohci-pci kmod-usb-serial \
		kmod-usb-serial-option kmod-usb-serial-qualcomm kmod-usb-serial-wwan \
		kmod-usb2 kmod-usb2-pci kmod-usb3 bluez-utils kmod-bluetooth comgt luci-proto-3g \
		minicom mwan3 luci-app-mwan3
endef

define Profile/WIFISONG_WS555/description
	Package set optimized for the WiFiSong WS555.
endef
$(eval $(call Profile,WIFISONG_WS555))

define Profile/WIFISONG_WS151
	NAME:=WiFiSong WS151
	PACKAGES:=
endef

define Profile/WIFISONG_WS151/description
	Package set optimized for the WiFiSong WS151.
endef
$(eval $(call Profile,WIFISONG_WS151))

define Profile/WIFISONG_WS155
	NAME:=WiFiSong WS155
	PACKAGES:=
endef

define Profile/WIFISONG_WS155/description
	Package set optimized for the WiFiSong WS155.
endef
$(eval $(call Profile,WIFISONG_WS155))

define Profile/WIFISONG_WS230
	NAME:=WiFiSong WS230
	PACKAGES:=
endef

define Profile/WIFISONG_WS230/description
	Package set optimized for the WiFiSong WS230.
endef
$(eval $(call Profile,WIFISONG_WS230))

define Profile/WIFISONG_WS215
	NAME:=WiFiSong WS215
	PACKAGES:= kmod-usb-core kmod-usb2 kmod-usb-storage \
			kmod-crypto-deflate kmod-fs-ext4 kmod-ledtrig-gpio \
			kmod-nls-iso8859-1 e2fsprogs
endef

define Profile/WIFISONG_WS215/description
	Package set optimized for the WiFiSong WS215.
endef
$(eval $(call Profile,WIFISONG_WS215))

define Profile/WIFISONG_WS220
	NAME:=WiFiSong WS220
	PACKAGES:= kmod-usb-core kmod-usb2 kmod-usb-storage \
			kmod-crypto-deflate kmod-fs-ext4 kmod-ledtrig-gpio \
			kmod-nls-iso8859-1 e2fsprogs
endef

define Profile/WIFISONG_WS220/description
	Package set optimized for the WiFiSong WS220.
endef
$(eval $(call Profile,WIFISONG_WS220))

define Profile/WIFISONG_WS280i
	NAME:=WiFiSong WS280i
	PACKAGES:=kmod-usb-core kmod-usb2 kmod-usb-ohci kmod-usb-ohci-pci kmod-usb-serial \
		kmod-usb-serial-option kmod-usb-serial-qualcomm kmod-usb-serial-wwan kmod-usb-acm \
		kmod-usb2-pci kmod-usb3 kmod-usb-storage kmod-bluetooth bluez-utils comgt luci-proto-3g \
		minicom mwan3 luci-app-mwan3 usb-modeswitch
endef

define Profile/WIFISONG_WS280i/Description
	Package set optimized for the WiFiSong WS280i
endef 

$(eval $(call Profile,WIFISONG_WS280i))

define Profile/WIFISONG_WS286i
	NAME:=WiFiSong WS286i
	PACKAGES:=kmod-usb-core kmod-usb2 kmod-usb-storage kmod-bluetooth bluez-utils
endef

define Profile/WIFISONG_WS286i/Description
	Package set optimized for the WiFiSong WS286i
endef

$(eval $(call Profile,WIFISONG_WS286i))

define Profile/WIFISONG_WS550
	NAME:=WiFiSong WS550
	PACKAGES:=kmod-usb-core kmod-usb2 kmod-usb-storage
endef

define Profile/WIFISONG_WS550/Description
	Package set optimized for the WiFiSong WS550.
endef

$(eval $(call Profile,WIFISONG_WS550))

define Profile/WIFISONG_WS330
	NAME:=WiFiSong WS330
	PACKAGES:=kmod-usb-core kmod-usb2 kmod-usb-storage
endef

define Profile/WIFISONG_WS330/Description
	Package set optimized for the WiFiSong WS330.
endef

$(eval $(call Profile,WIFISONG_WS330))
