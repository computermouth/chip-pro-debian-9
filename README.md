## live-build debian 9 for CHIP Pro

Requirements and process listed in `build.sh`

Live build scaffolding before git drops empty dirs:

```
$ ls config/
apt        build             hooks               includes.chroot     packages         rootfs
archives   chroot            includes            includes.installer  packages.binary  source
binary     common            includes.binary     includes.source     packages.chroot
bootstrap  debian-installer  includes.bootstrap  package-lists       preseed
```

includes*	-> flat file drop in (`includes.chroot/usr/bin/script` would install `script` in `/usr/bin/`)
archives	-> debian repo stuff
hooks		-> scripts (you'll only need to add to the `normal` ones)
package-lists	-> list of packages
packages*	-> paste in debs

[Live Build Docs](https://debian-live.alioth.debian.org/live-manual/stable/manual/html/live-manual.en.html)
