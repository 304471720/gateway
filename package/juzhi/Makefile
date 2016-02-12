#
# Copyright (C) 2013-2023 wifisong.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=juzhi
PKG_VERSION:=1.0.0
PKG_RELEASE:=0

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@bitbucket.org:zhiwifi/juzhi.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE)
PKG_SOURCE_VERSION:=7c33f194cd2f5f0eac1a205c6a02eb760fada4c1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz

PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/kernel.mk

define Package/juzhi
  SECTION:=base
  CATEGORY:=Network
  DEPENDS:=+libc +libpthread +libpcap +libuci
  DEFAULT:=y
  TITLE:=juzhi utilities
  URL:=http://www.wifisong.com/
  MAINTAINER:=Sichao Yang<ysc@wifisong.com>
endef

define Package/juzhi/description
  WiFiSong
endef

define Build/Configure
	$(call Build/Configure/Default,--with-linux-headers=$(LINUX_DIR))
endef

define Build/Compile
	mkdir -p $(PKG_INSTALL_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		install
endef

define Package/juzhi/install
	$(CP) -a $(PKG_INSTALL_DIR)/* $(1)/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/juzhi.init $(1)/etc/init.d/juzhi
endef

define Package/juzhi/postinst
endef

$(eval $(call BuildPackage,juzhi))
