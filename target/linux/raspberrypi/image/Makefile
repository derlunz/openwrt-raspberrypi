#
# Copyright (C) 2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

ifneq ($(CONFIG_RPI_FIRMWARE),)
define Build/Clean
	$(MAKE) -C rpi-firmware clean
endef

define Build/Prepare
	$(MAKE) -C rpi-firmware prepare
endef

define Build/Compile
	$(MAKE) -C rpi-firmware compile
endef
endif


define Image/BuildKernel
	python ./gen_kern_header.py $(KDIR)/first32k.bin 
	cat $(KDIR)/first32k.bin $(LINUX_DIR)/arch/arm/boot/Image > $(KDIR)/kernel.img
	cp $(KDIR)/kernel.img $(BIN_DIR)/$(IMG_PREFIX)-kernel.img
	cp $(LINUX_DIR)/arch/$(ARCH)/boot/$(subst "",,$(KERNELNAME)) $(BIN_DIR)/openwrt-$(BOARD)-vmlinux.elf
endef

BOOTDIR="$(KDIR)/rpi-boot-files"

define Image/Build/sdcard

	#Copy firmware files to their directory
	$(INSTALL_DIR) $(KDIR)/root.vfat
	$(CP) $(BOOTDIR)/bootcode.bin $(KDIR)/root.vfat
	$(CP) $(BOOTDIR)/loader.bin $(KDIR)/root.vfat
	#TODO: select some cpu/gpu ram layout
	$(CP) $(BOOTDIR)/start.elf $(KDIR)/root.vfat
	#TODO: adjust kernel cmdline from our settings
	$(CP) $(BOOTDIR)/cmdline.txt $(KDIR)/root.vfat
	#TODO provide and configure
	$(CP) $(KDIR)/kernel.img $(KDIR)/root.vfat/kernel.img

	PATH="$(TARGET_PATH)" ./gen_image_sd.sh \
		$(BIN_DIR)/$(IMG_PREFIX)-sdcard.img \
		$(CONFIG_RPI_SD_CARD_SIZE) \
		$(KDIR)/root.vfat \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) $(KDIR)/root.ext4
endef

define Image/Build/squashfs
    $(call prepare_generic_squashfs,$(KDIR)/root.squashfs)
endef

define Image/Prepare
	$(MAKE) -C rpi-firmware prepare
endef

define Image/Build
	@echo IMAGE BUILD
	$(call Image/Build/sdcard)
	dd if=$(KDIR)/root.$(1) of=$(BIN_DIR)/openwrt-$(BOARD)-root.$(1) bs=128k conv=sync
endef

$(eval $(call BuildImage))
