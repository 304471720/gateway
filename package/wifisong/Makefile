#
# Copyright (C) 2013-2023 wifisong.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=wifisong
PKG_VERSION:=1.0.15
PKG_RELEASE:=19

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@bitbucket.org:zhiwifi/wifisong.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE)
PKG_SOURCE_VERSION:=fdf42bce8a80889fb806f7075da3ce64af2e8753

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz

PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/kernel.mk

define Package/wifisong
  SECTION:=base
  CATEGORY:=Network
  DEPENDS:=+libpthread +libstdcpp +tcpdump +netcat +screen +curl
  DEFAULT:=y
  TITLE:=WiFiSong utility
  #DESCRIPTION:=This variable is obsolete. use the Package/name/description define instead!
  URL:=http://www.wifisong.com/
  MAINTAINER:=Sichao Yang<ysc@wifisong.com>
endef

define Package/wifisong/description
  WiFiSong
endef

define Build/Configure
	$(call Build/Configure/Default,--with-linux-headers=$(LINUX_DIR))
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/src \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/include-host -I$(STAGING_DIR_HOST)/include -include endian.h  $(TARGET_CFLAGS_EXTRA)" \
	LDFLAGS="$(TARGET_LDFLAGS)"
	$(STRIP) $(PKG_BUILD_DIR)/src/pcapsplit
	mkdir -p $(PKG_INSTALL_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		install
endef

define Package/wifisong/install
	$(CP) -a $(PKG_INSTALL_DIR)/* $(1)/
	$(INSTALL_DIR) $(1)/etc/wifisong
	$(INSTALL_DATA) ./files/passwd $(1)/etc/passwd
	$(INSTALL_DATA) ./files/shadow $(1)/etc/shadow
	$(INSTALL_DATA) ./files/wifisong.config $(1)/etc/wifisong/config
	$(INSTALL_DATA) ./files/wifisong.version $(1)/etc/wifisong/version
	$(INSTALL_DATA) ./files/id_rsa $(1)/etc/wifisong/id_rsa
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/wifisong.init $(1)/etc/init.d/wifisong
endef

define Package/wifisong/postinst
endef

$(eval $(call BuildPackage,wifisong))
