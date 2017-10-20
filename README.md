## live-build debian 9 for CHIP Pro

Requirements and process listed in `build.sh`

No kernel/wifi/bt pulled from NTC repo, other packages pulled from Debian repo, all packages listed in `config/package-lists/live.list.chroot`

Scripting happens in order in `config/hooks/normal`

Live build scaffolding before git drops empty dirs:

```
$ ls
apt        build             hooks               includes.chroot     packages         rootfs
archives   chroot            includes            includes.installer  packages.binary  source
binary     common            includes.binary     includes.source     packages.chroot
bootstrap  debian-installer  includes.bootstrap  package-lists       preseed
```

[Live Build Docs](https://debian-live.alioth.debian.org/live-manual/stable/manual/html/live-manual.en.html)
