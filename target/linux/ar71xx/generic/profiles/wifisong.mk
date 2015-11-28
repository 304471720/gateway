#
# Copyright (C) 2012-2013 WiFiSong
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/WIFISONG_WS151
	NAME:=WiFiSong WS151
	PACKAGES:=
endef

define Profile/WIFISONG_WS151/description
	Package set optimized for the WiFiSong WS151.
endef
$(eval $(call Profile,WIFISONG_WS151))

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
	PACKAGES:=kmod-usb-core kmod-usb2 kmod-usb-storage
endef

define Profile/WIFISONG_WS280i/Description
	Package set optimized for the WiFiSong WS280i
endef 

$(eval $(call Profile,WIFISONG_WS280i))

define Profile/WIFISONG_WS286i
	NAME:=WiFiSong WS286i
	PACKAGES:=kmod-usb-core kmod-usb2 kmod-usb-storage
endef

define Profile/WIFISONG_WS286i/Description
	Package set optimized for the WiFiSong WS286i
endef

$(eval $(call Profile,WIFISONG_WS286i))
