
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# QPSK_data_converter, Repeater

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu28dr-ffvg1517-2-i
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:zynq_ultra_ps_e:3.3\
xilinx.com:ip:axis_dwidth_converter:1.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:fir_compiler:7.2\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:usp_rf_data_converter:2.1\
xilinx.com:ip:gig_ethernet_pcs_pma:16.1\
xilinx.com:ip:xlslice:1.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
QPSK_data_converter\
Repeater\
"

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: config_const
proc create_hier_cell_config_const_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_config_const_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj
  set_property USER_COMMENTS.comment_4 "phyaddr=7
reset=emio-gpio2" [get_bd_cells /sgmii/sfp2/config_const]

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 0 -to 0 conf_valid
  create_bd_pin -dir O -from 4 -to 0 conf_vec
  create_bd_pin -dir O -from 4 -to 0 phyaddr
  create_bd_pin -dir O -from 0 -to 0 signal_det

  # Create instance: conf_valid, and set properties
  set conf_valid [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 conf_valid ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $conf_valid

  # Create instance: conf_vec, and set properties
  set conf_vec [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 conf_vec ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {5} \
 ] $conf_vec

  # Create instance: phyaddr, and set properties
  set phyaddr [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 phyaddr ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {7} \
   CONFIG.CONST_WIDTH {5} \
 ] $phyaddr

  # Create instance: signal_det, and set properties
  set signal_det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 signal_det ]

  # Create port connections
  connect_bd_net -net conf_valid_dout [get_bd_pins conf_valid] [get_bd_pins conf_valid/dout]
  connect_bd_net -net conf_vec_dout [get_bd_pins conf_vec] [get_bd_pins conf_vec/dout]
  connect_bd_net -net phyaddr_dout [get_bd_pins phyaddr] [get_bd_pins phyaddr/dout]
  connect_bd_net -net signal_det_dout [get_bd_pins signal_det] [get_bd_pins signal_det/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: config_const
proc create_hier_cell_config_const_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_config_const_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj
  set_property USER_COMMENTS.comment_3 "phyaddr=8
reset=emio-gpio1" [get_bd_cells /sgmii/sfp1/config_const]

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 0 -to 0 conf_valid
  create_bd_pin -dir O -from 4 -to 0 conf_vec
  create_bd_pin -dir O -from 4 -to 0 phyaddr
  create_bd_pin -dir O -from 0 -to 0 signal_det

  # Create instance: conf_valid, and set properties
  set conf_valid [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 conf_valid ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $conf_valid

  # Create instance: conf_vec, and set properties
  set conf_vec [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 conf_vec ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {5} \
 ] $conf_vec

  # Create instance: phyaddr, and set properties
  set phyaddr [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 phyaddr ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {8} \
   CONFIG.CONST_WIDTH {5} \
 ] $phyaddr

  # Create instance: signal_det, and set properties
  set signal_det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 signal_det ]

  # Create port connections
  connect_bd_net -net conf_valid_dout [get_bd_pins conf_valid] [get_bd_pins conf_valid/dout]
  connect_bd_net -net conf_vec_dout [get_bd_pins conf_vec] [get_bd_pins conf_vec/dout]
  connect_bd_net -net phyaddr_dout [get_bd_pins phyaddr] [get_bd_pins phyaddr/dout]
  connect_bd_net -net signal_det_dout [get_bd_pins signal_det] [get_bd_pins signal_det/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: config_const
proc create_hier_cell_config_const { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_config_const() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj
  set_property USER_COMMENTS.comment_2 "phyaddr=9
reset=emio-gpio0" [get_bd_cells /sgmii/sfp0/config_const]

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 0 -to 0 conf_valid
  create_bd_pin -dir O -from 4 -to 0 conf_vec
  create_bd_pin -dir O -from 4 -to 0 phyaddr
  create_bd_pin -dir O -from 0 -to 0 signal_det

  # Create instance: conf_valid, and set properties
  set conf_valid [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 conf_valid ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $conf_valid

  # Create instance: conf_vec, and set properties
  set conf_vec [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 conf_vec ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {5} \
 ] $conf_vec

  # Create instance: phyaddr, and set properties
  set phyaddr [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 phyaddr ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {9} \
   CONFIG.CONST_WIDTH {5} \
 ] $phyaddr

  # Create instance: signal_det, and set properties
  set signal_det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 signal_det ]

  # Create port connections
  connect_bd_net -net conf_valid_dout [get_bd_pins conf_valid] [get_bd_pins conf_valid/dout]
  connect_bd_net -net conf_vec_dout [get_bd_pins conf_vec] [get_bd_pins conf_vec/dout]
  connect_bd_net -net phyaddr_dout [get_bd_pins phyaddr] [get_bd_pins phyaddr/dout]
  connect_bd_net -net signal_det_dout [get_bd_pins signal_det] [get_bd_pins signal_det/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sfp2
proc create_hier_cell_sfp2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sfp2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_gem_pcs_pma

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio_pcs_pma

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sfp


  # Create pins
  create_bd_pin -dir I -from 94 -to 0 Din
  create_bd_pin -dir I -type clk gtrefclk
  create_bd_pin -dir I -type clk independent_clock_bufg
  create_bd_pin -dir I mmcm_locked
  create_bd_pin -dir I -type rst pma_reset
  create_bd_pin -dir I -type clk rxuserclk
  create_bd_pin -dir I -type clk rxuserclk2
  create_bd_pin -dir I -type clk userclk
  create_bd_pin -dir I -type clk userclk2

  # Create instance: config_const
  create_hier_cell_config_const_2 $hier_obj config_const

  # Create instance: gig_ethernet_pcs_pma_0, and set properties
  set gig_ethernet_pcs_pma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gig_ethernet_pcs_pma:16.1 gig_ethernet_pcs_pma_0 ]
  set_property -dict [ list \
   CONFIG.Auto_Negotiation {false} \
   CONFIG.DrpClkRate {49.9995} \
   CONFIG.EMAC_IF_TEMAC {GEM} \
   CONFIG.RefClkRate {156.25} \
   CONFIG.Standard {SGMII} \
   CONFIG.SupportLevel {Include_Shared_Logic_in_Example_Design} \
   CONFIG.TransceiverControl {false} \
 ] $gig_ethernet_pcs_pma_0

  # Create instance: rst_slice, and set properties
  set rst_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 rst_slice ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $rst_slice

  # Create interface connections
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_0_sgmii [get_bd_intf_pins sfp] [get_bd_intf_pins gig_ethernet_pcs_pma_0/sgmii]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_GMII_ENET0 [get_bd_intf_pins gmii_gem_pcs_pma] [get_bd_intf_pins gig_ethernet_pcs_pma_0/gmii_gem_pcs_pma]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_MDIO_ENET0 [get_bd_intf_pins mdio_pcs_pma] [get_bd_intf_pins gig_ethernet_pcs_pma_0/mdio_pcs_pma]

  # Create port connections
  connect_bd_net -net config_const_dout [get_bd_pins config_const/phyaddr] [get_bd_pins gig_ethernet_pcs_pma_0/phyaddr]
  connect_bd_net -net config_const_dout1 [get_bd_pins config_const/conf_vec] [get_bd_pins gig_ethernet_pcs_pma_0/configuration_vector]
  connect_bd_net -net config_const_dout2 [get_bd_pins config_const/conf_valid] [get_bd_pins gig_ethernet_pcs_pma_0/configuration_valid]
  connect_bd_net -net config_const_dout3 [get_bd_pins config_const/signal_det] [get_bd_pins gig_ethernet_pcs_pma_0/signal_detect]
  connect_bd_net -net gtrefclk_1 [get_bd_pins gtrefclk] [get_bd_pins gig_ethernet_pcs_pma_0/gtrefclk]
  connect_bd_net -net mmcm_locked_1 [get_bd_pins mmcm_locked] [get_bd_pins gig_ethernet_pcs_pma_0/mmcm_locked]
  connect_bd_net -net pma_reset_1 [get_bd_pins pma_reset] [get_bd_pins gig_ethernet_pcs_pma_0/pma_reset]
  connect_bd_net -net rst_slice_Dout [get_bd_pins gig_ethernet_pcs_pma_0/reset] [get_bd_pins rst_slice/Dout]
  connect_bd_net -net rxuserclk2_1 [get_bd_pins rxuserclk2] [get_bd_pins gig_ethernet_pcs_pma_0/rxuserclk2]
  connect_bd_net -net rxuserclk_1 [get_bd_pins rxuserclk] [get_bd_pins gig_ethernet_pcs_pma_0/rxuserclk]
  connect_bd_net -net userclk2_1 [get_bd_pins userclk2] [get_bd_pins gig_ethernet_pcs_pma_0/userclk2]
  connect_bd_net -net userclk_1 [get_bd_pins userclk] [get_bd_pins gig_ethernet_pcs_pma_0/userclk]
  connect_bd_net -net zynq_ultra_ps_e_0_emio_gpio_o [get_bd_pins Din] [get_bd_pins rst_slice/Din]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins independent_clock_bufg] [get_bd_pins gig_ethernet_pcs_pma_0/independent_clock_bufg]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sfp1
proc create_hier_cell_sfp1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sfp1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_gem_pcs_pma

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio_pcs_pma

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sfp


  # Create pins
  create_bd_pin -dir I -from 94 -to 0 Din
  create_bd_pin -dir I -type clk gtrefclk
  create_bd_pin -dir I -type clk independent_clock_bufg
  create_bd_pin -dir I mmcm_locked
  create_bd_pin -dir I -type rst pma_reset
  create_bd_pin -dir I -type clk rxuserclk
  create_bd_pin -dir I -type clk rxuserclk2
  create_bd_pin -dir I -type clk userclk
  create_bd_pin -dir I -type clk userclk2

  # Create instance: config_const
  create_hier_cell_config_const_1 $hier_obj config_const

  # Create instance: gig_ethernet_pcs_pma_0, and set properties
  set gig_ethernet_pcs_pma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gig_ethernet_pcs_pma:16.1 gig_ethernet_pcs_pma_0 ]
  set_property -dict [ list \
   CONFIG.Auto_Negotiation {false} \
   CONFIG.DrpClkRate {49.9995} \
   CONFIG.EMAC_IF_TEMAC {GEM} \
   CONFIG.RefClkRate {156.25} \
   CONFIG.Standard {SGMII} \
   CONFIG.SupportLevel {Include_Shared_Logic_in_Example_Design} \
   CONFIG.TransceiverControl {false} \
 ] $gig_ethernet_pcs_pma_0

  # Create instance: rst_slice, and set properties
  set rst_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 rst_slice ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $rst_slice

  # Create interface connections
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_0_sgmii [get_bd_intf_pins sfp] [get_bd_intf_pins gig_ethernet_pcs_pma_0/sgmii]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_GMII_ENET0 [get_bd_intf_pins gmii_gem_pcs_pma] [get_bd_intf_pins gig_ethernet_pcs_pma_0/gmii_gem_pcs_pma]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_MDIO_ENET0 [get_bd_intf_pins mdio_pcs_pma] [get_bd_intf_pins gig_ethernet_pcs_pma_0/mdio_pcs_pma]

  # Create port connections
  connect_bd_net -net config_const_dout [get_bd_pins config_const/phyaddr] [get_bd_pins gig_ethernet_pcs_pma_0/phyaddr]
  connect_bd_net -net config_const_dout1 [get_bd_pins config_const/conf_vec] [get_bd_pins gig_ethernet_pcs_pma_0/configuration_vector]
  connect_bd_net -net config_const_dout2 [get_bd_pins config_const/conf_valid] [get_bd_pins gig_ethernet_pcs_pma_0/configuration_valid]
  connect_bd_net -net config_const_dout3 [get_bd_pins config_const/signal_det] [get_bd_pins gig_ethernet_pcs_pma_0/signal_detect]
  connect_bd_net -net gtrefclk_1 [get_bd_pins gtrefclk] [get_bd_pins gig_ethernet_pcs_pma_0/gtrefclk]
  connect_bd_net -net mmcm_locked_1 [get_bd_pins mmcm_locked] [get_bd_pins gig_ethernet_pcs_pma_0/mmcm_locked]
  connect_bd_net -net pma_reset_1 [get_bd_pins pma_reset] [get_bd_pins gig_ethernet_pcs_pma_0/pma_reset]
  connect_bd_net -net rst_slice_Dout [get_bd_pins gig_ethernet_pcs_pma_0/reset] [get_bd_pins rst_slice/Dout]
  connect_bd_net -net rxuserclk2_1 [get_bd_pins rxuserclk2] [get_bd_pins gig_ethernet_pcs_pma_0/rxuserclk2]
  connect_bd_net -net rxuserclk_1 [get_bd_pins rxuserclk] [get_bd_pins gig_ethernet_pcs_pma_0/rxuserclk]
  connect_bd_net -net userclk2_1 [get_bd_pins userclk2] [get_bd_pins gig_ethernet_pcs_pma_0/userclk2]
  connect_bd_net -net userclk_1 [get_bd_pins userclk] [get_bd_pins gig_ethernet_pcs_pma_0/userclk]
  connect_bd_net -net zynq_ultra_ps_e_0_emio_gpio_o [get_bd_pins Din] [get_bd_pins rst_slice/Din]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins independent_clock_bufg] [get_bd_pins gig_ethernet_pcs_pma_0/independent_clock_bufg]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sfp0
proc create_hier_cell_sfp0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sfp0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_gem_pcs_pma

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_refclk

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio_pcs_pma

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sfp


  # Create pins
  create_bd_pin -dir I -from 94 -to 0 Din
  create_bd_pin -dir O -type clk gtrefclk_out
  create_bd_pin -dir I -type clk independent_clock_bufg
  create_bd_pin -dir O mmcm_locked_out
  create_bd_pin -dir O -type rst pma_reset_out
  create_bd_pin -dir O -type clk rxuserclk2_out
  create_bd_pin -dir O -type clk rxuserclk_out
  create_bd_pin -dir O -type clk userclk2_out
  create_bd_pin -dir O -type clk userclk_out

  # Create instance: config_const
  create_hier_cell_config_const $hier_obj config_const

  # Create instance: gig_ethernet_pcs_pma_0, and set properties
  set gig_ethernet_pcs_pma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gig_ethernet_pcs_pma:16.1 gig_ethernet_pcs_pma_0 ]
  set_property -dict [ list \
   CONFIG.Auto_Negotiation {false} \
   CONFIG.DrpClkRate {49.9995} \
   CONFIG.EMAC_IF_TEMAC {GEM} \
   CONFIG.RefClkRate {156.25} \
   CONFIG.Standard {SGMII} \
   CONFIG.SupportLevel {Include_Shared_Logic_in_Core} \
   CONFIG.TransceiverControl {false} \
 ] $gig_ethernet_pcs_pma_0

  # Create instance: rst_slice, and set properties
  set rst_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 rst_slice ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {95} \
 ] $rst_slice

  # Create interface connections
  connect_bd_intf_net -intf_net diff_clock_rtl_0_1 [get_bd_intf_pins gt_refclk] [get_bd_intf_pins gig_ethernet_pcs_pma_0/gtrefclk_in]
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_0_sgmii [get_bd_intf_pins sfp] [get_bd_intf_pins gig_ethernet_pcs_pma_0/sgmii]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_GMII_ENET0 [get_bd_intf_pins gmii_gem_pcs_pma] [get_bd_intf_pins gig_ethernet_pcs_pma_0/gmii_gem_pcs_pma]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_MDIO_ENET0 [get_bd_intf_pins mdio_pcs_pma] [get_bd_intf_pins gig_ethernet_pcs_pma_0/mdio_pcs_pma]

  # Create port connections
  connect_bd_net -net config_const_dout [get_bd_pins config_const/phyaddr] [get_bd_pins gig_ethernet_pcs_pma_0/phyaddr]
  connect_bd_net -net config_const_dout1 [get_bd_pins config_const/conf_vec] [get_bd_pins gig_ethernet_pcs_pma_0/configuration_vector]
  connect_bd_net -net config_const_dout2 [get_bd_pins config_const/conf_valid] [get_bd_pins gig_ethernet_pcs_pma_0/configuration_valid]
  connect_bd_net -net config_const_dout3 [get_bd_pins config_const/signal_det] [get_bd_pins gig_ethernet_pcs_pma_0/signal_detect]
  connect_bd_net -net gig_ethernet_pcs_pma_0_gtrefclk_out [get_bd_pins gtrefclk_out] [get_bd_pins gig_ethernet_pcs_pma_0/gtrefclk_out]
  connect_bd_net -net gig_ethernet_pcs_pma_0_mmcm_locked_out [get_bd_pins mmcm_locked_out] [get_bd_pins gig_ethernet_pcs_pma_0/mmcm_locked_out]
  connect_bd_net -net gig_ethernet_pcs_pma_0_pma_reset_out [get_bd_pins pma_reset_out] [get_bd_pins gig_ethernet_pcs_pma_0/pma_reset_out]
  connect_bd_net -net gig_ethernet_pcs_pma_0_rxuserclk2_out [get_bd_pins rxuserclk2_out] [get_bd_pins gig_ethernet_pcs_pma_0/rxuserclk2_out]
  connect_bd_net -net gig_ethernet_pcs_pma_0_rxuserclk_out [get_bd_pins rxuserclk_out] [get_bd_pins gig_ethernet_pcs_pma_0/rxuserclk_out]
  connect_bd_net -net gig_ethernet_pcs_pma_0_userclk2_out [get_bd_pins userclk2_out] [get_bd_pins gig_ethernet_pcs_pma_0/userclk2_out]
  connect_bd_net -net gig_ethernet_pcs_pma_0_userclk_out [get_bd_pins userclk_out] [get_bd_pins gig_ethernet_pcs_pma_0/userclk_out]
  connect_bd_net -net rst_slice_Dout [get_bd_pins gig_ethernet_pcs_pma_0/reset] [get_bd_pins rst_slice/Dout]
  connect_bd_net -net zynq_ultra_ps_e_0_emio_gpio_o [get_bd_pins Din] [get_bd_pins rst_slice/Din]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins independent_clock_bufg] [get_bd_pins gig_ethernet_pcs_pma_0/independent_clock_bufg]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sgmii
proc create_hier_cell_sgmii { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sgmii() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_gem_pcs_pma

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_gem_pcs_pma1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii_gem_pcs_pma2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_refclk

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio_pcs_pma

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio_pcs_pma1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio_pcs_pma2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sfp0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sfp1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sfp2


  # Create pins
  create_bd_pin -dir I -from 94 -to 0 Din
  create_bd_pin -dir I -type clk independent_clock_bufg

  # Create instance: sfp0
  create_hier_cell_sfp0 $hier_obj sfp0

  # Create instance: sfp1
  create_hier_cell_sfp1 $hier_obj sfp1

  # Create instance: sfp2
  create_hier_cell_sfp2 $hier_obj sfp2

  # Create interface connections
  connect_bd_intf_net -intf_net diff_clock_rtl_0_1 [get_bd_intf_pins gt_refclk] [get_bd_intf_pins sfp0/gt_refclk]
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_0_sgmii [get_bd_intf_pins sfp0] [get_bd_intf_pins sfp0/sfp]
  connect_bd_intf_net -intf_net gmii_gem_pcs_pma_1 [get_bd_intf_pins gmii_gem_pcs_pma1] [get_bd_intf_pins sfp2/gmii_gem_pcs_pma]
  connect_bd_intf_net -intf_net mdio_pcs_pma_1 [get_bd_intf_pins mdio_pcs_pma1] [get_bd_intf_pins sfp2/mdio_pcs_pma]
  connect_bd_intf_net -intf_net sfp1_sfp [get_bd_intf_pins sfp1] [get_bd_intf_pins sfp1/sfp]
  connect_bd_intf_net -intf_net sfp2_sfp [get_bd_intf_pins sfp2] [get_bd_intf_pins sfp2/sfp]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_GMII_ENET0 [get_bd_intf_pins gmii_gem_pcs_pma2] [get_bd_intf_pins sfp0/gmii_gem_pcs_pma]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_GMII_ENET1 [get_bd_intf_pins gmii_gem_pcs_pma] [get_bd_intf_pins sfp1/gmii_gem_pcs_pma]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_MDIO_ENET0 [get_bd_intf_pins mdio_pcs_pma2] [get_bd_intf_pins sfp0/mdio_pcs_pma]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_MDIO_ENET1 [get_bd_intf_pins mdio_pcs_pma] [get_bd_intf_pins sfp1/mdio_pcs_pma]

  # Create port connections
  connect_bd_net -net mmcm_locked_1 [get_bd_pins sfp0/mmcm_locked_out] [get_bd_pins sfp1/mmcm_locked] [get_bd_pins sfp2/mmcm_locked]
  connect_bd_net -net pma_reset_1 [get_bd_pins sfp0/pma_reset_out] [get_bd_pins sfp1/pma_reset] [get_bd_pins sfp2/pma_reset]
  connect_bd_net -net sfp0_gtrefclk_out [get_bd_pins sfp0/gtrefclk_out] [get_bd_pins sfp1/gtrefclk] [get_bd_pins sfp2/gtrefclk]
  connect_bd_net -net sfp0_rxuserclk2_out [get_bd_pins sfp0/rxuserclk2_out] [get_bd_pins sfp1/rxuserclk2] [get_bd_pins sfp2/rxuserclk2]
  connect_bd_net -net sfp0_rxuserclk_out [get_bd_pins sfp0/rxuserclk_out] [get_bd_pins sfp1/rxuserclk] [get_bd_pins sfp2/rxuserclk]
  connect_bd_net -net sfp0_userclk2_out [get_bd_pins sfp0/userclk2_out] [get_bd_pins sfp1/userclk2] [get_bd_pins sfp2/userclk2]
  connect_bd_net -net sfp0_userclk_out [get_bd_pins sfp0/userclk_out] [get_bd_pins sfp1/userclk] [get_bd_pins sfp2/userclk]
  connect_bd_net -net zynq_ultra_ps_e_0_emio_gpio_o [get_bd_pins Din] [get_bd_pins sfp0/Din] [get_bd_pins sfp1/Din] [get_bd_pins sfp2/Din]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins independent_clock_bufg] [get_bd_pins sfp0/independent_clock_bufg] [get_bd_pins sfp1/independent_clock_bufg] [get_bd_pins sfp2/independent_clock_bufg]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: radio_rfdc
proc create_hier_cell_radio_rfdc { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_radio_rfdc() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dac0_clk

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s00_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_usp_rf_data_converter:diff_pins_rtl:1.0 sysref_in

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout00


  # Create pins
  create_bd_pin -dir O -type clk s0_axis_aclk
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: pll_dac0_x_clk_25M, and set properties
  set pll_dac0_x_clk_25M [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 pll_dac0_x_clk_25M ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {319.196} \
   CONFIG.CLKOUT1_PHASE_ERROR {351.718} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {77.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {48.125} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_RESET {false} \
 ] $pll_dac0_x_clk_25M

  # Create instance: usp_rf_data_converter_0, and set properties
  set usp_rf_data_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:usp_rf_data_converter:2.1 usp_rf_data_converter_0 ]
  set_property -dict [ list \
   CONFIG.ADC0_Enable {0} \
   CONFIG.ADC0_Fabric_Freq {0.0} \
   CONFIG.ADC_Data_Type00 {1} \
   CONFIG.ADC_Data_Type01 {1} \
   CONFIG.ADC_Data_Width00 {6} \
   CONFIG.ADC_Data_Width01 {6} \
   CONFIG.ADC_Decimation_Mode00 {0} \
   CONFIG.ADC_Decimation_Mode01 {0} \
   CONFIG.ADC_Mixer_Mode00 {0} \
   CONFIG.ADC_Mixer_Mode01 {0} \
   CONFIG.ADC_Mixer_Type00 {3} \
   CONFIG.ADC_Mixer_Type01 {3} \
   CONFIG.ADC_NCO_Freq00 {0.8} \
   CONFIG.ADC_Slice00_Enable {false} \
   CONFIG.ADC_Slice01_Enable {false} \
   CONFIG.DAC0_Enable {1} \
   CONFIG.DAC0_Fabric_Freq {25.000} \
   CONFIG.DAC0_Outclk_Freq {15.625} \
   CONFIG.DAC0_PLL_Enable {true} \
   CONFIG.DAC0_Refclk_Freq {300.000} \
   CONFIG.DAC0_Sampling_Rate {0.5} \
   CONFIG.DAC1_Enable {0} \
   CONFIG.DAC1_Fabric_Freq {0.0} \
   CONFIG.DAC1_Outclk_Freq {31.250} \
   CONFIG.DAC1_PLL_Enable {false} \
   CONFIG.DAC1_Refclk_Freq {500.000} \
   CONFIG.DAC1_Sampling_Rate {0.5} \
   CONFIG.DAC_Data_Width00 {10} \
   CONFIG.DAC_Interpolation_Mode00 {4} \
   CONFIG.DAC_Interpolation_Mode10 {0} \
   CONFIG.DAC_Invsinc_Ctrl00 {true} \
   CONFIG.DAC_Mixer_Mode00 {0} \
   CONFIG.DAC_Mixer_Type00 {2} \
   CONFIG.DAC_Mixer_Type10 {3} \
   CONFIG.DAC_NCO_Freq00 {1.2} \
   CONFIG.DAC_Nyquist00 {1} \
   CONFIG.DAC_Slice00_Enable {true} \
   CONFIG.DAC_Slice10_Enable {false} \
 ] $usp_rf_data_converter_0

  # Create interface connections
  connect_bd_intf_net -intf_net dac0_clk_1 [get_bd_intf_pins dac0_clk] [get_bd_intf_pins usp_rf_data_converter_0/dac0_clk]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins s_axi] [get_bd_intf_pins usp_rf_data_converter_0/s_axi]
  connect_bd_intf_net -intf_net sysref_in_1 [get_bd_intf_pins sysref_in] [get_bd_intf_pins usp_rf_data_converter_0/sysref_in]
  connect_bd_intf_net -intf_net tx_pulse_shaping_and_interpolation_5_M_AXIS_DATA [get_bd_intf_pins s00_axis] [get_bd_intf_pins usp_rf_data_converter_0/s00_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_vout00 [get_bd_intf_pins vout00] [get_bd_intf_pins usp_rf_data_converter_0/vout00]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins s0_axis_aclk] [get_bd_pins pll_dac0_x_clk_25M/clk_out1] [get_bd_pins usp_rf_data_converter_0/s0_axis_aclk]
  connect_bd_net -net rst_ps8_0_49M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins usp_rf_data_converter_0/s_axi_aresetn]
  connect_bd_net -net usp_rf_data_converter_0_clk_dac0 [get_bd_pins pll_dac0_x_clk_25M/clk_in1] [get_bd_pins usp_rf_data_converter_0/clk_dac0]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins s_axi_aclk] [get_bd_pins usp_rf_data_converter_0/s_axi_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: dma_hpc_config
proc create_hier_cell_dma_hpc_config { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_dma_hpc_config() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 3 -to 0 dout
  create_bd_pin -dir O -from 2 -to 0 dout1

  # Create instance: axcache_coherenet, and set properties
  set axcache_coherenet [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 axcache_coherenet ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {11} \
   CONFIG.CONST_WIDTH {4} \
 ] $axcache_coherenet

  # Create instance: axprot_unsecure, and set properties
  set axprot_unsecure [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 axprot_unsecure ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {2} \
   CONFIG.CONST_WIDTH {3} \
 ] $axprot_unsecure

  # Create port connections
  connect_bd_net -net axcache_coherenet_dout [get_bd_pins dout] [get_bd_pins axcache_coherenet/dout]
  connect_bd_net -net axprot_unsecure_dout [get_bd_pins dout1] [get_bd_pins axprot_unsecure/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: RF_interface_conv_Xband
proc create_hier_cell_RF_interface_conv_Xband { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_RF_interface_conv_Xband() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk m_axi_sg_aclk
  create_bd_pin -dir I -type clk m_axis_aclk
  create_bd_pin -dir O -type intr mm2s_introut
  create_bd_pin -dir O -type intr s2mm_introut

  # Create instance: axi_dma_Xband_txrx, and set properties
  set axi_dma_Xband_txrx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_Xband_txrx ]
  set_property -dict [ list \
   CONFIG.c_addr_width {64} \
   CONFIG.c_m_axi_mm2s_data_width {128} \
   CONFIG.c_m_axis_mm2s_tdata_width {128} \
   CONFIG.c_mm2s_burst_size {256} \
   CONFIG.c_s2mm_burst_size {256} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $axi_dma_Xband_txrx

  # Create instance: axis_data_fifo_Xband_tx_dac0, and set properties
  set axis_data_fifo_Xband_tx_dac0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_Xband_tx_dac0 ]
  set_property -dict [ list \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_Xband_tx_dac0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_Xband_txrx_M_AXIS_MM2S [get_bd_intf_pins axi_dma_Xband_txrx/M_AXIS_MM2S] [get_bd_intf_pins axis_data_fifo_Xband_tx_dac0/S_AXIS]
  connect_bd_intf_net -intf_net axi_dma_Xband_txrx_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_dma_Xband_txrx/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_dma_Xband_txrx_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_dma_Xband_txrx/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_dma_Xband_txrx_M_AXI_SG [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins axi_dma_Xband_txrx/M_AXI_SG]
  connect_bd_intf_net -intf_net axis_data_fifo_Xband_tx_dac0_M_AXIS [get_bd_intf_pins M_AXIS] [get_bd_intf_pins axis_data_fifo_Xband_tx_dac0/M_AXIS]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M01_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_dma_Xband_txrx/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net axi_dma_Xband_txrx_mm2s_introut [get_bd_pins mm2s_introut] [get_bd_pins axi_dma_Xband_txrx/mm2s_introut]
  connect_bd_net -net axi_dma_Xband_txrx_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_dma_Xband_txrx/s2mm_introut]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins m_axis_aclk] [get_bd_pins axis_data_fifo_Xband_tx_dac0/m_axis_aclk]
  connect_bd_net -net rst_ps8_0_49M_peripheral_aresetn [get_bd_pins axi_resetn] [get_bd_pins axi_dma_Xband_txrx/axi_resetn] [get_bd_pins axis_data_fifo_Xband_tx_dac0/s_axis_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins m_axi_sg_aclk] [get_bd_pins axi_dma_Xband_txrx/m_axi_mm2s_aclk] [get_bd_pins axi_dma_Xband_txrx/m_axi_s2mm_aclk] [get_bd_pins axi_dma_Xband_txrx/m_axi_sg_aclk] [get_bd_pins axi_dma_Xband_txrx/s_axi_lite_aclk] [get_bd_pins axis_data_fifo_Xband_tx_dac0/s_axis_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: QPSK_TX_on_Xband_dac0
proc create_hier_cell_QPSK_TX_on_Xband_dac0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_QPSK_TX_on_Xband_dac0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_DATA

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst ext_reset_in

  # Create instance: QPSK_data_converter_0, and set properties
  set block_name QPSK_data_converter
  set block_cell_name QPSK_data_converter_0
  if { [catch {set QPSK_data_converter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $QPSK_data_converter_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Repeater_0, and set properties
  set block_name Repeater
  set block_cell_name Repeater_0
  if { [catch {set Repeater_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Repeater_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {5} \
 ] $Repeater_0

  # Create instance: axis_dwidth_converter_0, and set properties
  set axis_dwidth_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_0 ]
  set_property USER_COMMENTS.comment_5 "QPSK TX on X-band
bitrate = 10Mbps" [get_bd_cells /QPSK_TX_on_Xband_dac0/axis_dwidth_converter_0]
  set_property -dict [ list \
   CONFIG.M_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_converter_0

  # Create instance: reset_dac0_x_25M, and set properties
  set reset_dac0_x_25M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_dac0_x_25M ]

  # Create instance: resetn_to_reset, and set properties
  set resetn_to_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 resetn_to_reset ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $resetn_to_reset

  # Create instance: tx_pulse_shaping_and_interpolation_5, and set properties
  set tx_pulse_shaping_and_interpolation_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 tx_pulse_shaping_and_interpolation_5 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {300.0} \
   CONFIG.CoefficientVector {0.00060376,0.0023763,0.0042877,0.0042126,-2.5988e-18,-0.0088264,-0.019625,-0.026479,-0.0219,6.1232e-18,0.04015,0.092677,0.14578,0.18535,0.2,0.18535,0.14578,0.092677,0.04015,6.1232e-18,-0.0219,-0.026479,-0.019625,-0.0088264,-2.5988e-18,0.0042126,0.0042877,0.0023763,0.00060376} \
   CONFIG.Coefficient_Fractional_Bits {17} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {6} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Interpolation} \
   CONFIG.Interpolation_Rate {5} \
   CONFIG.M_DATA_Has_TREADY {true} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Quantize_Only} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {0.001} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $tx_pulse_shaping_and_interpolation_5

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_dwidth_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net QPSK_data_converter_0_axis_out [get_bd_intf_pins QPSK_data_converter_0/axis_out] [get_bd_intf_pins Repeater_0/axis_in]
  connect_bd_intf_net -intf_net Repeater_0_axis_out [get_bd_intf_pins Repeater_0/axis_out] [get_bd_intf_pins tx_pulse_shaping_and_interpolation_5/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins QPSK_data_converter_0/axis_in] [get_bd_intf_pins axis_dwidth_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net tx_pulse_shaping_and_interpolation_5_M_AXIS_DATA [get_bd_intf_pins M_AXIS_DATA] [get_bd_intf_pins tx_pulse_shaping_and_interpolation_5/M_AXIS_DATA]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins aclk] [get_bd_pins QPSK_data_converter_0/clk] [get_bd_pins Repeater_0/clk] [get_bd_pins axis_dwidth_converter_0/aclk] [get_bd_pins reset_dac0_x_25M/slowest_sync_clk] [get_bd_pins tx_pulse_shaping_and_interpolation_5/aclk]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axis_dwidth_converter_0/aresetn] [get_bd_pins reset_dac0_x_25M/peripheral_aresetn] [get_bd_pins resetn_to_reset/Op1]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins QPSK_data_converter_0/reset] [get_bd_pins Repeater_0/reset] [get_bd_pins resetn_to_reset/Res]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins ext_reset_in] [get_bd_pins reset_dac0_x_25M/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set dac0_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dac0_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000.0} \
   ] $dac0_clk

  set gt_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_refclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $gt_refclk

  set sfp0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sfp0 ]

  set sfp1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sfp1 ]

  set sfp2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sgmii_rtl:1.0 sfp2 ]

  set sysref_in [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_usp_rf_data_converter:diff_pins_rtl:1.0 sysref_in ]

  set vout00 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout00 ]


  # Create ports

  # Create instance: QPSK_TX_on_Xband_dac0
  create_hier_cell_QPSK_TX_on_Xband_dac0 [current_bd_instance .] QPSK_TX_on_Xband_dac0

  # Create instance: RF_interface_conv_Xband
  create_hier_cell_RF_interface_conv_Xband [current_bd_instance .] RF_interface_conv_Xband

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [ list \
   CONFIG.NUM_SI {3} \
 ] $axi_smc

  # Create instance: concat_interrupt, and set properties
  set concat_interrupt [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_interrupt ]

  # Create instance: dma_hpc_config
  create_hier_cell_dma_hpc_config [current_bd_instance .] dma_hpc_config

  # Create instance: ps8_0_axi_periph, and set properties
  set ps8_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps8_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
 ] $ps8_0_axi_periph

  # Create instance: radio_rfdc
  create_hier_cell_radio_rfdc [current_bd_instance .] radio_rfdc

  # Create instance: rst_ps8_0_49M, and set properties
  set rst_ps8_0_49M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_49M ]

  # Create instance: sgmii
  create_hier_cell_sgmii [current_bd_instance .] sgmii

  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0 ]
  set_property -dict [ list \
   CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
   CONFIG.PSU_MIO_0_DIRECTION {out} \
   CONFIG.PSU_MIO_0_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_0_POLARITY {Default} \
   CONFIG.PSU_MIO_13_DIRECTION {inout} \
   CONFIG.PSU_MIO_13_POLARITY {Default} \
   CONFIG.PSU_MIO_14_DIRECTION {inout} \
   CONFIG.PSU_MIO_14_POLARITY {Default} \
   CONFIG.PSU_MIO_15_DIRECTION {inout} \
   CONFIG.PSU_MIO_15_POLARITY {Default} \
   CONFIG.PSU_MIO_16_DIRECTION {inout} \
   CONFIG.PSU_MIO_16_POLARITY {Default} \
   CONFIG.PSU_MIO_17_DIRECTION {inout} \
   CONFIG.PSU_MIO_17_POLARITY {Default} \
   CONFIG.PSU_MIO_18_DIRECTION {inout} \
   CONFIG.PSU_MIO_18_POLARITY {Default} \
   CONFIG.PSU_MIO_19_DIRECTION {inout} \
   CONFIG.PSU_MIO_19_POLARITY {Default} \
   CONFIG.PSU_MIO_1_DIRECTION {in} \
   CONFIG.PSU_MIO_1_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_1_POLARITY {Default} \
   CONFIG.PSU_MIO_1_SLEW {fast} \
   CONFIG.PSU_MIO_20_DIRECTION {inout} \
   CONFIG.PSU_MIO_20_POLARITY {Default} \
   CONFIG.PSU_MIO_21_DIRECTION {inout} \
   CONFIG.PSU_MIO_21_POLARITY {Default} \
   CONFIG.PSU_MIO_22_DIRECTION {out} \
   CONFIG.PSU_MIO_22_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_22_POLARITY {Default} \
   CONFIG.PSU_MIO_23_DIRECTION {out} \
   CONFIG.PSU_MIO_23_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_23_POLARITY {Default} \
   CONFIG.PSU_MIO_26_DIRECTION {in} \
   CONFIG.PSU_MIO_26_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_26_POLARITY {Default} \
   CONFIG.PSU_MIO_26_SLEW {fast} \
   CONFIG.PSU_MIO_27_DIRECTION {out} \
   CONFIG.PSU_MIO_27_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_27_POLARITY {Default} \
   CONFIG.PSU_MIO_28_DIRECTION {out} \
   CONFIG.PSU_MIO_28_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_28_POLARITY {Default} \
   CONFIG.PSU_MIO_29_DIRECTION {in} \
   CONFIG.PSU_MIO_29_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_29_POLARITY {Default} \
   CONFIG.PSU_MIO_29_SLEW {fast} \
   CONFIG.PSU_MIO_34_DIRECTION {in} \
   CONFIG.PSU_MIO_34_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_34_POLARITY {Default} \
   CONFIG.PSU_MIO_34_SLEW {fast} \
   CONFIG.PSU_MIO_35_DIRECTION {out} \
   CONFIG.PSU_MIO_35_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_35_POLARITY {Default} \
   CONFIG.PSU_MIO_4_DIRECTION {out} \
   CONFIG.PSU_MIO_4_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_4_POLARITY {Default} \
   CONFIG.PSU_MIO_5_DIRECTION {out} \
   CONFIG.PSU_MIO_5_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_5_POLARITY {Default} \
   CONFIG.PSU_MIO_6_DIRECTION {in} \
   CONFIG.PSU_MIO_6_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_6_POLARITY {Default} \
   CONFIG.PSU_MIO_6_SLEW {fast} \
   CONFIG.PSU_MIO_7_DIRECTION {out} \
   CONFIG.PSU_MIO_7_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_7_POLARITY {Default} \
   CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash###Quad SPI Flash#Quad SPI Flash########SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0###CAN 0#CAN 0#CAN 1#CAN 1#####UART 0#UART 0##########################################} \
   CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1###mosi_mi0#n_ss_out########sdio0_data_out[0]#sdio0_data_out[1]#sdio0_data_out[2]#sdio0_data_out[3]#sdio0_data_out[4]#sdio0_data_out[5]#sdio0_data_out[6]#sdio0_data_out[7]#sdio0_cmd_out#sdio0_clk_out#sdio0_bus_pow###phy_rx#phy_tx#phy_tx#phy_rx#####rxd#txd##########################################} \
   CONFIG.PSU_SD0_INTERNAL_BUS_WIDTH {8} \
   CONFIG.PSU__ACT_DDR_FREQ_MHZ {799.992004} \
   CONFIG.PSU__AFI0_COHERENCY {0} \
   CONFIG.PSU__CAN0__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__CAN0__PERIPHERAL__IO {MIO 26 .. 27} \
   CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__CAN1__PERIPHERAL__IO {MIO 28 .. 29} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1333.320068} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {80} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {399.996002} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {800} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {599.994019} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {63} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {10} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {599.994019} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {533.328003} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {64} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {533.328003} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {49.999500} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {30} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {533.328003} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.984985} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__ACT_FREQMHZ {124.998749} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__ACT_FREQMHZ {124.998749} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__ACT_FREQMHZ {124.998749} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {266.664001} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {533.328003} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.498123} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {49.999500} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {30} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {50} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {23.809286} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {63} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {187.498123} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {64} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__ACT_FREQMHZ {177.776001} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {33.333000} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {15} \
   CONFIG.PSU__DDRC__BG_ADDR_COUNT {1} \
   CONFIG.PSU__DDRC__CL {12} \
   CONFIG.PSU__DDRC__CWL {11} \
   CONFIG.PSU__DDRC__DEVICE_CAPACITY {8192 MBits} \
   CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits} \
   CONFIG.PSU__DDRC__ROW_ADDR_COUNT {16} \
   CONFIG.PSU__DDRC__SB_TARGET {18-18-18} \
   CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2400U} \
   CONFIG.PSU__DDRC__T_FAW {13} \
   CONFIG.PSU__DDRC__T_RAS_MIN {32.0} \
   CONFIG.PSU__DDRC__T_RC {47} \
   CONFIG.PSU__DDRC__T_RCD {18} \
   CONFIG.PSU__DDRC__T_RP {18} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
   CONFIG.PSU__DDR__INTERFACE__FREQMHZ {400.000} \
   CONFIG.PSU__DLL__ISUSED {1} \
   CONFIG.PSU__ENET0__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {1} \
   CONFIG.PSU__ENET0__GRP_MDIO__IO {EMIO} \
   CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__ENET0__PERIPHERAL__IO {EMIO} \
   CONFIG.PSU__ENET0__PTP__ENABLE {0} \
   CONFIG.PSU__ENET0__TSU__ENABLE {1} \
   CONFIG.PSU__ENET1__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET1__GRP_MDIO__ENABLE {1} \
   CONFIG.PSU__ENET1__GRP_MDIO__IO {EMIO} \
   CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__ENET1__PERIPHERAL__IO {EMIO} \
   CONFIG.PSU__ENET1__PTP__ENABLE {0} \
   CONFIG.PSU__ENET1__TSU__ENABLE {1} \
   CONFIG.PSU__ENET2__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET2__GRP_MDIO__ENABLE {1} \
   CONFIG.PSU__ENET2__GRP_MDIO__IO {EMIO} \
   CONFIG.PSU__ENET2__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__ENET2__PERIPHERAL__IO {EMIO} \
   CONFIG.PSU__ENET2__PTP__ENABLE {0} \
   CONFIG.PSU__ENET2__TSU__ENABLE {1} \
   CONFIG.PSU__FPGA_PL1_ENABLE {0} \
   CONFIG.PSU__GEM0_COHERENCY {0} \
   CONFIG.PSU__GEM0_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM1_COHERENCY {0} \
   CONFIG.PSU__GEM1_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM2_COHERENCY {0} \
   CONFIG.PSU__GEM2_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM__TSU__ENABLE {0} \
   CONFIG.PSU__GPIO_EMIO_WIDTH {95} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {95} \
   CONFIG.PSU__HIGH_ADDRESS__ENABLE {1} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
   CONFIG.PSU__PL_CLK1_BUF {FALSE} \
   CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;0|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;1|S_AXI_HP3_FPD:NA;0|S_AXI_HP2_FPD:NA;0|S_AXI_HP1_FPD:NA;0|S_AXI_HP0_FPD:NA;0|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;0|SD0:NonSecure;1|SATA1:NonSecure;0|SATA0:NonSecure;0|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;0|GEM2:NonSecure;1|GEM1:NonSecure;1|GEM0:NonSecure;1|FDMA:NonSecure;1|DP:NonSecure;0|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;0|LPD;USB3_0;FF9D0000;FF9DFFFF;0|LPD;UART1;FF010000;FF01FFFF;0|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;0|LPD;TTC2;FF130000;FF13FFFF;0|LPD;TTC1;FF120000;FF12FFFF;0|LPD;TTC0;FF110000;FF11FFFF;0|FPD;SWDT1;FD4D0000;FD4DFFFF;0|LPD;SWDT0;FF150000;FF15FFFF;0|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;0|LPD;SD0;FF160000;FF16FFFF;1|FPD;SATA;FD0C0000;FD0CFFFF;0|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;0|LPD;I2C0;FF020000;FF02FFFF;0|FPD;GPU;FD4B0000;FD4BFFFF;0|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;0|LPD;GEM2;FF0D0000;FF0DFFFF;1|LPD;GEM1;FF0C0000;FF0CFFFF;1|LPD;GEM0;FF0B0000;FF0BFFFF;1|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_GPV;FD700000;FD7FFFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;0|FPD;DPDMA;FD4C0000;FD4CFFFF;0|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;0|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|FPD;CCI_GPV;FD6E0000;FD6EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;1|LPD;CAN0;FF060000;FF06FFFF;1|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1} \
   CONFIG.PSU__QSPI_COHERENCY {0} \
   CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {0} \
   CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x1} \
   CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 5} \
   CONFIG.PSU__QSPI__PERIPHERAL__MODE {Single} \
   CONFIG.PSU__SAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__SD0_COHERENCY {0} \
   CONFIG.PSU__SD0_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__SD0__DATA_TRANSFER_MODE {8Bit} \
   CONFIG.PSU__SD0__GRP_CD__ENABLE {0} \
   CONFIG.PSU__SD0__GRP_POW__ENABLE {1} \
   CONFIG.PSU__SD0__GRP_POW__IO {MIO 23} \
   CONFIG.PSU__SD0__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD0__PERIPHERAL__IO {MIO 13 .. 22} \
   CONFIG.PSU__SD0__RESET__ENABLE {1} \
   CONFIG.PSU__SD0__SLOT_TYPE {eMMC} \
   CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
   CONFIG.PSU__UART0__BAUD_RATE {115200} \
   CONFIG.PSU__UART0__MODEM__ENABLE {0} \
   CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 34 .. 35} \
   CONFIG.PSU__USE__IRQ0 {1} \
   CONFIG.PSU__USE__M_AXI_GP0 {1} \
   CONFIG.PSU__USE__M_AXI_GP2 {0} \
   CONFIG.PSU__USE__S_AXI_GP0 {1} \
   CONFIG.SUBPRESET1 {Custom} \
 ] $zynq_ultra_ps_e_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_Xband_txrx_M_AXI_MM2S [get_bd_intf_pins RF_interface_conv_Xband/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_Xband_txrx_M_AXI_S2MM [get_bd_intf_pins RF_interface_conv_Xband/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_Xband_txrx_M_AXI_SG [get_bd_intf_pins RF_interface_conv_Xband/M_AXI_SG] [get_bd_intf_pins axi_smc/S00_AXI]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HPC0_FPD]
  connect_bd_intf_net -intf_net axis_data_fifo_Xband_tx_dac0_M_AXIS [get_bd_intf_pins QPSK_TX_on_Xband_dac0/S_AXIS] [get_bd_intf_pins RF_interface_conv_Xband/M_AXIS]
  connect_bd_intf_net -intf_net dac0_clk_1 [get_bd_intf_ports dac0_clk] [get_bd_intf_pins radio_rfdc/dac0_clk]
  connect_bd_intf_net -intf_net diff_clock_rtl_0_1 [get_bd_intf_ports gt_refclk] [get_bd_intf_pins sgmii/gt_refclk]
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_0_sgmii [get_bd_intf_ports sfp0] [get_bd_intf_pins sgmii/sfp0]
  connect_bd_intf_net -intf_net gmii_gem_pcs_pma_1 [get_bd_intf_pins sgmii/gmii_gem_pcs_pma1] [get_bd_intf_pins zynq_ultra_ps_e_0/GMII_ENET2]
  connect_bd_intf_net -intf_net mdio_pcs_pma_1 [get_bd_intf_pins sgmii/mdio_pcs_pma1] [get_bd_intf_pins zynq_ultra_ps_e_0/MDIO_ENET2]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins ps8_0_axi_periph/M00_AXI] [get_bd_intf_pins radio_rfdc/s_axi]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M01_AXI [get_bd_intf_pins RF_interface_conv_Xband/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net sfp1_sfp [get_bd_intf_ports sfp1] [get_bd_intf_pins sgmii/sfp1]
  connect_bd_intf_net -intf_net sfp2_sfp [get_bd_intf_ports sfp2] [get_bd_intf_pins sgmii/sfp2]
  connect_bd_intf_net -intf_net sysref_in_1 [get_bd_intf_ports sysref_in] [get_bd_intf_pins radio_rfdc/sysref_in]
  connect_bd_intf_net -intf_net tx_pulse_shaping_and_interpolation_5_M_AXIS_DATA [get_bd_intf_pins QPSK_TX_on_Xband_dac0/M_AXIS_DATA] [get_bd_intf_pins radio_rfdc/s00_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_vout00 [get_bd_intf_ports vout00] [get_bd_intf_pins radio_rfdc/vout00]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_GMII_ENET0 [get_bd_intf_pins sgmii/gmii_gem_pcs_pma2] [get_bd_intf_pins zynq_ultra_ps_e_0/GMII_ENET0]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_GMII_ENET1 [get_bd_intf_pins sgmii/gmii_gem_pcs_pma] [get_bd_intf_pins zynq_ultra_ps_e_0/GMII_ENET1]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_MDIO_ENET0 [get_bd_intf_pins sgmii/mdio_pcs_pma2] [get_bd_intf_pins zynq_ultra_ps_e_0/MDIO_ENET0]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_MDIO_ENET1 [get_bd_intf_pins sgmii/mdio_pcs_pma] [get_bd_intf_pins zynq_ultra_ps_e_0/MDIO_ENET1]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins ps8_0_axi_periph/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]

  # Create port connections
  connect_bd_net -net RF_interface_conv_Xband_mm2s_introut [get_bd_pins RF_interface_conv_Xband/mm2s_introut] [get_bd_pins concat_interrupt/In0]
  connect_bd_net -net RF_interface_conv_Xband_s2mm_introut [get_bd_pins RF_interface_conv_Xband/s2mm_introut] [get_bd_pins concat_interrupt/In1]
  connect_bd_net -net axcache_coherenet_dout [get_bd_pins dma_hpc_config/dout] [get_bd_pins zynq_ultra_ps_e_0/saxigp0_arcache] [get_bd_pins zynq_ultra_ps_e_0/saxigp0_awcache]
  connect_bd_net -net axprot_unsecure_dout [get_bd_pins dma_hpc_config/dout1] [get_bd_pins zynq_ultra_ps_e_0/saxigp0_arprot] [get_bd_pins zynq_ultra_ps_e_0/saxigp0_awprot]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins QPSK_TX_on_Xband_dac0/aclk] [get_bd_pins RF_interface_conv_Xband/m_axis_aclk] [get_bd_pins radio_rfdc/s0_axis_aclk]
  connect_bd_net -net concat_interrupt_dout [get_bd_pins concat_interrupt/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
  connect_bd_net -net rst_ps8_0_49M_peripheral_aresetn [get_bd_pins RF_interface_conv_Xband/axi_resetn] [get_bd_pins axi_smc/aresetn] [get_bd_pins ps8_0_axi_periph/ARESETN] [get_bd_pins ps8_0_axi_periph/M00_ARESETN] [get_bd_pins ps8_0_axi_periph/M01_ARESETN] [get_bd_pins ps8_0_axi_periph/S00_ARESETN] [get_bd_pins radio_rfdc/s_axi_aresetn] [get_bd_pins rst_ps8_0_49M/peripheral_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_0_emio_gpio_o [get_bd_pins sgmii/Din] [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins RF_interface_conv_Xband/m_axi_sg_aclk] [get_bd_pins axi_smc/aclk] [get_bd_pins ps8_0_axi_periph/ACLK] [get_bd_pins ps8_0_axi_periph/M00_ACLK] [get_bd_pins ps8_0_axi_periph/M01_ACLK] [get_bd_pins ps8_0_axi_periph/S00_ACLK] [get_bd_pins radio_rfdc/s_axi_aclk] [get_bd_pins rst_ps8_0_49M/slowest_sync_clk] [get_bd_pins sgmii/independent_clock_bufg] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/saxihpc0_fpd_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins QPSK_TX_on_Xband_dac0/ext_reset_in] [get_bd_pins rst_ps8_0_49M/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0xA0040000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs RF_interface_conv_Xband/axi_dma_Xband_txrx/S_AXI_LITE/Reg] SEG_axi_dma_Xband_txrx_Reg
  create_bd_addr_seg -range 0x00040000 -offset 0xA0000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs radio_rfdc/usp_rf_data_converter_0/s_axi/Reg] SEG_usp_rf_data_converter_0_Reg
  create_bd_addr_seg -range 0x000800000000 -offset 0x000800000000 [get_bd_addr_spaces RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_HIGH] SEG_zynq_ultra_ps_e_0_HPC0_DDR_HIGH
  create_bd_addr_seg -range 0x000800000000 -offset 0x000800000000 [get_bd_addr_spaces RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_HIGH] SEG_zynq_ultra_ps_e_0_HPC0_DDR_HIGH
  create_bd_addr_seg -range 0x000800000000 -offset 0x000800000000 [get_bd_addr_spaces RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_HIGH] SEG_zynq_ultra_ps_e_0_HPC0_DDR_HIGH
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] SEG_zynq_ultra_ps_e_0_HPC0_QSPI

  # Exclude Address Segments
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_MM2S/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_S2MM/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs RF_interface_conv_Xband/axi_dma_Xband_txrx/Data_SG/SEG_zynq_ultra_ps_e_0_HPC0_LPS_OCM]



  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


