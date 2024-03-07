# Amlogic boot scripts for Armbian

The Armbian images for Amlogic TV Boxes use secondary, chain loaded u-boot blobs to boot mainline kernel images.
The vendor u-boot bootloaders can however boot mainline Linux perfectly without them. So they are not needed.

All it takes are some simple modifications of some of the Armbian u-boot scripts.

# Setup
assumption: you have vendor u-boot (the one that came with the box) running on eMMC. If you don't, you can just restore the stock Android image with Amlogic USB Burning tool.

+ **Step 1:** Download latest Armbian for s9xxx-box, let's use [bookworm minimal](https://github.com/armbian/community/releases/download/24.5.0-trunk.152/Armbian_community_24.5.0-trunk.152_Aml-s9xx-box_bookworm_current_6.6.21_minimal.img.xz)  
+ **Step 2:** Burn the image to a USB flash drive  
+ **Step 3:** Copy the modified boot scripts (**[aml_autoscript](https://github.com/devmfc/amlogic-bootscripts-Armbian/blob/main/aml_autoscript)**, **[s905_autoscript](https://github.com/devmfc/amlogic-bootscripts-Armbian/blob/main/s905_autoscript)** ) to the fat partition on the USB drive. Overwrite the existing files.  
+ **Step 4:** If you have a GXBB (S905) or GXL (S905X/W/L) soc, you also need **[gxl-fixup.scr](https://github.com/devmfc/amlogic-bootscripts-Armbian/blob/main/gxl-fixup.scr)**  
+ **Step 5:** Add an armbianEnv.txt file with the following content (file is also on github):  
```bash
extraargs=earlycon rootflags=data=writeback rw no_console_suspend consoleblank=0 fsck.fix=yes fsck.repair=yes net.ifnames=0
bootlogo=false
verbosity=7
usbstoragequirks=0x2537:0x1066:u,0x2537:0x1068:u
console=both

# DTB file for this tvbox
# fdtfile=amlogic/meson-gxl-s905x-nexbox-a95x.dtb
fdtfile=amlogic/meson-sm1-x96-air-gbit.dtb

# set this to the UUID of the root partition (value can be found 
# in /extlinux/extlinux.conf after APPEND root= or with blkid)
rootdev=UUID=92139c84-3871-41d7-a3f2-e8a943cbfa87

# Enable ONLY for gxbb (S905) / gxl (S905X/L/W) to create fake u-boot header
#soc_fixup=gxl-
```
+ **Step 6:** Change *fdtfile* to the DTB for your box.  
+ **Step 7:** (optional since version 3:) Change *rootdev* to the right UUID for the rootfs for your image or change to /dev/sda2 when booting from USB or /dev/mmcblk0p2 when booting from SDCARD  
+ **Step 8:** Only if your box has a GXBB (S905) or GXL (S905X/W/L) soc, uncomment the line *soc_fixup=gxl-*  
+ **Step 9:** Power off the the box.  
+ **Step 10:** Put the USB disk in your box.  
+ **Step 11:** Push the reset button and hold the button  
+ **Step 12:** power up your box while holding the reset button for approx 7 seconds.  
+ **Step 13:** If you're lucky, it will now boot Armbian with a mainline kernel. Without any secondary u-boot blobs.  

All used files and source files can be found on [Github](https://github.com/devmfc/amlogic-bootscripts-Armbian).  
  
This is tested on S905X, S905W, S912, S905X2, S922X, S905X3 and they all boot the kernel.  
I did test S905 also, but it boots only the first time for some reason.  
It will probably also work for S905X4 and S905W2, but did not test those. They are not supported by the Armbian kernel at this moment anyway.
