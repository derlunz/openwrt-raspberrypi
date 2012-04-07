#
# Copyright (C) 2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=dosfstools
PKG_VERSION:=3.0.12

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://fossies.org/linux/misc/
PKG_MD5SUM:=4c1f1e72b82371704f93ebdd3c7b6259
PKG_CAT:=zcat

include $(INCLUDE_DIR)/host-build.mk

HOST_CONFIGURE_ARGS = \
	--target=$(GNU_HOST_NAME) \
	--host=$(GNU_HOST_NAME) \
	--build=$(GNU_HOST_NAME) \
	--program-prefix="" \
	--program-suffix="" \
	--prefix=/usr \
	--exec-prefix=/usr \
	--bindir=/usr/bin \
	--sbindir=/usr/sbin \
	--libexecdir=/usr/lib \
	--sysconfdir=/etc \
	--datadir=/usr/share \
	--localstatedir=/var \
	--mandir=/usr/man \
	--infodir=/usr/info \


define Host/Clean
	-$(MAKE) -C $(HOST_BUILD_DIR) uninstall
	$(call Host/Clean/Default)
endef

define Host/Compile
	$(MAKE) -C $(HOST_BUILD_DIR) \
		CFLAGS="$(HOST_CFLAGS)" \
		all
endef

define Host/Install
	install -m0755 $(HOST_BUILD_DIR)/mkdosfs $(STAGING_DIR_HOST)/bin/
endef

$(eval $(call HostBuild))
