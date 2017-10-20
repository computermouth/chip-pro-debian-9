#!/bin/bash

## Requirements (on Debian 9)
##	build-essential
##  crossbuild-essential-armhf
##	git
##	live-build
##	qemu-user-static
##
## For image creation/flashing
##	github.com/nextthingco/chip-tools
##	github.com/linux-sunxi/sunxi-tools
##		[ `make`, `make misc`, `make install`, `sudo cp sunxi* /usr/bin/`]
##	mtd-utils
##	u-boot-tools
##	img2simg

sudo lb build
rm -rf live-image-armhf.tar.tar
pushd binary
sudo tar -cf ../rootfs.tar .
popd

CHIP_UBOOT_BRANCH=${CHIP_UBOOT_BRANCH:-production-mlc}

git clone https://github.com/nextthingco/chip-u-boot
pushd chip-u-boot

git clean -xfd
git checkout .
git checkout ${CHIP_UBOOT_BRANCH}
git apply ../0001-compiler-.h-sync-include-linux-compiler-.h-with-Linu.patch

make ${UBOOT_EXTRA_OPTS} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- CHIP_defconfig
make ${UBOOT_EXTRA_OPTS} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-

## To create image/flash:
##
## sudo ./chip-create-nand-image.sh ../chip-pro-debian-9/chip-u-boot ../chip-pro-debian-9/rootfs.tar output
## sudo chown -R $USER:$USER output
## ./chip-update-firmware.sh -L output -F Toshiba_512M_SLC
