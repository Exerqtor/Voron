; /sys/deployprobe.g  v1.1
; Used to controll nozzle temps while probing with Voron TAP

var Probe_Temp = 150
var Max_Temp = {var.Probe_Temp + 5}
var Actual_Temp = (heat.heaters[1].current)
var Target_Temp = (heat.heaters[1].active)

if !exists(global.hotend_temp)
  global hotend_temp = (var.Target_Temp)

set global.hotend_temp = (var.Target_Temp)

if !exists(global.nospam)
  global nospam = false

if var.Target_Temp > (var.Probe_Temp)
  if global.nospam = false
    echo "Extruder temperature target of " ^ var.Target_Temp ^ "°C is too high, lowering to " ^ var.Probe_Temp ^ "°C"
    set global.nospam = true
  else
    ; Don't echo!
  G10 S{var.Probe_Temp} P0                                                     ; Set hotend temperature to var.Probe_Temp
  M116 H1                                                                      ; Wait hotend to reach it's temperature
else
  ; Temperature target is already low enough, but nozzle may still be too hot
  if var.Actual_Temp > (var.Max_Temp)
    if !global.nospam
    echo "Extruder temperature " ^ var.Actual_Temp ^ "°C is still too high, waiting until below " ^ var.Max_Temp ^ "°C"
    set global.nospam = true
  else
    ; Don't echo!
    G10 S{var.Probe_Temp} P0                                                   ; Set hotend temperature to var.Probe_temp
    M116 H1 S5                                                                 ; Wait hotend to reach it's temperature +-5°C
