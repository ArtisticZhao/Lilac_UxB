# FSBL source code

Because of the 513 use an A3P FPGA to emulation QSPI flash.
The QSPI clk is limited to a low frequency.
So they modify the Xilinx FSBL program to fit the flow frequency load up.

## File changes

- `xfsbl_bs.h`  
  Prolong the `PL_DONE_POLL_COUNT` to wait the FPGA load.

- `xfsbl_debug.h`  
  Enable detailed debug infomation output.

- `xfsbl_qspi.h` and `xfsbl_qspi.c`
  Add `SLOW_READ_CMD_32BIT` command. To adapt flow speed QSPI interface.

