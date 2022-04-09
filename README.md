# Lilac UxB

## Folders

- VivadoProject: vivado project which defined the hardware (ps and pl).
- SDK: bare program of zynq, FSBL
- Petalinux: petalinux source code. The petalinux project already config-hw-description!

## Usage

1. Create Vivado project and do implementation on FPGA. Follow the [Vivado Project README](./VivadoProject/README.md).
2. Export the hardware with FPGA image in Vivado.
3. Copy the `./VivadoProject/work/Lilac_UxB_hw/Lilac_UxB.sdk/` folder to the father folder of `Petalinux/` (Same level with `Petalinux/`).
4. Create the FSBL project in SDK with source file in `SDK/` folder. And copy the `fsbl.elf` to the father folder of `Petalinux/`. PS. Build FSBL in release mode is helpful for zip the size of FSBL binrary file. Or just copy the `SDK/mod513_fsbl.elf` which I had built.
5. Config the petalinux project with hardware.  
  ```
  cd Petalinux/
  petalinux-config --get-hw-description ../Lilac_UxB.sdk/ --silentconfig
  ```
6. Build the petalinux project. `petalinux-build`
7. Generate the BOOT.bin image file. `petalinux-package --boot --fsbl ../fsbl.elf --fpga --u-boot --force`

## Release Note

- 0.0.1 PS only test with Linux.
- 0.0.2 Add SGMII and test with ZCU111.
- 0.0.3 Enable eMMC, and wrote the rootfs on it, uboot will tell the kernel mount rootfs on eMMC.
- 0.0.4 Modify U-BOOT source code, add support to 513's fake QSPI flash, kernel can load from QSPI flash.
- 0.0.5 Enable 3 SGMIIs interface.
