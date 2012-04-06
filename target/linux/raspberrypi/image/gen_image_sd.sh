#!/usr/bin/env bash
# Copyright (C) 2006-2012 OpenWrt.org
set -x 
[ $# == 5 ] || {
    echo "usage: $0 <outputfile> <sdcard-size> <bootpart directory> <rootfs size> <rootfs image>"
    exit 1
}

OUTPUT="$1"
SDCARDSIZE="$2"
KERNELDIR="$3"
ROOTFSSIZE="$4"
ROOTFSIMAGE="$5"

#Clean up
rm -f "$OUTPUT"

#Calculate needed Size for boot partition
BOOTSIZE="$(du -sBM $KERNELDIR | cut -f1 )"
BOOTSIZE="${BOOTSIZE%M}" 
ROOTFSSIZE=$(( $SDCARDSIZE - $BOOTSIZE))

head=16
sect=63
cyl=$(( ($BOOTSIZE + $ROOTFSSIZE) * 1024 * 1024 / ($head * $sect * 512)))

# create partition table
set `ptgen -o "$OUTPUT" -h $head -s $sect -t c -p ${BOOTSIZE}m  -t 83 -p ${ROOTFSSIZE}m`

BOOTOFFSET="$(($1 / 512))"
BOOTSIZE="$(($2 / 512))"
ROOTFSOFFSET="$(($3 / 512))"
ROOTFSSIZE="$(($4 / 512))"
BOOTBLOCKS="$((($BOOTSIZE / 2) - 1))"

#Create an empty file of SD card size
dd if=/dev/zero of="$OUTPUT" bs=512 seek="$ROOTFSOFFSET" conv=notrunc count="$ROOTFSSIZE"

#Paste in the rootfs partition
dd if="$ROOTFSIMAGE" of="$OUTPUT" bs=512 seek="$ROOTFSOFFSET" conv=notrunc

#Generate the boot partition
rm -f "$OUTPUT.boot.vfat"
rm -rf "$OUTPUT.boot.vfat.mount"
mkdir "$OUTPUT.boot.vfat.mount"

mkfs.vfat -C  "$OUTPUT.boot.vfat" "$BOOTBLOCKS"
sudo mount -o loop,uid=$USER,gid=$USER "$OUTPUT.boot.vfat" "$OUTPUT.boot.vfat.mount"
cp -r "$KERNELDIR"/* "$OUTPUT.boot.vfat.mount"
sudo umount "$OUTPUT.boot.vfat.mount"
rm -rf "$OUTPUT.boot.vfat.mount"

#Paste in the boot partition
dd if="$OUTPUT.boot.vfat" of="$OUTPUT" bs=512 seek="$BOOTOFFSET" conv=notrunc
