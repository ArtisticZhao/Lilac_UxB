# Lilac UxB

## Folders

- VivadoProject: vivado project which defined the hardware (ps and pl).
- SDK: bare program of zynq, FSBL
- Petalinux: petalinux source code. The petalinux project already config-hw-description!

## Release Note

- 0.0.1 ps only test with Linux
- 0.0.2 add sgmii and test with ZCU111
- 0.0.3 enable eMMC, and wrote the rootfs on it, uboot will tell the kernel mount rootfs on eMMC.
- 0.0.4 Modify U-BOOT source code, add support to 513's fake qspi flash, kernel can load from qspi flash.
