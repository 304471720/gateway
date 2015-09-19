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
