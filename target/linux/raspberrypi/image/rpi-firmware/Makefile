#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=rpi-firmware
PKG_VERSION:=2012-04-02
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/raspberrypi/firmware.git
PKG_SOURCE_VERSION:=ea493c30e2c5328b80943dff2db909f194cdf155
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.bz2

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Build/InstallDev
	$(INSTALL_DIR) $(KERNEL_BUILD_DIR)/rpi-boot-files
	$(CP) $(PKG_BUILD_DIR)/boot/start.elf $(KERNEL_BUILD_DIR)/rpi-boot-files
	$(CP) $(PKG_BUILD_DIR)/boot/arm*_start.elf $(KERNEL_BUILD_DIR)/rpi-boot-files
	$(CP) $(PKG_BUILD_DIR)/boot/bootcode.bin $(KERNEL_BUILD_DIR)/rpi-boot-files
	$(CP) $(PKG_BUILD_DIR)/boot/loader.bin $(KERNEL_BUILD_DIR)/rpi-boot-files
	$(CP) $(PKG_BUILD_DIR)/boot/cmdline.txt $(KERNEL_BUILD_DIR)/rpi-boot-files
endef

$(eval $(call Build/DefaultTargets))
