############################ CONFIG SGMII ############################
# gt-ref clk  zu513
set_property PACKAGE_PIN P32 [get_ports gt_refclk_clk_n]
set_property PACKAGE_PIN P31 [get_ports gt_refclk_clk_p]
create_clock -period 6.400 -name gt_ref_clk [get_ports gt_refclk_clk_p]
# sfp0 zu513
set_property PACKAGE_PIN E38 [get_ports sfp0_rxp]
set_property PACKAGE_PIN E39 [get_ports sfp0_rxn]
set_property PACKAGE_PIN D31 [get_ports sfp0_txp]
set_property PACKAGE_PIN D32 [get_ports sfp0_txn]
# sfp1 zu513
set_property PACKAGE_PIN D36 [get_ports sfp1_rxp]
set_property PACKAGE_PIN D37 [get_ports sfp1_rxn]
set_property PACKAGE_PIN C33 [get_ports sfp1_txp]
set_property PACKAGE_PIN C34 [get_ports sfp1_txn]
# sfp2 zu513
set_property PACKAGE_PIN C38 [get_ports sfp2_rxp]
set_property PACKAGE_PIN C39 [get_ports sfp2_rxn]
set_property PACKAGE_PIN B31 [get_ports sfp2_txp]
set_property PACKAGE_PIN B32 [get_ports sfp2_txn]

############################ CONFIG PROJECT ############################
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
