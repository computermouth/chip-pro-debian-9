##!/bin/bash
## useful to use bash here

git clone -b nextthing/4.4/chip https://github.com/nextthingco/chip-linux linux
git clone -b debian https://github.com/nextthingco/RTL8723DS
git clone -b debian https://github.com/nextthingco/rtl8723ds_bt

if [ "$(ps -p "$$" -o comm=)" != "bash" ]; then
    bash "$0" "$@"; exit "$?"
fi
set -ex

bamboo_buildNumber=2

### KERNEL

cd linux

export YOUR_FULLNAME="NextThingCo"
export YOUR_EMAIL="software@nextthing.co"
export CONCURRENCY_LEVEL=$(( $(nproc) * 2 ))

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export KBUILD_DEBARCH=armhf
export KDEB_CHANGELOG_DIST=stretch
export LOCALVERSION=-pro
export KDEB_PKGVERSION=$(make kernelversion)-${bamboo_buildNumber}
export DEBFULLNAME="$YOUR_FULLNAME"
export DEBEMAIL="$YOUR_EMAIL"

#~ git config --global user.email "software@nextthing.co"
#~ git config --global user.name "Next Thing Co."

#~ echo << 'EOF' | git am
#~ From c8e3bc220a3f6ac19dc2fb5dbffc31c777d7e0a6 Mon Sep 17 00:00:00 2001
#~ From: Alex Kaplan <alex@nextthing.co>
#~ Date: Fri, 25 Mar 2016 16:02:24 -0700
#~ Subject: [PATCH] PocketCHIP/TCA8418: fix problem with keyboard repeating key
 #~ presses

#~ Signed-off-by: Alex Kaplan <alex@nextthing.co>
#~ ---
 #~ drivers/input/keyboard/tca8418_keypad.c | 2 +-
 #~ 1 file changed, 1 insertion(+), 1 deletion(-)

#~ diff --git a/drivers/input/keyboard/tca8418_keypad.c b/drivers/input/keyboard/tca8418_keypad.c
#~ index 9002298..b88b369 100644
#~ --- a/drivers/input/keyboard/tca8418_keypad.c
#~ +++ b/drivers/input/keyboard/tca8418_keypad.c
#~ @@ -360,7 +360,7 @@ static int tca8418_keypad_probe(struct i2c_client *client,
 		#~ irq = gpio_to_irq(irq);
 
 	#~ error = devm_request_threaded_irq(dev, irq, NULL, tca8418_irq_handler,
#~ -					  IRQF_TRIGGER_FALLING |
#~ +					  IRQF_TRIGGER_LOW |
 						#~ IRQF_SHARED |
 						#~ IRQF_ONESHOT,
 					  #~ client->name, keypad_data);
#~ -- 
#~ 1.9.1
#~ EOF

#~ make multi_v7_defconfig

#~ scripts/config --file .config -d CONFIG_LOGO_LINUX_MONO
#~ scripts/config --file .config -d CONFIG_LOGO_LINUX_VGA16
#~ scripts/config --file .config -d CONFIG_LOGO_LINUX_CLUT224
#~ scripts/config --file .config -d CONFIG_LOGO

#~ make -j${CONCURRENCY_LEVEL} prepare modules_prepare scripts
#~ make -j${CONCURRENCY_LEVEL} deb-pkg

cd ..

## WIFI

export LINUX_SRCDIR="$(pwd)/linux"
export RTL8723DS_SRCDIR="$(pwd)/RTL8723DS"
export BUILDDIR=$RTL8723DS_SRCDIR/build
export CONCURRENCY_LEVEL=$(( $(nproc) * 2 ))
export RTL_VER=$(cd $RTL8723DS_SRCDIR; dpkg-parsechangelog --show-field Version)

cd $RTL8723DS_SRCDIR

#~ dpkg-buildpackage -A -uc -us -nc
#~ sudo dpkg -i ../rtl8723ds-mp-driver-source_${RTL_VER}_all.deb

#~ mkdir -p $BUILDDIR/usr_src
export CC=arm-linux-gnueabihf-gcc
export $(dpkg-architecture -aarmhf)
export CROSS_COMPILE=arm-linux-gnueabihf-
export KERNEL_VER=$(cd $LINUX_SRCDIR; make kernelversion)

#~ cp -a /usr/src/modules/rtl8723ds-mp-driver/* $BUILDDIR
#~ pushd /usr/src
#~ sudo tar -zcvf rtl8723ds-mp-driver.tar.gz modules/rtl8723ds-mp-driver
#~ popd

#~ m-a -t -u $BUILDDIR \
    #~ -l $KERNEL_VER \
    #~ -k $LINUX_SRCDIR \
    #~ build rtl8723ds-mp-driver-source


#~ cp $BUILDDIR/*.deb ../

cd ..

## BT

pushd rtl8723ds_bt

dpkg-buildpackage -uc -us -nc

popd
