; /sys/homeall.g
; Called to home all axes
; Configured for sensorless homing / stall detection on a Duet 3 Mini 5+

; Homing selection
var SensorLessHoming    = true                                                 ; If enabled (true) sensorless XY homing will be used

; Nozzle clearance (gets overridden if you have global.Nozzle_CL)
var Clearance           = 5                                                    ; The "safe" clearance you want to have between the noszzle and bed before moving the printhead

; Don't touch anyting bellow this point(unless you know what you're doing)!!
; -----------------------------------------------------------------------------

if exists(global.Nozzle_CL)
  set var.Clearance = {global.Nozzle_CL}

; LED status
if exists(global.sb_leds)
  set global.sb_leds = "homing"

; ====================---------------------------------------------------------
; Lower Z axis
; ====================

; Lower speed & accel
M98 P"/sys/lib/speed/speed_probing.g"                                          ; set low speed & accel

; Lower Z(bed) relative to current position
M98 P"/sys/lib/current/z_current_low.g"                                        ; Set low Z currents
if !move.axes[2].homed                                                         ; If Z ain't homed
  G91                                                                          ; Relative positioning
  G1 Z{var.Clearance} F9000 H1                                                 ; Lower Z(bed) relative to current position
  G90                                                                          ; Absolute positioning
elif move.axes[2].userPosition < {var.Clearance}                               ; If Z is homed and less than var.Clearance
  G1 Z{var.Clearance} F9000                                                    ; Move to Z var.Clearance

; ====================---------------------------------------------------------
; Home X & Y axis
; ====================

; Prepare for homing
M98 P"/sys/lib/current/xy_current_low.g"                                       ; Set low XY currents
M400                                                                           ; Wait for current moves to finish
G91                                                                            ; Relative positioning

; Endstops
if !var.SensorLessHoming
  ; Coarse home X or Y
  G1 X600 Y600 F2400 H1                                                        ; Move quickly to X or Y endstop(first pass)

  ; Coarse home X
  G1 X600 H1                                                                   ; Move quickly to X endstop(first pass)

  ; Coarse home Y
  G1 Y600 H1                                                                   ; Move quickly to Y endstop(first pass)

  ; Move away from the endstops
  G1 X-5 Y-5 F9000                                                             ; Go back a few mm

  ; Fine home X
  G1 X600 F360 H1                                                              ; Move slowly to X axis endstop(second pass)

  ; Fine home Y
  G1 Y600 H1                                                                   ; Move slowly to Y axis endstop(second pass)

; Sensorless
if var.SensorLessHoming
  ; Enable stealthChop on XY steppers
  M569 P0.0 D3 V10                                                             ; Set X axis driver in stealthChop mode
  M569 P0.1 D3 V10                                                             ; Set Y axis driver in stealthChop mode

  ; Enable XY steppers
  M17 X Y                                                                      ; Enable steppers for stealthChop tuning
  G4 P200                                                                      ; Wait 200ms to allow stealthChop to establish the motor parameters.

  ; Enable Y axis stall detection
  M915 X Y S8 R0 F0 H200                                                       ; Set stall detection sensitivity(-128 to +127), action type, filter mode and  minimum motor full steps per second

  ; First pass
  G1 X600 Y600 F7000 H1                                                        ; Move quickly to X or Y axis max and stop there

  ; First pass
  G1 X600 H1                                                                   ; Move quickly to X axis max

  ; First pass
  G1 Y600 H1                                                                   ; Move quickly to Y axis max

  ; Go back a few mm
  G1 X-5 Y-5 F9000                                                             ; Go back a few mm

  ; Second pass
  G1 X600 F3600 H1                                                             ; Move slowly to X axis max

  ; Second pass
  G1 Y600 H1                                                                   ; Move slowly to Y axis max

  ; Disable stealthChop on XY steppers
  M569 P0.0 D2                                                                 ; Set X axis driver in spread cycle mode
  M569 P0.1 D2                                                                 ; Set Y axis driver in spread cycle mode

G90                                                                            ; Absolute positioning

; ====================---------------------------------------------------------
; Home Z axis
; ====================

; Home Z
M98 P"/sys/lib/goto/bed_center.g"                                              ; Move to bed center
G30 K0 Z-99999                                                                 ; Probe the center of the bed
M400                                                                           ; Wait for moves to finish

; ====================---------------------------------------------------------
; Finish up
; ====================

; Restore full currents, speed & accel
M98 P"/sys/lib/current/xy_current_high.g"                                      ; Set high XY currents
M98 P"/sys/lib/current/z_current_high.g"                                       ; Restore normal Z currents
M98 P"/sys/lib/speed/speed_printing.g"                                         ; Restore normal speed & accels

; Uncomment the following lines to lower Z(bed) after probing
G90                                                                            ; Absolute positioning
G1 Z{global.Nozzle_CL} F2400                                                   ; Move to Z global.Nozzle_CL

; If using Voron TAP, report that probing is completed
if exists(global.TAPPING)
  set global.TAPPING = false
  M402 P0                                                                      ; Return the hotend to the temperature it had before probing

;LED status
if exists(global.sb_leds)
  set global.sb_leds = "ready"