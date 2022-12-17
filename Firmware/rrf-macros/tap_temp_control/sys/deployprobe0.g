; /sys/deployprobe.g
; Used to controll nozzle temps while probing with Voron TAP

var Probe_Temp = 150
var Max_Temp = {var.Probe_Temp + 5}
var Actual_Temp = (heat.heaters[1].current)
var Target_Temp = (heat.heaters[1].active)

if !exists(global.hotend_temp)
  global hotend_temp = (var.Target_Temp)

set global.hotend_temp = (var.Target_Temp)

if var.Target_Temp > (var.Probe_Temp)
  
  ; Uncomment this line if you don't want to get echo spammed
  echo "Extruder temperature target of " ^ var.Target_Temp ^ "°C is too high, lowering to " ^ var.Probe_Temp ^ "°C"
  
  G10 S{var.Probe_Temp} P0                                                     ; Set hotend temperature to var.Probe_Temp
  M116 H1                                                                      ; Wait hotend to reach it's temperature
else
  ; Temperature target is already low enough, but nozzle may still be too hot
  if var.Actual_Temp > (var.Max_Temp)
    
    ; Uncomment this line if you don't want to get echo spammed
    echo "Extruder temperature " ^ var.Actual_Temp ^ "°C is still too high, waiting until below " ^ var.Max_Temp ^ "°C"
    
    G10 S{var.Probe_Temp} P0                                                   ; Set hotend temperature to var.Probe_temp
    M116 H1 S5                                                                 ; Wait hotend to reach it's temperature +-5°C