#
# Copyright (C) 2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/ws720
	NAME:=ws720 Device
	PACKAGES:=\
		kmod-usb-core kmod-usb3 kmod-usb-hid kmod-sdhci-mt7620 \
		kmod-ledtrig-usbdev kmod-ata-core kmod-ata-ahci \
		kmod-usb3-mt7621 kmod-rtc-pcf8563
endef


FEATURES+=rtc

define Profile/ws720/Description
	Default package set compatible with most boards.
endef
$(eval $(call Profile,ws720))
