; M48.g  v1.0
; Called as response to M48
; Used to run probe repeatability test

; ====================---------------------------------------------------------
; Settings & variable declarations
; ====================

; Safe to change
var Probes              = 10                                                   ; The number of times to probe the bed during the test

; Don't touch anyting bellow this point!
; -----------------------------------------------------------------------------
var Message = "Do you want to run a test with " ^ var.Probes ^ " probes?"

; Ask to make sure you want to level the bed or not
M291 S3 R"Probe repeatability test" P{var.Message}

; LED status
set global.sb_leds = "leveling"

; ====================---------------------------------------------------------
; Prepare to probe
; ====================

;M118 P2 S"Please wait..."  ; send message to paneldue
;M118 P3 S"Please wait..."  ; send message to DWC console
set var.Message = "Executing " ^ var.Probes ^ " probes. Please wait..."

M291 S1 R"Probe repeatability test" P{var.Message} T0

M561                                                                           ; Clear any bed transform
M290 R0 S0                                                                     ; Reset baby stepping
M84 E0                                                                         ; Disable extruder stepper

; Lower currents, speed & accel
M98 P"/sys/lib/current/xy_current_low.g"                                       ; Set low XY currents
M98 P"/sys/lib/current/z_current_low.g"                                        ; Set low Z currents
M98 P"/sys/lib/speed/speed_probing.g"                                          ; Set low speed & accel

; Lower Z relative to current position if needed
if !move.axes[2].homed                                                         ; If Z ain't homed
  G1 Z{global.TAP_clearance} F9000 H1                                          ; Lower Z(bed) relative to current position	
elif move.axes[2].userPosition < {global.TAP_clearance}                        ; If Z is homed and less than global.TAP_clearance
  G1 Z{global.TAP_clearance} F9000                                             ; Move to Z global.TAP_clearance

; ====================---------------------------------------------------------
; Home all axes
; ====================

; Home X & Y axis if one of them isn't homed allready
if !move.axes[0].homed || !move.axes[1].homed                                  ; If X & Y axes aren't homed

  ; Home X & Y axis
  ; Coarse home X & Y
  G1 X600 Y600 F2400 H1                                                        ; Move quickly to X or Y endstop(first pass)

  ; Coarse home X
  G1 X600 H1                                                                   ; Move quickly to X endstop(first pass)

  ; Coarse home Y
  G1 Y600 H1                                                                   ; Move quickly to Y endstop(first pass)

  ; Move away from the endstops
  G91                                                                          ; Relative positioning
  G1 X-5 Y-5 F9000                                                             ; Go back a few mm
  G90                                                                          ; Absolute positioning

  ; Fine home X
  G1 X600 F360 H1                                                              ; Move slowly to X axis endstop(second pass)

  ; Fine home Y
  G1 Y600 H1                                                                   ; Move slowly to Y axis endstop(second pass)

; Home Z axis
M98 P"/sys/lib/goto/bed_center.g"                                              ; Move to bed center
G30 K0 Z-99999                                                                 ; Probe the center of the bed
M400                                                                           ; Wait for moves to finish

; ====================---------------------------------------------------------
; Probing code
; ====================

M558 K0 F180 A1

var loopCounter = 0
while true
  G30 P{var.loopCounter} K0 Z-9999
  set var.loopCounter = iterations
  if iterations = var.Probes - 1
    G30 P{var.loopCounter} K0 Z-9999 S-1
    break

M558 K0 F300:180 A3

; ====================---------------------------------------------------------
; Finish up
; ====================

; Uncomment the following lines to lower Z(bed) after probing
G90                                                                            ; Absolute positioning
G1 Z{global.TAP_clearance} F2400                                               ; Move to Z global.TAP_clearance

; Full currents, speed & accel
M98 P"/sys/lib/current/z_current_high.g"                                       ; Restore normal Z currents
M98 P"/sys/lib/current/xy_current_high.g"                                      ; Set high XY currents
M98 P"/sys/lib/speed/speed_printing.g"                                         ; Restore normal speed & accels

;set var.Message = "Probe repeatability test with " ^ var.Probes ^ " probes complete"
set var.Message = "" ^ var.Probes ^ " probes complete, see console"

M291 S1 R"Probe repeatability test" P{var.Message} T5                          ; Test done message

set global.probing = false
M402 P0                                                                        ; Return the hotend to the temperature it had before probing

; LED status
set global.sb_leds = "ready"