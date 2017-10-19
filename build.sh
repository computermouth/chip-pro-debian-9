#!/bin/bash

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

