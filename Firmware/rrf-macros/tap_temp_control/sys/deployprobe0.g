; /sys/deployprobe.g  v2.0
; Used to controll nozzle temps while probing with Voron TAP

; ====================---------------------------------------------------------
; Settings & variable declarations
; ====================

; Temperature settings, change these as you see fit!
var Probe_Temp          = 150                                                  ; The temperature you wish the nozzle to have while probing
var Tolerance           = 5                                                    ; Probing will start at this amount of degrees ABOVE var.Probe_Temp (if the hotend is already cooling down)

; Don't touch anything bellow this point!
; -----------------------------------------------------------------------------
var Max_Temp            = {var.Probe_Temp + var.Tolerance}                     ; Calculate var.Max_Temp
var Actual_Temp         = (heat.heaters[1].current)                            ; The current/actual hotend themp when a probe is initialized
var Target_Temp         = (heat.heaters[1].active)                             ; The active/target hotend temp when a probe is initialized

if !exists(global.probing)
  global probing        = false

if global.probing = false
  if !exists(global.hotend_temp)
    global hotend_temp  = (var.Target_Temp)
  set global.hotend_temp = (var.Target_Temp)

; ====================---------------------------------------------------------
; Temperature adjustement & info
; ====================

; Temperature target is higher than Probing temperature
if var.Target_Temp > (var.Probe_Temp)
  if global.probing = false
    echo "Extruder temperature target of " ^ var.Target_Temp ^ "°C is too high, lowering to " ^ var.Probe_Temp ^ "°C"
    set global.probing  = true
    G10 S{var.Probe_Temp} P0                                                   ; Set hotend temperature to var.Probe_Temp
    M116 H1                                                                    ; Wait for the hotend to reach probing temperature

; Temperature target is already low enough, but nozzle may still be too hot
if var.Actual_Temp > (var.Max_Temp)
  if global.probing     = false
    echo "Extruder temperature " ^ var.Actual_Temp ^ "°C is still too high, waiting until below " ^ var.Max_Temp ^ "°C"
    set global.probing  = true
    G10 S{var.Probe_Temp} P0                                                   ; Set hotend temperature to var.Probe_temp
    M116 H1 S{var.Tolerance}                                                   ; Wait for the hotend to reach var.Max_Temp