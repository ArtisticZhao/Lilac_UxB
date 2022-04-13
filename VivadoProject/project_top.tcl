# Author: ArtisticZhao
# Organization: LilacSat, BY2HIT
#
# Release:
#   - Ver. 0.0.0
#     - Date: 31 Oct. 2021
#     - Note: Create the project construction.
#

# Set the name of the project:
set project_name Lilac_UxB

# Set the project device:
set device xczu28dr-ffvg1517-2-i

# Set the path to the directory we want to put the Vivado build in. Convention is <PROJECT NAME>_hw
set proj_dir ./work/${project_name}_hw

create_project -name ${project_name} -force -dir ${proj_dir} -part ${device}
# Add verilog file to project.
add_files {RTL/QPSK_TX/Repeater.v RTL/QPSK_TX/QPSK_data_converter.v}

# UI layout file can save the bd's layout.
set ui_name Lilac_UxB_bd_layout.ui
# Source the BD file, BD naming convention is project_bd.tcl
source Lilac_UxB_bd.tcl
# BD name
set bd_name design_1

# Set the path to the constraints file:
set impl_const ./constraints/Lilac_UxB_constraints.xdc

if [file exists ${impl_const}] {
    add_files -fileset constrs_1 -norecurse ./${impl_const}
    set_property used_in_synthesis true [get_files ./${impl_const}]
}

make_wrapper -files [get_files ${proj_dir}/${project_name}.srcs/sources_1/bd/${bd_name}/${bd_name}.bd] -top

add_files -norecurse ${proj_dir}/${project_name}.srcs/sources_1/bd/${bd_name}/hdl/${bd_name}_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

validate_bd_design
save_bd_design
close_bd_design ${bd_name}

# If using UI, uncomment these two lines:
file mkdir ${proj_dir}/${project_name}.srcs/sources_1/bd/${bd_name}/ui
file copy -force ${ui_name} ${proj_dir}/${project_name}.srcs/sources_1/bd/${bd_name}/ui/${ui_name}

open_bd_design ${proj_dir}/${project_name}.srcs/sources_1/bd/${bd_name}/${bd_name}.bd
set_property synth_checkpoint_mode None [get_files ${proj_dir}/${project_name}.srcs/sources_1/bd/${bd_name}/${bd_name}.bd]

