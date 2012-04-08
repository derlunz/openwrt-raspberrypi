#!/usr/bin/env bash
# Copyright (C) 2006-2012 OpenWrt.org
set -x 
[ $# == 4 ] || {
    echo "usage: $0 <outputfile> <sdcard-size> <bootfs image> <rootfs image>"
    exit 1
}

OUTPUT="$1"
SDCARDSIZE="$2"
BOOTFSIMAGE="$3"
ROOTFSIMAGE="$4"

rm -f "$OUTPUT"

#Calculate needed Size for boot partition
BOOTSIZE="$(ls -l --block-size=M $BOOTFSIMAGE | cut -d' ' -f5 | tr -d 'M')"
ROOTFSSIZE="$(ls -l --block-size=M $ROOTFSIMAGE | cut -d' ' -f5 | tr -d 'M')"

# create partition table
set `ptgen -v -o "$OUTPUT" -h 16 -s 63 -t c -p ${BOOTSIZE}m -t 83 -p ${ROOTFSSIZE}m`

BOOTOFFSET="$(($1 / 512))"
BOOTSIZE="$(($2 / 512))"
ROOTFSOFFSET="$(($3 / 512))"
ROOTFSSIZE="$(($4 / 512))"
IMAGESIZE="$(( ($SDCARDSIZE * 1024 * 1024  / 512 ) - 63))"

#Create an empty file of SD card size
dd if=/dev/zero of="$OUTPUT" bs=512 seek=63 conv=notrunc count="$IMAGESIZE"

#Paste in the boot partition
dd if="$BOOTFSIMAGE" of="$OUTPUT" bs=512 seek="$BOOTOFFSET" conv=notrunc

#Paste in the rootfs partition
dd if="$ROOTFSIMAGE" of="$OUTPUT" bs=512 seek="$ROOTFSOFFSET" conv=notrunc
