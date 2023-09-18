#  SPDX-License-Identifier:	GPL-2.0+
#  Version 2020 by Devmfc
#  boot hack, vendor bootloader can only boot legacy u-boot image files
#  so hack image header together (I don't want separate uImage files), kernel image should NOT exceed 32MB 
#	generate a new u-boot header via:
#	mkimage -C none -A arm -T script -d gxl-fixup.cmd gxl-fixup.scr

setenv verify no       
setenv cmd_hdr_create 'mw.l 0x1ffffc0 0 0x10;mw.l 0x1ffffc0 0x56190527;mw.l 0x1ffffcc 0x00000002;mw.l 0x1ffffd0 0x00000002;mw.l 0x1ffffd4 0x00000002;mw.l 0x1ffffdc 0x00021605;'
setenv cmd_hdr_crc 'mw.l 0x1ffffc4 0x25520aa8'
setenv cmd_do_boot 'run cmd_hdr_create cmd_hdr_crc; bootm 0x1ffffc0 ${initrd_loadaddr} ${fdt_addr_r}'
