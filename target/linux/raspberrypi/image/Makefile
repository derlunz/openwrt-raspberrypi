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

define Image/Build/bootpart
	#Copy firmware files to their directory
	$(INSTALL_DIR) $(KDIR)/boot.vfat
	$(CP) $(BOOTDIR)/bootcode.bin $(KDIR)/boot.vfat
	$(CP) $(BOOTDIR)/loader.bin $(KDIR)/boot.vfat
	#TODO: select some cpu/gpu ram layout
	$(CP) $(BOOTDIR)/start.elf $(KDIR)/boot.vfat
	#TODO: adjust kernel cmdline from our settings
	$(CP) $(BOOTDIR)/cmdline.txt $(KDIR)/boot.vfat
	#TODO provide and configure
	$(CP) $(KDIR)/kernel.img $(KDIR)/boot.vfat/kernel.img

	#Create fat boot partition image, based on the size of the firmware files
	# Round up files size to a multiple of 32 blocks (for mcopy), and add
	# 1MB spare size
	rm -f $(KDIR)/boot.vfat.img
	$(MKDOSFS) -C "$(KDIR)/boot.vfat.img" $(shell echo "(((`du -sBK $(KDIR)/boot.vfat | cut -f1|tr -d 'K'` ) / 32 ) + 1 ) * 32 + 1024 "|bc)
	$(MCP) -i $(KDIR)/boot.vfat.img $(KDIR)/boot.vfat/* ::
endef

define Image/Build/sdcard
	PATH="$(TARGET_PATH)" ./gen_image_sd.sh \
		$(BIN_DIR)/$(IMG_PREFIX)-sdcard.img \
		$(CONFIG_RPI_SD_CARD_SIZE) \
		$(KDIR)/boot.vfat.img \
		$(KDIR)/root.ext4
endef

define Image/Build/squashfs
    $(call prepare_generic_squashfs,$(KDIR)/root.squashfs)
endef

define Image/Prepare
	$(MAKE) -C rpi-firmware prepare
endef

define Image/Build
	$(call Image/Build/$(1))
	$(call Image/Build/bootpart)
	$(call Image/Build/sdcard)
	dd if=$(KDIR)/root.$(1) of=$(BIN_DIR)/openwrt-$(BOARD)-root.$(1) bs=128k conv=sync
endef

$(eval $(call BuildImage))
