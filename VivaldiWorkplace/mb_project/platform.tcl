# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct D:\VivaldiWorkplace\mb_project\platform.tcl
# 
# OR launch xsct and run below command.
# source D:\VivaldiWorkplace\mb_project\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {mb_project}\
-hw {D:\VivadoWorkplace\aula7\mb_design_wrapper.xsa}\
-proc {microblaze_0} -os {standalone} -fsbl-target {psu_cortexa53_0} -out {D:/VivaldiWorkplace}

platform write
platform generate -domains 
platform active {mb_project}
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
catch {platform remove mb_design_wrapper}
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform clean
platform generate
platform active {mb_project}
platform generate -domains 
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform generate -domains 
platform active {mb_project}
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform active {mb_project}
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform clean
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform clean
platform clean
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
bsp reload
platform active {mb_project}
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
bsp reload
catch {bsp regenerate}
platform clean
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform clean
platform clean
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform clean
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform clean
platform clean
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform clean
platform clean
platform clean
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform clean
platform active {mb_project}
bsp reload
platform clean
platform generate
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform generate -domains 
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform generate -domains 
platform active {mb_project}
platform config -updatehw {D:/VivadoWorkplace/aula7/mb_design_wrapper.xsa}
platform generate
