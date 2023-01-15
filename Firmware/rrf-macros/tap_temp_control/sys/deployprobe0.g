; /sys/deployprobe.g  v3.0
; Used to controll nozzle temps while probing with Voron TAP

; ====================---------------------------------------------------------
; Settings section
; ====================

; Temperature settings, change these as you see fit!
var Probe_Temp          = 150                                                  ; The temperature you wish the nozzle to have while probing
var Tolerance           = 5                                                    ; Probing will start at this amount of degrees ABOVE var.Probe_Temp (if the hotend is already cooling down)

; Don't touch anything bellow this point!
; ====================---------------------------------------------------------
; Prep phase
; ====================

var Max_Temp            = {var.Probe_Temp + var.Tolerance}                     ; Calculate var.Max_Temp
var Actual_Temp         = (heat.heaters[1].current)                            ; The current/actual hotend themp when a probe is initialized
var Target_Temp         = (heat.heaters[1].active)                             ; The active/target hotend temp when a probe is initialized

if !exists(global.TAPPING)
  global TAPPING        = false

if global.TAPPING = false
  ; Create/ovewrite he_temps.g to store Tool 0 active temp
  echo >"/sys/lib/he_temp.g" "; /sys/lib/he_temps.g  v1.0"                                         ; Create/overwrite file and save line to he_temp
  echo >>"/sys/lib/he_temp.g" "; Created by deployprobe.g to store Tool O active temperature "     ; Save line to he_temp
  echo >>"/sys/lib/he_temp.g"                                                                      ; Save line to he_temp
  echo >>"/sys/lib/he_temp.g" "G10 P0 S" ^{heat.heaters[1].active}                                 ; Save line to he_temp

; ====================---------------------------------------------------------
; Temperature adjustement & info
; ====================

; Temperature target is higher than Probing temperature
if var.Target_Temp > (var.Probe_Temp) && global.TAPPING = false
  var msg = "Extruder temperature target of " ^ var.Target_Temp ^ "°C is too high, lowering to " ^ var.Probe_Temp ^ "°C"
  M291 P{var.msg} T4
  set global.TAPPING  = true
  G10 P0 S{var.Probe_Temp}                                                   ; Set hotend temperature to var.Probe_Temp
  M116 H1                                                                    ; Wait for the hotend to reach probing temperature

; Temperature target is already low enough, but nozzle may still be too hot
if var.Actual_Temp > (var.Max_Temp) && global.TAPPING = false
  var msg = "Extruder temperature " ^ var.Actual_Temp ^ "°C is still too high, waiting until below " ^ var.Max_Temp ^ "°C"
  M291 P{var.msg} T4
  set global.TAPPING  = true
  G10 P0 S{var.Probe_Temp}                                                   ; Set hotend temperature to var.Probe_temp
  M116 H1 S{var.Tolerance}                                                   ; Wait for the hotend to reach var.Max_Temp